---
name: frontend-design
description: '前端设计品味与交互规范（桌面+移动端通用）。使用场景：新建/美化/重构页面或组件、"设计得有辨识度"、"好看点但别像 AI 模板"、UI 评审、改造已有界面的 AI 味、要求"不要千篇一律"。核心流程：先读需求定调（布局气质/动效强度/信息密度三轴），再执行反 AI 味设计原则，交付前过自检清单。方法论主体为 taste-skill，附通用落地范例。'
argument-hint: '描述界面类型、目标用户与风格关键词，如"一个面向年轻用户的记账应用首页"'
---

# Frontend Design（前端设计品味）

目标：让界面**不像 AI 生成的模板**——有明确设计主张、有辨识度、有交互感，同时桌面/移动端都成立、性能与可访问性达标。
方法论主体：[taste-skill](https://github.com/Leonxlnx/taste-skill)（含其全部子技能，MIT License · Copyright © 2026 Leonxlnx）；含通用落地范例（见 [落地范例](./references/style-directions.md)）。

## 工作流（三步，别跳）

### 1. 先定调（读需求，不猜）
读 5 个信号：界面类型（落地页/产品界面/后台/移动应用/重设计）、风格关键词（"极简"、"苹果感"、"好玩"、"B2B 严肃"……）、受众、已有品牌资产（logo/色/字）、硬约束（无障碍/政务/儿童优先于审美）。
输出一行 **Design Read**：「这是面向 X 的 Y，走 Z 风格，配 W 基础」。关键词→基调映射见 [风格方向库](./references/style-directions.md)。
歧义时只问**一个**问题（如「更像 Linear 干净还是 Awwwards 实验？」），能推断就不问。

### 2. 定基调（三轴，低/中/高）
- **布局气质**：对称稳定 ↔ 大胆错落（高错落必须声明 <768px 单列回退）
- **动效强度**：静态 ↔ 电影感（高于低必须尊重 `prefers-reduced-motion`）
- **信息密度**：通透画廊 ↔ 紧凑驾驶舱（高密度：数字用等宽、用 1px 分隔线替代卡片）

### 3. 执行 + 自检
按下方设计原则执行；交付前过「快速自检」。交付完整：不做 `// TODO` 式省略，中途超限用 `[PAUSED — X of Y complete]` 续写。

## 设计原则（核心，AI 默认病 → 改法）

### 排版
- 默认 Inter/系统字体 = AI 味。选有辨识度字体：Geist / Outfit / Satoshi / Cabinet Grotesk；中文用有品质感的黑体 + 等宽数字
- 衬线仅在品牌明确要编辑/奢侈/杂志感时用，且不用 Fraunces / Instrument Serif 当默认
- 标题层级靠字重+颜色，不靠无限放大；正文 max 65ch；强调词用同族 italic/bold，不跨字体族
- 数字用等宽/tabular-nums；杜绝孤行单词（`text-wrap: balance/pretty`）

### 配色
- 中性底（Zinc/Slate/Stone，全项目统一冷或暖）+ **最多 1 个强调色**，饱和度 < 80%
- 禁 AI 紫/蓝渐变、禁纯黑纯白（off-black/off-white）
- 强调色全页唯一并锁死；高品质消费类禁用默认"米色+黄铜+咖啡"套路，轮换冷银/森林/钴蓝+奶油等
- 暗色模式提亮提饱和（真实项目验证），避免近黑吞掉主题色；阴影染底色，不纯黑投影

### 布局
- 反居中：默认不用居中 Hero；用非对称 split、错落网格
- 禁三等分卡片；zigzag 最多连续 2 段；同一页每个 section 换布局家族（8 段 ≥ 4 族）
- Hero 纪律：标题 ≤2 行、副文 ≤20 词、最多 4 个文本元素、CTA 首屏可见、顶部 padding 封顶
- Bento：N 内容 = N 格（`grid-flow-dense` 不留空）；至少 2-3 格有真实视觉变化
- eyebrow（小号大写标签）最多每 3 段 1 个
- Grid 优先，禁 flex 百分比数学；宽屏 `auto-fill/minmax` 自适应（>1920px 加列不拉伸）

### 质感
- 卡片只在层级需要时用，否则用间距/分隔线；圆角体系锁定（全锐/全柔/全胶囊，规则明确）
- 玻璃拟态仅高端消费/品牌场景：内描边+内高光+固体回退；噪点只放 `fixed pointer-events-none` 层

### 交互状态
- 必做四态：loading（骨架屏贴合布局，不用转圈）、空态（引导行动，双卡引导）、错误态（行内提示，不 alert）、按压反馈（scale 0.98 / translateY 1px）
- 按钮对比度 WCAG AA（正文 4.5:1 / 大字 3:1）；CTA 桌面不换行；同一意图 CTA 全页一个文案
- 表单 label 在上、错误在下，placeholder 不作 label；触控目标 ≥44px；焦点环必须有

### 动效
- 每个动效一句话说得出动机（层级/叙事/反馈/状态变化），说不出就删；全页跑马灯最多 1 个
- 只动 transform/opacity；禁 window.scroll 监听；连续值不写进 React state（用 motion values）
- 骨架与模式词汇见 [动效规范](./references/motion.md)

### 文案与资产
- 禁 AI 陈词（Elevate/Seamless/Unleash）、假精确数字（92%、4.1x）、John Doe/Acme、Lorem Ipsum
- Hero 要有真实视觉：生成图 > 真实图（picsum seed）> 明确标注的占位槽；禁 div 拼假产品截图
- 交付前通读所有可见字符串，语法破碎/指代不明/AI 腔就重写

## 快速自检（交付前必过）
- [ ] 一行 Design Read 声明过？三轴基调明确？
- [ ] 强调色全页唯一、圆角体系一致、明/暗主题全页锁定？
- [ ] 按钮/表单对比度达标，CTA 不换行？
- [ ] 每个 section 布局不同族，Hero 符合纪律？
- [ ] 动效都有动机，reduced-motion 已降级？
- [ ] 桌面单行导航，多列布局有 <768px 单列回退，`min-height:100dvh` 非 `h-screen`？
- [ ] loading/空/错误三态齐？
- [ ] 红线清单过一遍（见 [禁忌清单](./references/anti-ai-slop.md)）？
- [ ] 暗色模式两态都实测过？

## 红线（绝不）
- ❌ AI 紫/蓝渐变、纯黑、Inter 默认、居中 Hero、三等分卡片、满页玻璃、无限循环微动效堆砌
- ❌ div 拼的假截图、装饰性小圆点/准星线/填充进度条、滚动提示文案、假版本号、假精确数字
- ❌ 为"炫"加动效、超范围大改（改造已有项目先看 [改造协议](./references/redesign.md)）

## 示例对照
- ✅ 落地项目：撞色竖条 KPI 卡（每卡一色）、玻璃渐变背景+噪点、空态双卡引导、auto-fill 网格、移动端底部抽屉+浮动胶囊导航、暗色主题提亮
- ❌ 紫渐变 + 居中 + 三等分 + 每段 eyebrow + div 假截图 + 转圈 loading

## 子文档路由（按需读取，勿全量载入）
| 需要什么 | 读 |
|---|---|
| 完整 AI 味禁忌清单 | [references/anti-ai-slop.md](./references/anti-ai-slop.md) |
| 风格方向库+落地范例 | [references/style-directions.md](./references/style-directions.md) |
| 动效规范+模式词汇+骨架 | [references/motion.md](./references/motion.md) |
| 改造已有项目 | [references/redesign.md](./references/redesign.md) |
