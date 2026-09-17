# Playful Outline / 灵动描线

## Style Identity

- **Definition**: 无阴影、无组件描边的平面交互风格，以相邻色面的明度差、圆形与胶囊控件、柔和波浪分区和有节奏的状态动画组织界面。轮廓来自色块自身的边缘，不是沿组件外围画一圈线。
- **Core Feeling**: 轻快、有触感、清楚直接；丰富的是交互反馈，静止时的页面保持安静。
- **Visual Keywords**: borderless, flat color fields, tonal contrast, circular controls, organic wave seams, elastic feedback, rhythmic transition。
- **iOS Interpretation**: 保留 Button、Toggle、TextField、sheet 和无障碍语义，用相邻色面、波浪边缘和有限的几何变化表达个性。所有组件和内容区域都不加包围线，不依靠投影、玻璃或拟物高光。
- **Reference boundary**: 用户最新明确要求：所有控件、卡片与弹层不用线条包围区域；白色、强调色、深色面通过颜色差与波浪边界分区和融合。参考图中的小图标线条不意味着给每个组件描边，不要求复制黄色或制作播放器，设备投影与封面立体效果也不进入本风格。

## Best Use Cases

- Suitable screens: 创意工具、轻量记录、音频控制、探索页、交互教学与小型工具。
- Suitable product moods: 友好、活泼、带有编辑节奏，同时保持信息清晰。
- Suitable content types: 少量重点内容、状态切换、动作反馈与短说明。
- Best audience fit: 希望在原生可用性基础上获得鲜明交互个性的开发者和用户。

## Avoid When

- Do not use for: 高频交易、密集表格或需要同时比较大量字段的界面。
- Risky contexts: 多个控件同时循环运动，或把重要信息放在波浪裁切区域内。
- Accessibility concerns: 相邻色面区分不足、小字号低对比、无文字的开关状态、过强弹性、弹窗焦点泄漏。
- Product mismatch: 无阴影不代表无层级，动画丰富不代表自动播放和持续摇晃。

## Visual Tokens

### Color Tokens

- Primitive: paper `#F6FAF7`、surface `#FFFFFF`、tint `#E0EEE6`、control `#D0E3D8`、ink `#233B33`、muted `#52685F`、mint `#BDE7D5`、mint-deep `#23775F`、error `#A93832`、error-surface `#FAE6E1`。
- Semantic: 背景使用 paper；主文字和深色主控件使用 ink；相邻内容区使用 surface、tint、mint 的明度差；次要控件使用 control；选中说明使用 mint-deep；错误文字使用 error，错误字段背景使用 error-surface。
- Component: 主要按钮为 ink 底、paper 字；次要按钮为较浅色面、ink 字，所有按钮均无描边。Switch 通过轨道、滑块和底面之间的色差表达层级；图标与状态文字补足含义。
- 配色可替换，但必须保持背景、墨色、单一强调色和错误色的角色关系。薄荷绿是本次参考实现，不是风格成立的唯一条件。

### Typography Tokens

- Display: 系统 rounded largeTitle，black 字重，靠字号和留白形成强弱，不使用装饰性字距。
- Title: rounded title2 / title3，bold。
- Body: 系统 body / callout，常规或 medium 字重，支持 Dynamic Type。
- Label: subheadline / caption；完整控件不以 11 pt 以下字形传递必要信息。首页缩略标本按卡片几何缩放，VoiceOver 提供完整名称。

### Shape / Radius Tokens

- Surface: 主详情使用全宽色面与波浪边界拼接，不把每个分区包在圆角卡片内；弹层和确有边界的独立控件可保留柔和圆角。
- Button: Circle 或 Capsule；轮廓直接来自填色形状的边缘。禁止组件外框、内圈、双框或用线条补轮廓。
- Card: 沿用 Mira 首页卡片尺寸和外圆角，内部保留风格自己的波浪边界。
- Control: 开关轨道为 64 × 36 pt 胶囊，交互区域不小于 64 × 44 pt；组件描边为 0。增强对比度时加强色面与文字差异，不重新加边框。

### Elevation / Material Tokens

- Surface depth: 通过白、浅薄荷、薄荷和深色块的对比、波浪边界、留白与遮罩表达前后关系。
- Shadow: 所有首页卡片、按钮、Switch、详情内容与自绘弹窗均为零阴影；禁止外阴影、内阴影和发光。
- Blur / material: 不使用实时模糊或玻璃材质。系统 sheet 作为原生辅助出口，由系统负责呈现。
- Border: 所有组件与区域描边为 0，不使用细线或粗线包围面板。分区依靠相邻色面与波浪拼接，不用装饰分隔线。勾、箭头等图标自身的笔画不属于组件边框，可以保留。

## Layout Rules

- Composition: 详情页是一个可操作的动效工作台，首屏先显示风格名称和深绿色实心节拍圆。白色、浅薄荷与薄荷分区通过全宽波浪色面拼接、融合，引导到按钮、Switch 和弹窗实验区；不要用一个圆角框把主舞台与所有内容包起来。搜索与输入区展示错误、空结果、加载和重试，末尾保留 token 与 prompt 指导。
- Grid: 内容区单列，宽屏限制最大阅读宽度；控件组合通过 ViewThatFits、垂直重排或横向滚动适配。
- Spacing: 当前实现使用 8 / 12 / 16 / 20 / 24 / 28 / 32 / 36 pt 的组内节奏；主详情堆叠间距为 0，每个色面分区左右 24 pt、顶部 48 pt、底部通常 36 pt。波浪分区振幅为 16 pt，阶段间改变相位。按信息关系选间距，不要求每个页面机械使用全部档位。
- Density: 每一区域只有一个主要动效；说明与参数不能占满主舞台。
- Hierarchy: 主动作使用深色实心圆或胶囊，辅助动作使用较浅填色，不画空心框。当前选择同时有图标或文字。
- Safe area: 顶部返回和底部弹层操作位于安全区域内；弹窗在小屏或大字号下允许滚动。
- Color-field sequence: hero 下半部 mint 连到读数；控件区 paper 波浪接 mint；转场区 tint 波浪接 paper；输入区 paper 波浪接 tint；最后规范区 surface 波浪接 paper。相邻分区保持连续，不留出像卡片间距一样的断口。

## Component Guidance

- Navigation: 顶部 44 pt 以上的实色圆形返回按钮；主详情在自己的 NavigationStack 中打开三阶段动效二级页。iOS 18 使用有明确来源的 zoom 转场，Reduce Motion 下使用普通原生导航。二级页保留系统返回与页面内返回操作。
- Button: SwiftUI Button 配合 ButtonStyle。按下时填色形状轻压、图标微移或旋转，释放时短弹簧回位；支持主、次、选中、禁用与破坏性操作。次要按钮保留形变，但不加双框；全部无描边、无阴影。
- Switch: 原生 Toggle 配合自定义 ToggleStyle；开启轨道为 ink、关闭轨道为 control，surface 滑块沿轨道平移，状态变化时短暂拉伸后收回；勾选/横线与可访问性值共同说明开关状态。
- Home Card: 未配置 screenshotAssetName 时是一张静态平面标本，薄荷波浪与深绿色实心圆形节拍标记形成主构图，标题和短说明位于清楚的实色区。配置截图时改用铺满并裁切的截图，底部文字使用不透明 paper 底；两种模式都不加组件外围线。按压只触发一段局部反馈。闲置及首页拖动时不运行循环动画，标题保留 `miStyleTitleTransition(style.id)`。
- Sheet / Modal: 自绘确认弹窗采用平面色遮罩、无框色面和圆形状态符号，以色差隔离层级。打开时遮罩隔离背景，面板短距离升起；确认后切换为勾线完成态，再由明确的完成按钮关闭。保留取消、背景轻点、VoiceOver escape 等退出路径。原生 sheet 展示提示词说明，可通过拖动和按钮切换高度，正文独立滚动。
- Form: 有可见标签的 TextField，以 tint 默认底、mint 焦点底和 error-surface 错误底区分状态，焦点保留输入光标，不画边框；非空时提供 44 pt 清除动作，错误说明邻近字段，提交不能产生静默失败。搜索结果共用一个白色面，不加逐行分隔线。
- Tab / Segmented Control: 使用 Button 和共享选中底片表达当前章节；选中语义不能只依靠颜色，切换动画应可打断。
- Filter / Tag: 横向可滚动的无框填色胶囊，选中带勾，禁用同时降低对比并禁用动作。
- Empty state: 可恢复的空结果与清除条件按钮；加载和失败状态通过显式演示入口触发，重试可回到有内容的状态。
- Paywall / subscription surface: 可应用同样按钮和分区语言，但不在本 demo 中增加价格、付费能力或商业承诺。

### Runtime Component Interfaces

以下接口是本风格模块的复用入口。具体状态放在拥有该状态的页面或组件中，不增加全局动画管理器。

| Interface | Contract |
| --- | --- |
| `MiPlayfulOutlineButtonStyle(filled: Bool = false, destructive: Bool = false)` | 应用于原生 Button；胶囊形状、最小高度 48 pt。`filled` 区分深色主动作与浅色次动作，两者都无边框；`destructive` 选择错误色，破坏性语义仍由宿主的 `Button(role: .destructive)` 提供。禁用通过 `.disabled` 传入。按下轻压并改变填色或不透明度；Reduce Motion 只保留颜色与透明度反馈。 |
| `MiPlayfulOutlineCircleButtonStyle(filled: Bool = false)` | 52 × 52 pt 填色圆形按钮，无外框或内圈。用于返回、关闭等单图标动作，宿主必须提供本地化可访问性名称；禁用由 `.disabled` 控制。 |
| `MiPlayfulOutlineToggleStyle()` | 应用于 `Toggle`；64 × 36 pt 轨道位于至少 44 pt 高的交互区。滑块短暂横向拉伸后复位，勾与横线标示状态；适配从右向左布局，并通过 accessibility representation 保留系统 Toggle 语义。Reduce Motion 直接更新滑块位置。 |
| `MiPlayfulOutlineDialog(onDismiss: () -> Void, onConfirm: () -> Void)` | 宿主控制是否呈现；组件内部管理打开、确认、完成与关闭。确认时仅调用一次 `onConfirm`，并留在完成态；完成、取消、背景轻点或 escape 最终调用 `onDismiss`。宿主不可在 `onConfirm` 中立即移除弹窗，否则会丢失完成反馈。 |
| `MiPlayfulOutlineSegment(titles: [String], selection: Binding<Int>, disabledIndices: Set<Int> = [])` | `titles` 是本地化 key，`selection` 必须属于数组有效且可用的索引。内部为横向可滚动 Button 组，选中项同时有实心底片、勾与 selected trait；`disabledIndices` 中的按钮禁止激活并降低不透明度。输入筛选演示传入 `[4]`。普通模式共享几何底片，Reduce Motion 改为无位移切换或短淡化。 |
| `MiPlayfulOutlineSheet(titleKey: String, onClose: () -> Void, content: () -> Content)` | 放在宿主的原生 `.sheet` 内。支持 `.height(280)`、`.medium`、`.large` 三档，默认 medium；按钮与系统拖动均可切档，正文滚动，关闭与 escape 调用 `onClose`。可访问性大字号默认展开至 large；竖直紧凑环境禁用 medium 按钮。 |
| `MiPlayfulOutlineMotionDetailView()` | 独立二级页，展示聚合、拉伸、落定三个阶段；Segment 直接选择阶段，下一步在末阶段变为重播，重置在初始阶段禁用。通过环境 dismiss 返回，不复制首页路由状态。 |

### Host Integration

- 首页通过 `MiStyleRepository`、`MiStyleCardView` 与 `MiAppRootView` 接入；`MiPlayfulOutlineModule` 提供 style ID、Design.md 路径与详情入口。
- 主舞台的唯一操作入口是 182 × 182 pt 的深绿色实心圆按钮，节拍线与播放/暂停图标属于同一个 Button。圆按钮和相邻全宽波浪色面形成前后关系，不用圆角卡片包围。下方两个读数分别报告主动播放状态和曲线运行状态；不再嵌套另一个小型播放按钮。182 pt 是本次演示尺寸，不是所有页面的强制控件尺寸。
- 节拍 hero 的主动开关与实际运行条件分开：只有用户开启、页面可见、scene 为 active、未被 sheet/dialog/二级页覆盖且没有 Reduce Motion 时才持续更新。暂停后保留用户选择；不可用新定时器叠加旧任务。
- Button、Switch 和 Dialog 实验区必须给出可观察的状态结果。弹窗打开时，宿主停止节拍并禁止背景交互、隐藏背景辅助功能元素；关闭后按原运行条件恢复。
- 自绘 Dialog 负责 modal trait、标题焦点、完成勾线和退出动画；宿主负责背景焦点隔离。确认操作更新演示状态，取消不更新成功状态，快速重复确认不重复执行。
- 提示词面板用 `MiPlayfulOutlineSheet` 承载，正文包含实际风格约束。三个 detent 与滚动提供短预览、阅读和完整展开的连续路径；系统 sheet 的呈现由系统负责，不添加自绘投影或玻璃层。
- 主详情负责为二级页提供唯一的 zoom 来源与对应 destination；Reduce Motion 下绕过自定义 zoom 配置，保留原生导航和完整返回路径。
- 二级页的形变实体使用 accent-strong，完成态使用 ink，图标使用 surface；形状本身无外框、内圈或双框，保留收拢、舒展、落定三阶段。
- 搜索/输入区展示默认、焦点、已填、清空与相邻错误文案。空结果允许清空条件；加载和失败由显式演示操作触发，重试能回到内容态，不访问真实服务或宣称真实业务结果。
- token 区分颜色值与参数值：`mi-po-outline = 0` 表示无组件描边，`mi-po-shadow = 0` 表示无阴影，二者使用文字，不解析为色块。prompt 指导沿用本文件的约束，避免重复另一套风格定义。

## iOS / SwiftUI Notes

- Runtime module: `Mira/Features/Styles/PlayfulOutline/`，类型和文件统一使用 `MiPlayfulOutline` 前缀。
- SwiftUI primitives: ButtonStyle、ToggleStyle、Shape、AnimatablePair、phaseAnimator、matchedGeometryEffect、contentTransition、NavigationStack、navigationTransition、matchedTransitionSource、sheet、presentationDetents、FocusState。
- Recommended modifiers: 用明确的状态值驱动动画；自绘波浪只承担分区与进度反馈，不伪装成图片或真实音频数据。
- Native controls to preserve: Button 激活、Toggle 语义、TextField 焦点和键盘、sheet 关闭、VoiceOver modal 焦点与 escape。
- Performance notes: 首页保持静态；详情中的节拍动画仅在用户主动开启、页面可见、scene active 且未被覆盖时运行，退出、后台、弹层、二级页或 Reduce Motion 时暂停。不使用叠加模糊、阴影或脱离视图生命周期的无限异步任务。
- Dynamic Type notes: 说明、按钮标签、弹窗和输入框按语义字号伸缩；大字号下优先垂直重排，不压缩必要文字。

## Motion Rules

- Personality: Playful，轻快但不夸张。统一使用短弹簧，不能每个控件各自选择一种节奏。
- Duration palette: 短反馈约 100–160 ms；控件回弹复用 `MiPlayfulOutlineTokens.response`，即 response 0.32、dampingFraction 0.76；弹层打开约 400 ms，关闭约 200 ms。Reduce Motion 的淡化约 120–180 ms。
- Transition: 先维持视觉锚点，再完成短距离移动、轻微缩放和淡化；退场比入场更短。内容应在动效未完成时仍能响应操作。
- Press feedback: 主要变化为轻压或轮廓形变；辅助图标可做小幅旋转；禁止用阴影变化代替反馈。
- Switch feedback: 位移是主动作，短暂拉伸是辅助动作，状态图标是结果；Reduce Motion 时直接切换位置，仅淡化颜色或图标。
- Dialog feedback: 打开 → 确认 → 完成 → 关闭的完整状态链；确认后显示绘制出的勾和状态文案，取消不产生成功反馈。
- Sheet feedback: 拖动或高度按钮改变原生 detent，当前档位有文字与勾选反馈。Reduce Motion 下移除自定义切档动画，系统呈现遵循系统设置。
- Secondary-page feedback: 聚合、拉伸、落定由用户逐步触发，快速切换以最新选择为准；Reduce Motion 下阶段形状直接替换，说明与图标短淡化，不执行形变或波浪运动。
- Loading: 有明确状态文字，持续运动只存在于正在进行的演示中；失败提供重试，模拟数据必须标注为演示。
- Gesture response: 快速连续点击应以最新状态为准；避免堆积延迟回调，异步工作应随视图生命周期取消。
- Reduced motion fallback: 关闭位移、旋转、拉伸、缩放和循环节拍；保留短淡化、填色变化、选中图标、状态文案与完整操作能力。

## Accessibility

- Contrast: 主要文字使用 ink，辅助文字使用 muted，彩色容器上也检查至少 4.5:1 的普通文字对比度。
- VoiceOver: 首页卡片为单一可操作元素；Toggle 宣告状态；弹窗隔离背景焦点、聚焦标题并支持 escape；装饰波浪和节拍线隐藏于辅助功能树。
- Dynamic Type: 章节、输入和弹窗可增高；检查最大可访问性字号及较窄 iPhone。
- Touch target: 所有真实按钮至少 44 × 44 pt。首页标本内的图形不伪装成独立小按钮。
- Color-only meaning: 选中、播放、开关、失败与完成都有图标或文字。

## Prompt Guidance

### Use This Style When Prompt Says

- Trigger phrases: Playful Outline、灵动描线、无描边平面交互、实色圆按钮、流动色块、有机波浪分区、丰富但克制的弹性动效。
- Related product scenarios: 创意记录、轻量音频界面、动效演示、友好的小工具。

### AI Output Should Include

- Visual direction: 轮廓来自相邻色面的边缘，通过全宽波浪拼接与流动色块建立层级，使用独立配色，不依赖参考图的黄色。
- Token suggestions: 白色背景、不同明度的强调色面、深色主控件、错误背景与文字色，圆与胶囊形状，零组件描边、零阴影。
- Component behavior: 按钮与 Switch 的按下/切换/释放，弹窗完整状态链，章节转场和输入恢复路径。
- SwiftUI notes: 保留控件语义、可打断动画、视图消失时取消持续工作。
- Risks and acceptance checks: 运动强度、对比度、大字号、弹窗焦点、快速重复输入和首页性能。

## Anti-patterns

- 不添加投影、拟物高光、毛玻璃或发光来补层次。
- 不沿组件外围或内部加包围线，不以双圈、细框或分隔线代替色面边缘。图标自身的勾线和箭头笔画可以保留。
- 不把主舞台和每个页面分区全部塞进圆角卡片；使用开放的全宽波浪色面拼接。
- 不以粗边框、硬阴影或高饱和黄黑配色把它变成 Neo-Brutalism。
- 不复制参考图的封面、品牌或音乐内容；示例节拍是交互演示，不宣称真实音频播放。
- 不让所有元素持续跳动，不在首页重复卡片中使用 TimelineView 或 repeatForever。
- 不用纯颜色表达开关状态，不让弹窗只支持手势关闭。
- 不把风格定义简化成“圆按钮加弹簧动画”；色面边缘、波浪拼接、信息节奏和状态完成度同样重要。

## Acceptance Checklist

- [ ] 首页卡片与详情页以色面边缘、实心圆控件和波浪拼接呈现平面风格，没有组件包围线。
- [ ] 主详情使用全宽波浪色面分区；次要按钮无双框，输入焦点与错误通过填色和文字区分。
- [ ] 新模块无 shadow、blur、glassEffect 或伪高光层。
- [ ] 主、次、选中、禁用和破坏性按钮都有正确行为。
- [ ] Switch 有弹性滑动、明确状态和原生可访问性语义。
- [ ] 弹窗可打开、取消、确认、显示完成并关闭，背景焦点隔离。
- [ ] 弹窗确认仅执行一次，确认后仍显示完成态；完成、取消、背景轻点与 escape 均能关闭。
- [ ] 原生 sheet 三档高度、按钮切档、滚动和关闭正常；大字号展开与横屏 medium 不可用状态正确。
- [ ] 二级页可切换三个阶段、下一步、重播、重置与返回；zoom 的来源和目标一致，Reduce Motion 走普通导航。
- [ ] 输入具备默认、焦点、已填、清空与错误状态；空结果及失败可恢复。
- [ ] 风格详情能展示导航、过滤、表面、首页卡片、token 与 prompt 指导。
- [ ] 首页闲置静止，详情持续动画只在主动开启、前台可见且未被覆盖时运行。
- [ ] Reduce Motion 下仍保留全部功能和状态反馈，且没有自定义几何运动。
- [ ] 中英文、大字号、VoiceOver、44 pt 触控目标和对比度已验证。
- [ ] 语法检查、完整构建、模拟器及真机验证分别报告，不互相替代。

以上为待执行的验收要求，未勾选项不代表已经通过运行验证。
