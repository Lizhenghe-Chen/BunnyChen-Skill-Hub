# 风格方向库与落地范例

> 定调后的选择表：风格关键词 → 基调 → 设计基因。融合 taste-skill 的设计系统映射、各风格子技能（minimalist / soft / brutalist / gpt-taste / stitch）与自有记账应用落地经验。

## 基调推断（低/中/高）
| 风格关键词 | 布局气质 | 动效强度 | 信息密度 |
|---|---|---|---|
| 极简 / 干净 / 平静 / 编辑 / Linear 风 | 低-中 | 低-中 | 低-中 |
| 高端消费 / 苹果感 / 奢侈 / 品牌 | 中-高 | 中-高 | 低-中 |
| 好玩 / 疯狂 / Dribbble / Awwwards / 实验 | 高 | 高 | 中 |
| 落地页 / 作品集 / 营销页（默认） | 中-高 | 中-高 | 中 |
| 信任优先 / 政务 / 无障碍关键 | 低 | 低 | 中-高 |
| 重设计-保留 | 维持现状 | +1 档 | 维持 |
| 重设计-翻新 | +1 档 | +1 档 | 维持 |

## 已有官方设计系统时（别手搓）
| 场景 | 用官方包 |
|---|---|
| 微软 / 企业 SaaS / 仪表盘 | `@fluentui/react-components` 或 web-components |
| Material 风格产品 | `@material/web` + M3 tokens |
| IBM 风 B2B / 分析 | `@carbon/react` + `@carbon/styles` |
| Shopify 应用 | Polaris |
| Atlassian 风 | `@atlaskit/*` |
| GitHub 风开发者工具 | `@primer/css` / `@primer/react-brand` |
| 英/美政务 | `govuk-frontend` / `uswds` |
| 现代 React 基础 | Radix Themes；自有组件用 shadcn/ui（禁默认态） |

规则：一套系统一个项目，不混用；选了官方包就用它的 token，不要改 90% 后再手写。

## 美学方向速查（无官方包时）
| 方向 | 基因要点 |
|---|---|
| 极简编辑风（minimalist） | 暖单色底 + 编辑衬线标题 + 寡淡粉彩强调 + 1px `#EAEAEA` 边 + 8-12px 圆角 + "看不见的动效"（600ms 淡入、scale 0.98 按压） |
| 高端柔软风（soft） | 双边框嵌套（Doppelrand 外壳+内核）、超大 squircle 圆角、按钮内嵌圆图标（Button-in-Button）、`py-24~40` 大留白、spring 曲线、玻璃胶囊导航 |
| 玻璃 / 科幻风 | 近黑底 + 径向网格光晕 + 重 `backdrop-blur` + 白/10 发丝边；只适合 SaaS / AI / 科技 |
| Awwwards 风（gpt-taste） | AIDA 结构（Hero→Bento→滚动叙事→CTA）、2-3 行宽标题 `clamp(3rem,5vw,5.5rem)`、`grid-flow-dense` Bento、GSAP 钉住/堆叠/擦除、图片加 CSS 滤镜去股票感 |
| 粗野 / 工业风（brutalist） | 瑞士排版 + 军用终端：全大写超紧排 `clamp(4rem,10vw,15rem)`、0 圆角、可见网格线、单色 + 警示红、等宽元数据、扫描线/半调纹理 |

## 自有项目落地范例（应用类 UI 可直接借鉴）
- **撞色标识**：KPI 卡左侧 3px 彩色竖条，每卡一色（绿/橙/蓝/紫）；图表 10 色调色板保证扇区区分度
- **主题三态**：亮/暗/跟随系统用 CSS 变量；暗色提亮提饱和，避免近黑吞掉主题色；5 套配色预设动态注入 `<style>`
- **玻璃渐变背景**：body 微纹理 + 光晕 + 底层纯色，页面四层共用，保证状态栏区与内容区背景一致
- **宽屏自适应**：`auto-fill, minmax(165px, 1fr)`；≥1200px 固定 5 列；>1920px 自动加列不拉伸
- **移动端形态**：底部抽屉式浮窗（`align-items: flex-end` + `100dvh` 安全区计算）、右下浮动胶囊导航（Home 条上方留 14px）、触控目标 ≥44px
- **空态引导**：双卡片引导（手动添加 / 导入订单），图标 + 标签 + 描述
- **打磨细节**：6px 滚动条美化、`:focus-visible` 焦点环、skip-link、噪点叠加层 opacity 0.04

## 记住
- 相邻两个项目不要用同一套配色/字体组合（轮换，品牌才有辨识度）
- 风格是"主张"不是"装饰"：每个选择要能解释为什么符合这个产品和它的用户
- 安全区适配：`env(safe-area-inset-*, 0px)` 在每个使用处直接写，不经 CSS 变量中转（iOS WKWebView 解析 bug）
