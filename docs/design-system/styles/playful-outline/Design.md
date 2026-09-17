# Playful Outline / 灵动描线

## Style Identity

- **Definition**: 无阴影、无组件描边的平面交互风格，以真实内容、柔和色块和清楚的文字层级组织界面。宽缓曲线只用于修饰留白、分隔区域或说明当前导航位置，不承担没有内容的装饰构图。轮廓来自色块自身的边缘。
- **Core Feeling**: 带有韩风平面设计的柔和、留白与轻快感；先读懂内容和动作，再注意到曲面细节。操作反馈短而明确，静止时保持安静。
- **Visual Keywords**: borderless, soft color fields, Korean graphic mood, meaningful whitespace, gentle single arcs, content-first components。
- **iOS Interpretation**: 保留 Button、Toggle、TextField、sheet 和无障碍语义，用相邻色面和局部缓弧区分内容与操作。所有组件和内容区域都不加包围线，不依靠投影、玻璃或拟物高光。
- **Reference boundary**: 参考图提供的是柔滑色块分区的处理方式。当前首页展示可收藏灵感便签的静态缩样，不展示播放器或 mini Tab；详情才使用三个真实 Tab。便签白色正文与薄荷操作区由一处柔和单弧曲面分隔，收藏后操作区变为杏色。不复制唱片、音乐内容、黄色品牌、设备投影或封面立体效果。

## Best Use Cases

- Suitable screens: 创意工具、轻量记录、灵感探索、组件教学与小型工具。
- Suitable product moods: 友好、活泼、带有编辑节奏，同时保持信息清晰。
- Suitable content types: 少量重点内容、状态切换、动作反馈与短说明。
- Best audience fit: 希望在原生可用性基础上获得鲜明交互个性的开发者和用户。

## Avoid When

- Do not use for: 高频交易、密集表格或需要同时比较大量字段的界面。
- Risky contexts: 多个控件同时循环运动、把重要信息放在曲面裁切区域内，或让连续波浪占据没有内容意义的大片空间。
- Accessibility concerns: 相邻色面区分不足、小字号低对比、无文字的开关状态、过强弹性、弹窗焦点泄漏。
- Product mismatch: 无阴影不代表无层级，动画丰富不代表自动播放和持续摇晃。

## Visual Tokens

### Color Tokens

- Primitive: paper `#F6FAF7`、surface `#FFFFFF`、tint `#E0EEE6`、control `#D0E3D8`、ink `#233B33`、muted `#4B6057`、mint `#BDE7D5`、mint-deep `#23775F`、apricot `#F5D1BC`、error `#A93832`、error-surface `#FAE6E1`。
- Semantic: 背景使用 paper；主文字和深色主控件使用 ink；相邻内容区使用 surface、tint、mint 与 apricot 的色差；次要控件使用 control；选中说明使用 mint-deep；错误文字使用 error，错误字段背景使用 error-surface。
- Component: 灵感便签使用 surface 正文底；收藏操作区默认 mint、收藏后 apricot，并同步更新文案和图标。主要按钮为 ink 底、paper 字，次要按钮为较浅色面、ink 字。详情底部 Tab 以深墨色与浅色流线表达选择。所有按钮无描边，Switch 以轨道、滑块和状态文字表达状态。
- Appearance: 当前 demo 固定使用明亮海报配色，宿主设置 `preferredColorScheme(.light)`，使原生状态栏、输入和弹层与固定色面协调；系统深色外观下仍保持此配色，退出后恢复 Mira 外壳的外观。此实现不包含独立深色 token。
- 配色可替换，但必须保持浅底、深墨、柔和色面和错误色的角色关系。薄荷与杏色是本次参考实现，不是风格成立的唯一条件。

### Typography Tokens

- Display: 系统 rounded largeTitle，black 字重，靠字号和留白形成强弱，不使用装饰性字距。
- Title: rounded title2 / title3，bold。
- Body: 系统 body / callout，常规或 medium 字重，支持 Dynamic Type。
- Label: subheadline / caption；完整控件不以 11 pt 以下字形传递必要信息。首页缩略标本按卡片几何缩放，VoiceOver 提供完整名称。

### Shape / Radius Tokens

- Surface: 正文以平静色面和留白组织；便签正文与操作区之间只保留一处宽缓单弧。详情 Tab 的流线需要连续位置和切线，轮廓使用高斯剖面与解析切线构造三次 Hermite / Bézier 段，避免尖谷、折角和逐段鼓包。其他区域不为展示波浪而增加曲面。
- Button: 主要文字动作使用 Capsule，返回和关闭等单图标动作可用 Circle；轮廓直接来自填色形状。禁止组件外框、内圈、双框或用线条补轮廓。
- Card: 沿用 Mira 首页卡片尺寸和外圆角，内部缩小展示真实灵感便签：白色文字区、柔和曲面分隔和收藏操作区。首页不嵌入 Tab 或可独立激活的收藏按钮。
- Control: 开关轨道为 64 × 36 pt 胶囊，交互区域不小于 64 × 44 pt；组件描边为 0。增强对比度时加强色面与文字差异，不重新加边框。

### Elevation / Material Tokens

- Surface depth: 通过白、浅薄荷、薄荷、杏色和深墨色块的对比、曲线边界、留白与遮罩表达前后关系。
- Shadow: 所有首页卡片、按钮、Switch、详情内容与自绘弹窗均为零阴影；禁止外阴影、内阴影和发光。
- Blur / material: 不使用实时模糊或玻璃材质。系统 sheet 作为原生辅助出口，由系统负责呈现。
- Border: 所有组件与区域描边为 0，不使用细线或粗线包围面板。分区优先依靠留白和相邻色面，必要时以一处柔和曲面分隔，不用装饰分隔线。勾、箭头等图标自身的笔画不属于组件边框，可以保留。

## Layout Rules

- Composition: 详情页分为三个真实目的地：灵感展示风格名称、可收藏的灵感便签和收藏结果；组件承载 Button、Switch、输入、过滤、弹层和二级动效页入口；规范承载首页缩样、token 与 prompt 指导。底部曲线 Tab 固定可用，每次选择更换可见内容，并让宽缓流线连续移动和形变。移除没有功能分区意义的全页波浪，不把 Tab 做成同一长页的装饰标签。
- Grid: 内容区单列，宽屏限制最大阅读宽度；控件组合通过 ViewThatFits、垂直重排或横向滚动适配。
- Spacing: 使用 8 / 12 / 16 / 20 / 24 / 28 / 32 / 36 pt 的组内节奏；正文左右留出约 24 pt。便签正文与曲面边缘之间保留阅读空间，各演示区通过留白组织。按信息关系选间距，不要求每个页面机械使用全部档位。
- Density: 每一区域只有一个主要动效；说明与参数不能占满主舞台。
- Hierarchy: 首屏以风格名称、便签内容和收藏动作形成主次，便签下方说明实际收藏结果；底部深色区域稳定导航位置，活动浅色流线指向当前目的地。辅助动作使用较浅填色，不画空心框。
- Safe area: 返回控件固定在滚动内容上方；Tab 通过底部安全区布局保留内容空间，图标和标签不落入 Home Indicator 区。弹窗在小屏或大字号下允许滚动。
- Color-field sequence: 便签内部以白色正文连接薄荷或杏色操作区，曲面只分隔这两种职责。详情底部浅色流线与深墨色导航相接，不做独立悬浮圆按钮；其他内容不再层层铺设全宽波浪。每个 Tab 组织自己的内容节奏，切换后保留共享收藏、弹性设置、组件章节、确认计数与输入结果。

## Component Guidance

- Navigation: 顶部 44 pt 以上的实色圆形返回按钮；主详情在自己的 NavigationStack 中打开三阶段动效二级页。iOS 18 使用有明确来源的 zoom 转场，Reduce Motion 下使用普通原生导航。二级页保留系统返回与页面内返回操作。
- Button: SwiftUI Button 配合 ButtonStyle。按下时填色形状轻压、图标微移或旋转，释放时短弹簧回位；支持主、次、选中、禁用与破坏性操作。次要按钮保留形变，但不加双框；全部无描边、无阴影。
- Switch: 原生 Toggle 配合自定义 ToggleStyle；开启轨道为 ink、关闭轨道为 control，surface 滑块沿轨道平移，状态变化时短暂拉伸后收回；勾选/横线与可访问性值共同说明开关状态。收藏开关与收藏按钮绑定同一状态；弹性开关控制底部 Tab 曲线的弹簧运动，关闭时直接切换位置和形状，不影响目的地切换。
- Home Card: 未配置 screenshotAssetName 时，使用 `MiPlayfulOutlineNoteCard` 的 compact 模式展示静态灵感便签缩样，保留可读正文和收藏操作区；下方是风格名称与短说明。缩样不接受点击，也不进入独立辅助功能顺序，整张首页卡片由外层统一打开详情。首页没有播放器、mini Tab 或装饰导航图标；按压只以收藏文案、图标与填色变化提供局部反馈，闲置和拖动时静止。配置截图时铺满并裁切，文字放在不透明可读底色上。标题保留 `miStyleTitleTransition(style.id)`。
- Note Card: `MiPlayfulOutlineNoteCard` 在详情中是实际可收藏组件，白色正文区与薄荷操作区之间以一处宽缓单弧分隔。点击操作区后，收藏文案、勾选图标、杏色填色和下方收藏结果同步更新；再次点击可取消。操作区为原生 Button，至少 44 pt 高，与组件页收藏按钮和开关读写同一状态。
- Sheet / Modal: 自绘确认弹窗采用平面色遮罩、无框色面和圆形状态符号，以色差隔离层级。打开时遮罩隔离背景，面板短距离升起；确认后切换为勾线完成态，再由明确的完成按钮关闭。保留取消、背景轻点、VoiceOver escape 等退出路径。原生 sheet 展示提示词说明，可通过拖动和按钮切换高度，正文独立滚动。
- Form: 有可见标签的 TextField，以 tint 默认底、mint 焦点底和 error-surface 错误底区分状态，焦点保留输入光标，不画边框；非空时提供 44 pt 清除动作，错误说明邻近字段，提交不能产生静默失败。搜索结果共用一个白色面，不加逐行分隔线。
- Tab / Segmented Control: 主导航为灵感、组件、规范三个真实 Tab，使用 Button 驱动当前目的地和连续曲线。导航仅用 paper 浅底和一层 ink 曲面，不叠加杏色装饰条。活动区域图标在浅底上为深墨色，其余图标在深底上为浅色；图标颜色遮罩与同一曲面同步运动，避免切换中短暂失去对比。标签位于深墨色面，以薄荷色和粗体点亮当前项，并提供 selected trait。局部按钮/开关演示与二级页仍使用 Segment，不与目的地导航混为一层。
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
| `MiPlayfulOutlineNoteCard(isSaved: Bool, compact: Bool = false, scale: CGFloat = 1, onSave: (() -> Void)? = nil)` | 白色正文、局部单弧与收藏操作区组成的内容组件。传入 `onSave` 时展示真实 Button，点击由宿主更新 `isSaved`；未传入时只展示状态。首页使用 compact 缩样并禁用命中，不嵌套按钮；详情使用语义字号与至少 44 pt 操作区。 |
| `MiPlayfulOutlineFlowTabBar(selection: Binding<Int>, isElastic: Bool = true)` | 三个本地化目的地由宿主选择状态驱动，索引为 0...2。点选更新实际内容、选中图标/标签与 selected trait，并让曲线位置和深度共同变化；各目的地深度为 42 / 48 / 40 pt，随图标尺度放大。每项至少 44 × 44 pt，文字随 Dynamic Type 增高，图标与曲线最多缩放至 1.5 倍；RTL 同时镜像按钮与曲线目标。关闭 `isElastic` 或开启 Reduce Motion 时直接更新几何状态。 |
| `MiPlayfulOutlineFlowShape(position: CGFloat, depth: CGFloat = 44, baseline: CGFloat = 18)` | 定义在 `MiPlayfulOutlineFlowTabBar.swift`，仅服务详情导航的宽缓连续流线。`position` 是归一化横坐标，限制在 0...1；`depth` 与 `baseline` 使用 pt，分别决定纵深与基础边界高度。高斯剖面宽度为容器宽度的 0.29 倍，分成 8 段，以解析切线构造三次 Hermite / Bézier 曲线；位置与深度共同参与插值，不按 Tab 插拔路径节点，不加计时器。 |
| `MiPlayfulOutlineWave(phase: CGFloat = 0, amplitude: CGFloat = 12)` | 便签等内容区域的局部缓弧，由两段连续三次曲线组成。`amplitude` 控制浅幅度分隔，`phase` 只微调曲线中点的横向位置；不是重复正弦波，不用于自动循环装饰。 |
| `MiPlayfulOutlineInspirationView(styleName: String, isSaved: Binding<Bool>)` | 首个目的地展示本地化风格名称、灵感便签和收藏结果说明。便签收藏操作读写宿主状态，与组件页按钮和开关同步；本页不单独维护收藏副本。 |
| `MiPlayfulOutlineInputDemo(state: Binding<MiPlayfulOutlineInputState>)` | 输入、筛选、提交状态和加载结果由宿主持有，切换 Tab 后保留。焦点属于输入视图，离场时退出；加载任务随视图离场取消，返回组件页时按保留的加载状态继续演示。 |
| `MiPlayfulOutlineDialog(onDismiss: () -> Void, onConfirm: () -> Void)` | 宿主控制是否呈现；组件内部管理打开、确认、完成与关闭。确认时仅调用一次 `onConfirm`，并留在完成态；完成、取消、背景轻点或 escape 最终调用 `onDismiss`。宿主不可在 `onConfirm` 中立即移除弹窗，否则会丢失完成反馈。 |
| `MiPlayfulOutlineSegment(titles: [String], selection: Binding<Int>, disabledIndices: Set<Int> = [])` | `titles` 是本地化 key，`selection` 必须属于数组有效且可用的索引。内部为横向可滚动 Button 组，选中项同时有实心底片、勾与 selected trait；`disabledIndices` 中的按钮禁止激活并降低不透明度。输入筛选演示传入 `[4]`。普通模式共享几何底片，Reduce Motion 改为无位移切换或短淡化。 |
| `MiPlayfulOutlineSheet(titleKey: String, onClose: () -> Void, content: () -> Content)` | 放在宿主的原生 `.sheet` 内。支持 `.height(280)`、`.medium`、`.large` 三档，默认 medium；按钮与系统拖动均可切档，正文滚动，关闭与 escape 调用 `onClose`。可访问性大字号默认展开至 large；竖直紧凑环境禁用 medium 按钮。 |
| `MiPlayfulOutlineMotionDetailView()` | 独立二级页，展示聚合、拉伸、落定三个阶段；Segment 直接选择阶段，下一步在末阶段变为重播，重置在初始阶段禁用。通过环境 dismiss 返回，不复制首页路由状态。 |

### Host Integration

- 首页通过 `MiStyleRepository`、`MiStyleCardView` 与 `MiAppRootView` 接入；`MiPlayfulOutlineModule` 提供 style ID、Design.md 路径与详情入口。
- 主详情持有 Tab 选择、收藏、弹性设置、组件章节、确认计数、输入状态与弹层状态。三个目的地展示各自内容，切换只改变内容视图身份，不重建底部导航容器；流线从当前画面继续过渡，不能先消失再在新位置出现。目的地滚动位置回到顶部，宿主状态保留。
- 首页与详情灵感页复用便签内容组件：详情提供真实收藏动作，首页只展示静态缩样，整卡点击仍由 Mira 首页负责。收藏结果同时反馈在操作区和便签下方的状态说明中。
- 底部曲线 Tab 只服务详情导航：同一选择驱动内容、曲线位置与深度、活动图标和标签。浅色流线与深色导航主体连续相接，图标在运动过程中也应根据实际所在色面保持对比度。
- Button、Switch 和 Dialog 实验区必须给出可观察的状态结果。收藏按钮和收藏开关同步，弹性关闭后 Tab 仍可切换；系统 Reduce Motion 优先于弹性设置。弹窗打开时，宿主禁止背景交互、隐藏包括底部 Tab 在内的背景辅助功能元素。
- 自绘 Dialog 负责 modal trait、标题焦点、完成勾线和退出动画；宿主负责背景焦点隔离。确认操作更新演示状态，取消不更新成功状态，快速重复确认不重复执行。
- 提示词面板用 `MiPlayfulOutlineSheet` 承载，正文包含实际风格约束。三个 detent 与滚动提供短预览、阅读和完整展开的连续路径；系统 sheet 的呈现由系统负责，不添加自绘投影或玻璃层。
- 主详情负责为二级页提供唯一的 zoom 来源与对应 destination；Reduce Motion 下绕过自定义 zoom 配置，保留原生导航和完整返回路径。
- 二级页的形变实体使用 accent-strong，完成态使用 ink，图标使用 surface；形状本身无外框、内圈或双框，保留收拢、舒展、落定三阶段。
- 搜索/输入区展示默认、焦点、已填、清空与相邻错误文案。输入、过滤、提交与加载结果通过 `MiPlayfulOutlineInputState` 保留；切出组件页时清除焦点并取消当前任务，返回后若仍在加载则恢复演示。空结果允许清空条件，失败可以重试；宿主禁用时清除输入焦点，错误文案首次出现时引导辅助功能焦点。不访问真实服务或宣称真实业务结果。
- token 区分颜色值与参数值：`mi-po-outline = 0` 表示无组件描边，`mi-po-shadow = 0` 表示无阴影，二者使用文字，不解析为色块。prompt 指导沿用本文件的约束，避免重复另一套风格定义。

## iOS / SwiftUI Notes

- Runtime module: `Mira/Features/Styles/PlayfulOutline/`，类型和文件统一使用 `MiPlayfulOutline` 前缀。
- SwiftUI primitives: ButtonStyle、ToggleStyle、Shape、Path.addCurve、AnimatablePair、matchedGeometryEffect、contentTransition、NavigationStack、navigationTransition、matchedTransitionSource、sheet、presentationDetents、FocusState。
- Recommended modifiers: 用明确状态驱动收藏反馈和导航曲线，把位置与深度作为可插值数据。详情流线以高斯函数求值和解析导数计算三次 Hermite 控制点，再通过 `Path.addCurve` 绘制；相邻段共享切线，不能把每个点强制设成水平切线。导航容器保持稳定身份，仅内容区切换 `.id`。RTL 下曲线目标与实际按钮位置一起镜像。
- Native controls to preserve: Button 激活、Toggle 语义、TextField 焦点和键盘、sheet 关闭、VoiceOver modal 焦点与 escape。
- Performance notes: 首页保持静态；Tab 曲线只响应选择变化，操作结束后停止更新。曲线不需要 TimelineView、repeatForever 或额外定时器；不使用叠加模糊、阴影或脱离视图生命周期的无限异步任务。
- Dynamic Type notes: 说明、按钮标签、弹窗和输入框按语义字号伸缩；大字号下优先垂直重排，不压缩必要文字。

## Motion Rules

- Personality: Playful，轻快但不夸张。按钮和开关使用短回弹，跨度较大的导航流线更缓和，收藏只需直接可读的状态反馈。
- Duration palette: 控件回弹复用 `MiPlayfulOutlineTokens.response`，即 response 0.32、dampingFraction 0.76；导航流线使用 response 0.52、dampingFraction 0.86；便签收藏填色使用 220 ms ease-out，目的地内容使用 160 ms 淡化。弹层打开约 400 ms、关闭约 200 ms。Reduce Motion 移除自定义几何运动。
- Transition: 先维持视觉锚点，再完成短距离移动、轻微缩放和淡化；退场比入场更短。内容应在动效未完成时仍能响应操作。
- Note feedback: 收藏后更新操作区填色、文案、图标与结果说明；便签分隔曲面保持稳定，不为一次收藏增加无意义的全页波动。首页按压只显示局部状态反馈，不改变收藏业务状态。
- Flow-tab feedback: 选择新 Tab 时，低谷水平位置与曲线纵深共同过渡，图标和标签同步更新；三个目的地具有可辨认的稳定曲线形状，不能只平移一张静态波浪。使用可打断的短弹簧，连续点击以最新选择为准；弹性开关关闭或 Reduce Motion 开启时，内容、位置、形状和选中状态直接更新。
- Press feedback: 主要变化为轻压或轮廓形变；辅助图标可做小幅旋转；禁止用阴影变化代替反馈。
- Switch feedback: 位移是主动作，短暂拉伸是辅助动作，状态图标是结果；Reduce Motion 时直接切换位置，仅淡化颜色或图标。
- Dialog feedback: 打开 → 确认 → 完成 → 关闭的完整状态链；确认后显示绘制出的勾和状态文案，取消不产生成功反馈。
- Sheet feedback: 拖动或高度按钮改变原生 detent，当前档位有文字与勾选反馈。Reduce Motion 下移除自定义切档动画，系统呈现遵循系统设置。
- Secondary-page feedback: 聚合、拉伸、落定由用户逐步触发，快速切换以最新选择为准；Reduce Motion 下阶段形状直接替换，说明与图标短淡化，不执行形变或波浪运动。
- Loading: 有明确状态文字，持续运动只存在于正在进行的演示中；失败提供重试，模拟数据必须标注为演示。
- Gesture response: 快速连续点击应以最新状态为准；避免堆积延迟回调，异步工作应随视图生命周期取消。
- Reduced motion fallback: 关闭曲线插值、位移、旋转、拉伸与缩放；保留短淡化、填色变化、选中图标、状态文案与完整操作能力。系统设置优先于 demo 的弹性开关。

## Accessibility

- Contrast: 主要文字使用 ink，辅助文字使用 muted，彩色容器上也检查至少 4.5:1 的普通文字对比度。
- VoiceOver: 首页卡片为单一可操作元素；三个 Tab 有本地化名称和选中语义，隐藏的目的地不进入焦点顺序；Toggle 宣告状态；弹窗隔离背景焦点、聚焦标题并支持 escape；装饰曲线隐藏于辅助功能树。
- Dynamic Type: Tab 标签、章节、输入和弹窗可增高；检查最大可访问性字号及较窄 iPhone，底栏增高不能挡住正文末尾。
- Touch target: 所有真实按钮至少 44 × 44 pt。首页标本内的图形不伪装成独立小按钮。
- Color-only meaning: Tab 选择同时有图标、标签和 selected trait；开关、失败与完成都有图标或文字。

## Prompt Guidance

### Use This Style When Prompt Says

- Trigger phrases: Playful Outline、灵动描线、韩风柔滑色块、无描边平面交互、流动 Tab、连续曲线分区、丰富但克制的弹性动效。
- Related product scenarios: 创意记录、灵感探索、组件演示、友好的小工具。

### AI Output Should Include

- Visual direction: 内容与动作先于曲线；首页展示真实便签的静态缩样，白色正文与彩色操作区以一处柔和单弧分隔。仅在详情底部使用随真实 Tab 选择连续移动的流线导航。
- Token suggestions: 纸白背景、薄荷与杏色色面、深墨色导航和主控件、错误背景与文字色，平滑 Bézier 曲线与胶囊形状，零组件描边、零阴影。
- Component behavior: 便签收藏与取消的真实结果，三个目的地的内容和流线联动，共享收藏及输入结果，按钮与 Switch 的按下/切换/释放，弹窗完整状态链和二级页转场。
- SwiftUI notes: 保留控件语义、可打断动画、视图消失时取消持续工作。
- Risks and acceptance checks: 运动强度、对比度、大字号、弹窗焦点、快速重复输入和首页性能。

## Anti-patterns

- 不添加投影、拟物高光、毛玻璃或发光来补层次。
- 不沿组件外围或内部加包围线，不以双圈、细框或分隔线代替色面边缘。图标自身的勾线和箭头笔画可以保留。
- 不把波浪作为填满空白的装饰，不为每个章节添加全宽曲面，不让多个波峰掩盖内容层级。独立便签可以有柔和外圆角。
- 不以粗边框、硬阴影或高饱和黄黑配色把它变成 Neo-Brutalism。
- 不复制参考图的封面、品牌或音乐内容，不把圆形播放器重新作为首页或详情首屏主体。
- 不在首页缩样放置 mini Tab、导航图标列或嵌套收藏交互；首页整卡只负责进入详情。
- 不把三 Tab 做成装饰图标、长页锚点或只切标题的假导航；不能只移动小圆点而让曲线位置和形状保持不变。
- 不用折线或逐段水平切线拼出僵硬流线，不让活动区域变成尖谷、鼓包或独立悬浮按钮；不通过重建导航视图来切换曲线。
- 不让所有元素持续跳动，不在首页重复卡片中使用 TimelineView 或 repeatForever。
- 不用纯颜色表达开关状态，不让弹窗只支持手势关闭。
- 不把风格定义简化成“到处放波浪”或“圆按钮加弹簧动画”；曲面必须有分隔职责，组件必须有真实内容和完整状态。

## Acceptance Checklist

- [ ] 首页展示可读灵感便签的静态缩样，没有播放器、mini Tab、导航图标列或嵌套操作，整卡点击进入详情。
- [ ] 详情灵感便签可以收藏和取消；白色正文与薄荷/杏色操作区由一处柔和单弧分隔，状态文案、图标和收藏结果同步。
- [ ] 灵感、组件、规范是三个真实目的地，选择后内容、曲线位置、曲线形状和活动图标共同更新。
- [ ] 详情 Tab 在稳定容器内连续移动并形变，宽缓流线没有尖谷、鼓包、折角、撕裂或重建闪现；快速连续点击以最新选择为准。
- [ ] 导航只有纸色底与一层深墨色曲面；图标在静止和移动期间均与实际色面保持对比，活动标签在深墨色上可读；每项有 selected trait 和至少 44 × 44 pt 点击区域。
- [ ] 曲面只用于留白修饰、内容/操作分隔和详情导航，没有无意义的全页波浪；次要按钮无双框，输入焦点与错误通过填色和文字区分。
- [ ] 新模块无 shadow、blur、glassEffect 或伪高光层。
- [ ] 主、次、选中、禁用和破坏性按钮都有正确行为。
- [ ] Switch 有弹性滑动、明确状态和原生可访问性语义。
- [ ] 便签收藏、按钮与开关同步；弹性关闭后 Tab 直接切换。跨 Tab 返回后收藏、弹性、组件章节、确认计数、输入、筛选与结果保留；离场退出焦点并取消加载任务，返回按保留状态恢复。
- [ ] 弹窗可打开、取消、确认、显示完成并关闭，背景焦点隔离。
- [ ] 弹窗确认仅执行一次，确认后仍显示完成态；完成、取消、背景轻点与 escape 均能关闭。
- [ ] 原生 sheet 三档高度、按钮切档、滚动和关闭正常；大字号展开与横屏 medium 不可用状态正确。
- [ ] 二级页可切换三个阶段、下一步、重播、重置与返回；zoom 的来源和目标一致，Reduce Motion 走普通导航。
- [ ] 输入具备默认、焦点、已填、清空与错误状态；空结果及失败可恢复。
- [ ] 风格详情能展示导航、过滤、表面、首页卡片、token 与 prompt 指导。
- [ ] 首页闲置和拖动时静止，按压仅有局部反馈；详情曲线只在操作后短暂过渡，没有持续播放任务。
- [ ] Reduce Motion 下仍保留全部功能和状态反馈，且没有自定义几何运动。
- [ ] 中英文、RTL、大字号、VoiceOver、44 pt 触控目标和文字/图标对比度已验证；底部安全区不遮挡内容。
- [ ] 系统深色外观下 demo 仍使用明亮配色，文字、状态栏、输入与弹层可读；退出后恢复外壳外观。
- [ ] 语法检查、完整构建、模拟器及真机验证分别报告，不互相替代。

以上为待执行的验收要求，未勾选项不代表已经通过运行验证。
