# 动效与交互规范

> 来源：taste-skill §5-§7、soft-skill、minimalist。动效是工具不是默认——使用前先回答"它传达什么？"。

## 铁律
1. **动机先行**：每个动效一句话说得出目的（层级 / 叙事 / 反馈 / 状态变化），"好看"不算理由，说不出的删掉
2. **只动 transform / opacity**：禁 top/left/width/height 动画
3. **禁滚动监听**：`window.addEventListener('scroll')`、scrollY 进 React state 全禁 → 用 Motion `useScroll` / GSAP ScrollTrigger / IntersectionObserver / CSS scroll-driven animations
4. **连续值不进 state**：鼠标 / 滚动 / 物理量用 `useMotionValue` + `useTransform`，否则每帧重渲染
5. **reduced-motion**：动效强度高于"低"必须降级为静态/瞬移；无限循环、视差、滚动劫持全部收敛
6. **blur 纪律**：`backdrop-blur` 只加固定/粘性元素（导航、遮罩），不加滚动容器；噪点只放 `fixed pointer-events-none` 层
7. **z-index 只用系统层**：内容 < 导航 < FAB < 弹窗 < 遮罩 < Toast，写进项目常量文件

## 曲线与物理
- 默认缓出曲线 `cubic-bezier(0.16, 1, 0.3, 1)`；交互反馈用 spring（`stiffness: 100, damping: 20`），不用 linear
- 按压：`scale(0.98)` 或 `translateY(1px)`；hover 图片：容器 `overflow-hidden` + 图 `scale-105` + 700ms ease-out
- 入场 stagger：`whileInView` + `delay: i * 0.06`、`viewport { once: true, amount: 0.3 }`；列表不一次性全挂载

## 模式词汇（知道名字，按需选用）
- **Hero**：非对称 Split / 编辑宣言 / 视频文字遮罩 / 动态排版 / 卷帘揭示
- **导航**：Dock 放大 / 磁吸按钮 / 胶囊浮动导航 + 汉堡变 X / 全屏玻璃菜单 stagger 链接
- **卡片**：视差倾斜 / 聚光边框 / 玻璃面板 / 滑动卡片堆 / 变形弹窗
- **滚动叙事**：粘性堆叠（sticky-stack）/ 横向平移（horizontal-pan）/ 缩放视差 / SVG 路径描线 / 文字逐词擦除
- **微交互**：方向感知填充按钮 / 点击涟漪 / 骨架微光 / 液体下拉刷新
- 跑马灯全页最多 1 个；库选择：Motion 管 UI 状态，GSAP 管滚动叙事，**不同时混在一个组件树**

## 骨架踩坑重点（GSAP ScrollTrigger）
**粘性堆叠 sticky-stack**：每张卡 `sticky top-0 min-h-[100dvh]`；除最后一张外都 pin；前卡的缩放/透明度由**下一张卡**的 ScrollTrigger 驱动，`start: "top top"`、`scrub: true`、`pinSpacing: false`。
**横向平移 horizontal-pan**：外层 pin + `overflow-hidden`；内轨位移 = `scrollWidth - innerWidth`；`end: () => "+=" + distance`、`scrub: 1`、`invalidateOnRefresh: true`。
常见失败：trigger 写成 `"top center"` 导致滚到一半才触发——必须 `start: "top top"`。
React 中包 `useEffect` + `gsap.context()` + `ctx.revert()` 清理；轻量场景优先 `whileInView`，不上 GSAP。
