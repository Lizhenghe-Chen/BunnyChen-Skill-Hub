#Requires -Version 5.1
<#
.SYNOPSIS
    一键安装本仓库所有技能到各主流 Agent 平台的用户技能目录（Windows / PowerShell 版）。

.DESCRIPTION
    与 install.sh 等价：优先创建 NTFS 符号链接（SymbolicLink），
    若当前账户既非管理员也未开启「开发者模式」而无法创建符号链接，
    则自动回退为目录联接（Junction）——效果等价，VS Code 等工具可正常读取，
    git pull 更新后同样立即生效。

.EXAMPLE
    .\install.ps1
    安装到 %USERPROFILE%\.copilot\skills（VS Code Copilot，默认）

.EXAMPLE
    .\install.ps1 -All
    安装到全部受支持的平台

.EXAMPLE
    .\install.ps1 -Uninstall
    移除已安装的链接（不会删除仓库中的技能本体）

.NOTES
    若提示「禁止运行脚本」，可改用：
    powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
#>
[CmdletBinding()]
param(
    [switch]$Copilot,
    [switch]$Claude,
    [switch]$Cursor,
    [switch]$OpenCode,
    [switch]$Codex,
    [switch]$Agents,
    [switch]$All,
    [switch]$Uninstall,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# 让 Windows PowerShell 5.1 控制台正确显示中文（仅影响当前会话）
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

# 直接 P/Invoke Windows API 创建符号链接。
# 原因：Windows PowerShell 5.1 的 New-Item -ItemType SymbolicLink 不传
# SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE(0x2) 标志，故即使已开启「开发者模式」
# 也会报「此操作需要管理员权限」，这里自行调用 API 以利用开发者模式。
$SymlinkApiReady = $false
try {
    Add-Type -Namespace BunnyChen -Name SymlinkNative -MemberDefinition @'
[System.Runtime.InteropServices.DllImport("kernel32.dll", CharSet = System.Runtime.InteropServices.CharSet.Unicode, SetLastError = true)]
private static extern bool CreateSymbolicLinkW(string lpSymlinkFileName, string lpTargetFileName, int dwFlags);

public static bool TryCreate(string linkPath, string targetPath, int flags)
{
    return CreateSymbolicLinkW(linkPath, targetPath, flags);
}
'@ -ErrorAction Stop
    $SymlinkApiReady = $true
}
catch {
    $SymlinkApiReady = $false
}

# 平台标识 -> 用户技能目录（Agent Skills 开放标准）
$PlatformDirs = [ordered]@{
    copilot  = Join-Path $env:USERPROFILE '.copilot\skills'
    claude   = Join-Path $env:USERPROFILE '.claude\skills'
    cursor   = Join-Path $env:USERPROFILE '.cursor\skills'
    opencode = Join-Path $env:USERPROFILE '.config\opencode\skills'
    codex    = Join-Path $env:USERPROFILE '.codex\skills'
    agents   = Join-Path $env:USERPROFILE '.agents\skills'
}

function Show-Usage {
    @'
用法: .\install.ps1 [选项]

  默认安装到 %USERPROFILE%\.copilot\skills（VS Code Copilot）
  -Claude      安装到 ~/.claude/skills（Claude Code；Cursor/OpenCode 兼容加载）
  -Cursor      安装到 ~/.cursor/skills（Cursor）
  -OpenCode    安装到 ~/.config/opencode/skills（OpenCode）
  -Codex       安装到 ~/.codex/skills（OpenAI Codex CLI）
  -Agents      安装到 ~/.agents/skills（跨平台兼容目录）
  -All         安装到以上全部平台
  -Uninstall   移除已安装的链接
  -Help        显示本帮助

说明：优先创建真符号链接（开启 Windows「开发者模式」后无需管理员权限即可）；
      仅在仍然无法创建时，才回退为目录联接（Junction），两者效果一致。
      macOS / Linux / Git Bash 用户请改用 ./install.sh
'@ | Write-Host
}

# 判断路径是否存在链接（符号链接 / 目录联接），返回其类型，否则返回 $null
function Get-LinkType {
    param([string]$Path)

    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if (-not $item) { return $null }
    if ($item.LinkType) { return $item.LinkType }
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) { return 'ReparsePoint' }
    return $null
}

# 删除链接本身（不会递归删除链接指向的真实目录内容）
function Remove-Link {
    param([string]$Path)

    [System.IO.Directory]::Delete($Path, $false)
}

# 创建链接：先试符号链接，失败回退目录联接；返回实际创建的类型
function New-SkillLink {
    param([string]$LinkPath, [string]$TargetPath)

    # 0x1 = 目标为目录，0x2 = 允许非特权创建（开发者模式，无需管理员）
    if ($SymlinkApiReady) {
        if ([BunnyChen.SymlinkNative]::TryCreate($LinkPath, $TargetPath, 0x3)) { return 'SymbolicLink' }
        # 旧版 Windows 不识别 0x2 标志，再按传统方式试一次（需管理员或已授予该特权）
        if ([BunnyChen.SymlinkNative]::TryCreate($LinkPath, $TargetPath, 0x1)) { return 'SymbolicLink' }
    }

    # 回退：目录联接（Junction），普通用户即可创建，效果等价
    New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath -ErrorAction Stop | Out-Null
    return 'Junction'
}

if ($Help) {
    Show-Usage
    exit 0
}

# 收集目标平台；未指定时默认仅安装到 VS Code Copilot
$selected = @()
if ($All) {
    $selected = @($PlatformDirs.Keys)
}
else {
    if ($Copilot)  { $selected += 'copilot' }
    if ($Claude)   { $selected += 'claude' }
    if ($Cursor)   { $selected += 'cursor' }
    if ($OpenCode) { $selected += 'opencode' }
    if ($Codex)    { $selected += 'codex' }
    if ($Agents)   { $selected += 'agents' }
    if ($selected.Count -eq 0) { $selected = @('copilot') }
}

$srcDir = Join-Path $PSScriptRoot 'skills'
if (-not (Test-Path -LiteralPath $srcDir -PathType Container)) {
    Write-Host '❌ 未找到 skills/ 目录，请确认 install.ps1 位于仓库根目录' -ForegroundColor Red
    exit 1
}

$ops = 0
foreach ($platform in $selected) {
    $dest = $PlatformDirs[$platform]
    if (-not $Uninstall) {
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
    }

    foreach ($skillDir in Get-ChildItem -LiteralPath $srcDir -Directory) {
        $name = $skillDir.Name
        $target = Join-Path $dest $name
        $linkType = Get-LinkType -Path $target

        if ($Uninstall) {
            if ($linkType) {
                Remove-Link -Path $target
                Write-Host "🗑️  已卸载: $target"
                $ops++
            }
            continue
        }

        if (-not $linkType -and (Test-Path -LiteralPath $target)) {
            Write-Host "⚠️  $name 已存在于 $dest 且不是链接（保留原目录，跳过）"
            continue
        }

        if ($linkType) { Remove-Link -Path $target }
        $created = New-SkillLink -LinkPath $target -TargetPath $skillDir.FullName
        Write-Host "✅ 已安装技能: $name -> $target ($created)"
        $ops++
    }
}

Write-Host ''
if ($Uninstall) {
    Write-Host "完成：共卸载 $ops 个技能链接"
}
else {
    Write-Host "完成：共安装/更新 $ops 个技能"
    Write-Host '重启对应工具后，在聊天输入 / 即可看到技能。'
}
exit 0
