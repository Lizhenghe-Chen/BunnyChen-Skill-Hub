# AI 味禁忌清单（Anti-AI-Slop）

> 汇总自 taste-skill §9.A–9.G、gpt-taste、redesign、stitch、minimalist/soft/brutalist 等文档。这些是"AI 想装专业"的签名模式——除非需求明确点名，否则禁用。逐条过。

## 视觉与 CSS
- ❌ AI 紫/蓝渐变、按钮辉光、随机霓虹渐变——默认禁用；品牌点名紫色才可用（此时也要克制、配色成体系）
- ❌ 纯黑 `#000000` / 纯白 `#FFFFFF`——用 off-black / off-white
- ❌ 过饱和强调色（饱和度 > 80%）
- ❌ 大标题渐变文字
- ❌ 自定义鼠标光标
- ❌ 霓虹外发光、默认 box-shadow 辉光——用内描边或染底色的浅阴影
- ❌ 完美均匀的 45° 线性渐变——用径向/网格渐变 + 噪点打破均匀
- ❌ 无纹理的纯平面——背景加噪点/微纹理/环境光晕（低成本质感提升）

## 排版
- ❌ Inter 当默认（替代：Geist / Outfit / Satoshi / Cabinet Grotesk；政务、无障碍优先场景可例外）
- ❌ 巨型 H1 硬吼——层级靠字重+颜色，不靠字号
- ❌ 仪表盘/应用 UI 用衬线
- ❌ 跨字体族强调词（sans 标题里塞一个衬线词）——同族 italic/bold
- ❌ 孤行单词——`text-wrap: balance/pretty`
- ❌ 标题全大写小标签泛滥（eyebrow 每 3 段最多 1 个，先数再写）
- ❌ 衬线默认用 Fraunces / Instrument Serif（LLM 最爱两款）
- ❌ 只用 400/700 两档字重——引入 500/600 做层次

## 布局
- ❌ 居中 Hero + 深色网格背景
- ❌ 三等分等宽卡片
- ❌ 3+ 连续 zigzag 图文交替
- ❌ 每段同一种布局家族（8 段 ≥ 4 族）
- ❌ Bento 留空格——`grid-flow-dense`，N 内容 = N 格
- ❌ flex 百分比数学（`calc(33% - 1rem)`）——用 CSS Grid
- ❌ `h-screen`——用 `min-height: 100dvh`
- ❌ 卡片套卡片、巨型圆角包裹一切
- ❌ 装饰性准星/网格线、为"显得设计过"画的线——只用于组织真实内容
- ❌ 元素互相叠压（除明确的分层设计）——各占清晰空间

## Hero 专属
- ❌ 标题 4+ 行——这是字号错误，不是文案错误
- ❌ 副文 > 20 词、文本元素 > 4 个、CTA 首屏之外
- ❌ 顶部 padding 过大（桌面 `pt-24` 封顶）
- ❌ CTA 下方的 mini tagline、信任条（"Used by engineering teams at…"）、定价预告、头像墙——移到独立 section
- ❌ 版本号 eyebrow（V0.6 / BETA / EARLY ACCESS，除非是发布需求）
- ❌ "Brand · No. 01" 式微元标签、装饰文字条（BRAND. MOTION. SPATIAL.）
- ❌ 滚动提示（Scroll / 下滑箭头 / 弹跳 chevron）
- ❌ div 拼的假产品截图（假终端/假仪表盘/假任务列表）——用真实截图、生成图或真组件
- ❌ 天气/城市/时间条（除非品牌真实需要）

## 文案与数据
- ❌ AI 陈词：Elevate、Seamless、Unleash、Next-Gen、Game-changer、Delve、Tapestry、Revolutionize
- ❌ 假精确数字：92%、4.1x、48k、5.8mm——用真实数据或标注 mock
- ❌ John Doe / Sarah Chan / Acme / Nexus / SmartFlow / Lorem Ipsum
- ❌ 语法破碎/AI 幻觉句（"free on its past"式）、装深思的伪谦虚（"we plan to stay that way"式）
- ❌ 感叹号成功提示、"Oops!" 式错误——直接说："Connection failed. Please try again."
- ❌ 被动语态错误消息（"Mistakes were made"）
- ❌ 引号内装饰 em-dash；引用 > 3 行；署名只有名字（"– Sarah"）
- ❌ 每行都 border-t + border-b 的长列表/规格表——换卡片、分组、折叠、scroll-snap
- ❌ 带底色轨道的进度条做对比图
- ❌ 一页 20 行数据表——3-5 条高亮 + "View full list"

## 交互与组件
- ❌ 白按钮白字、透明按钮无描边——WCAG AA 4.5:1（大字 3:1）
- ❌ CTA 桌面换行
- ❌ 同一意图多个文案（Get in touch + Contact us + Let's talk）——每意图一个标签，全页一致
- ❌ 转圈 loading——骨架屏贴合布局形状
- ❌ 空态只写 "No data"
- ❌ 死链接 `#`、alert() 报错
- ❌ 无 focus ring、无 hover/active 反馈、0ms 瞬间切换
- ❌ 装饰性彩色状态点（每行/每个导航前）——仅真实语义状态可用，且限量
- ❌ `window.addEventListener('scroll')`、scrollY 进 React state
- ❌ 任意 `z-50` / `z-[9999]`——系统层级表：内容 < 导航 < FAB < 弹窗 < 遮罩 < Toast，写进常量

## 图标与图片
- ❌ 手搓 SVG 图标路径——用 Phosphor / Radix / Tabler（Lucide 仅项目已有或点名）
- ❌ 火箭=Launch、盾牌=Security 式陈词隐喻
- ❌ 图标笔画宽度不统一
- ❌ 破碎 Unsplash 链接——用 `picsum.photos/seed/{描述}/{w}/{h}`
- ❌ 纯文字假 logo 墙——用 Simple Icons SVG 或生成单字母标志；logo 墙 = 只有 logo，不贴行业标签
- ❌ 图片上贴标签/编号胶囊、装饰性摄影署名（"Field study no. 12 · Ines Caetano"）
- ❌ 通用商务写真、陈词机器人图
- ❌ 营销页页脚版本号（v1.4.2 / Build 0048）
- ❌ emoji 当 UI 元素（除非需求点名社交/俏皮风，也要克制）
