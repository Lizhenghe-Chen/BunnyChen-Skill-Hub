@echo off
rem Windows 便捷入口：双击或在本目录执行 install.cmd 即可安装到 VS Code Copilot
rem 所有参数原样透传给 install.ps1，例如：
rem   install.cmd -All
rem   install.cmd -Uninstall
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
set EXITCODE=%ERRORLEVEL%
endlocal & exit /b %EXITCODE%
