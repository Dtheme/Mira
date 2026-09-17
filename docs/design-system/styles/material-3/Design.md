# Material 3 / Material You

## Style Identity

- **Definition**: 以 Material 3 classic baseline 为依据的完整界面语言；语义色彩、色调表面、标准组件比例和状态层共同组织真实任务。
- **Core Feeling**: 平静、清楚、个人化，可操作内容先于装饰。
- **Visual Keywords**: semantic color roles、tonal surfaces、connected segments、active indicators、state layers。
- **iOS Interpretation**: 在 SwiftUI 中实现 M3 视觉和状态，保留 iPhone 安全区、系统键盘、返回语义、Dynamic Type 和 VoiceOver；尺寸以 pt 落地。
- **Version Boundary**: 采用 [Google material-web v0_192 tokens](https://github.com/material-components/material-web/tree/main/tokens/versions/v0_192)。不混入 Material 3 Expressive 的高弹性形变和夸张轮廓。
- **Runtime**: `Mira/Features/Styles/Material3/`；专用适配器为 `skills/mira-material-3/SKILL.md`。

## Best Use Cases

- Suitable screens: 灵感库、书签、搜索筛选、轻量编辑、设置与有明确反馈的工具页面。
- Suitable product moods: 有品牌色、信息密度适中、组件行为一致。
- Suitable content types: 列表、分类、表单、可恢复的本地操作。
- Best audience fit: 需要把风格规则稳定转成真实 iOS 界面的开发者与 AI。

## Avoid When

- Do not use for: 要求完全 Apple 原生外观的系统页面。
- Risky contexts: 同时把 M3、Liquid Glass 和 Expressive 当作主风格。
- Accessibility concerns: 低对比容器配低对比文字；只换颜色而不表达选中、错误和禁用。
- Product mismatch: 依赖材质仿真、戏剧化海报或强编辑排版的页面。

## Visual Tokens

### Color Tokens

- **Primitive**: `MiMaterial3Palette` 提供 `.violet` 与 `.sage` 两套预设，每套有独立 light / dark 映射；数值集中在 `MiMaterial3Tokens.swift`。violet 对齐官方基准角色，sage 是 Mira 策划的本地预设，不是官方固定绿色主题。
- **Semantic**: primary / secondary / tertiary 及对应 on、container 角色服务重点与配套区域；surface 与 surfaceContainerLowest / Low / surfaceContainer / High / Highest 表达层级；onSurface / onSurfaceVariant 分配文字；outline / outlineVariant 服务规范边界；error 与 inverse roles 服务错误和 Snackbar。
- **Component**: filled button 用 primary；tonal button、选中 segment 用 secondaryContainer；FAB 用 primaryContainer；底栏用 surfaceContainer；filled field 用 surfaceContainerHighest；dialog 用 surfaceContainerHigh。前景使用对应 on-role。
- **Theme behavior**: 配色按钮切换完整预设，所有组件一起改变。它演示个性化原则，不宣称从 iOS 壁纸提色或运行时生成任意 HCT palette。
- **Dark appearance**: 通过 `UIColor` 动态颜色读取系统 appearance 选择角色，不直接反相或强制浅色。角色映射参照 [官方 color tokens](https://github.com/material-components/material-web/blob/main/tokens/versions/v0_192/_md-sys-color.scss)。

### Typography Tokens

- **Display**: 用于规范样本，不把内容列表变成大字海报。
- **Title**: headline 与 title 等级分明；普通字重承担大标题，medium 承担小标题和动作。
- **Body**: body large / medium 用于输入、内容和说明，行数由内容决定。
- **Label**: label large 用于按钮、chip、segment；label medium 用于底栏。
- **Current scale**: 页面 heading 使用 `.largeTitle` regular，section 使用 `.title2` regular；内容为 `.body` / `.subheadline`，底栏为 `.caption`。组件 label 14 pt medium、输入 16 pt、浮动 label 12 pt 均经 `@ScaledMetric` 缩放。
- **iOS mapping**: 使用系统字体 `.default` 及 Dynamic Type 比例映射，不给所有文字套 `.rounded`，不伪称使用未打包的 Roboto。

### Shape / Radius Tokens

- **Surface**: 连续页面不为每节再套大圆角面板。
- **Button**: filled / tonal / outlined / text 使用 full shape。
- **Card**: 内容卡用 medium（12 pt）圆角，只组织真实条目。
- **Control**: chip 用 small（8 pt）；标准 FAB 用 large（16 pt）；dialog 用 extra-large（28 pt）；filled field 仅顶部 extra-small（4 pt）圆角。
- **Connected segments**: 仅首尾圆角，内部共享边界，不画成分离胶囊。

### Elevation / Material Tokens

- **Surface depth**: 先用色调层级建立深度，页面背景为纯色。
- **Shadow**: FAB 局部使用 level 3 柔和黑色阴影；不为整张预览卡、每个按钮或所有容器铺紫色外发光。
- **Blur / material**: demo 内不使用玻璃、背景渐变或 Liquid Glass。
- **Border**: outlined button、未选中 chip、连体 segment、关闭的 switch 和 field 底线保留规范边线。不得套用 Playful Outline 的零描边规则，也不为全部区域统一描边。

## Layout Rules

- **Composition**: demo 使用「灵感库 / 组件 / 规范」三个底部目的地。第一屏是真实本地灵感库，可搜索、筛选、收藏和新建。
- **Grid**: 顶栏、内容、底栏形成连续平面；水平边距以 16 / 24 pt 为主，内部使用 4 / 8 pt 节奏。
- **Spacing**: 标题、筛选、结果直接依附页面留白；卡片不再套小卡。
- **Density**: 搜索和分类在首屏可发现，说明和规范放到独立目的地。
- **Hierarchy**: top app bar 默认 64 pt；bottom navigation 默认 80 pt，indicator 为 64 × 32 pt，图标下方放标签。辅助字号允许增高，不能裁切文字。[官方 navigation bar tokens](https://github.com/material-components/material-web/blob/main/tokens/versions/v0_192/_md-comp-navigation-bar.scss)
- **Safe area**: 底部安全区延续底栏颜色；FAB、Snackbar 在其上方。键盘出现时仍可取消/保存。顶栏不包装成漂浮胶囊框。

## Component Guidance

### Navigation

- 三个目的地是平级；选中态同时用 indicator、图标和标签表达。
- SwiftUI detail host 管理目的地，safe-area inset 放置底栏；返回关闭此 demo，不覆盖 Mira 其余风格的壳。

### Button

- filled 为最高重点、tonal 为次级、outlined 保留明确容器边界、text 为最低视觉重点。40 pt 视觉基准外扩展到至少 44 pt 触达；大字号可增高。
- 标准 FAB 为 56 × 56 pt、16 pt 圆角、24 pt 图标，用于新建；不能变成圆形重阴影按钮。[官方 button](https://github.com/material-components/material-web/blob/main/tokens/versions/v0_192/_md-comp-filled-button.scss)、[FAB](https://github.com/material-components/material-web/blob/main/tokens/versions/v0_192/_md-comp-fab-primary.scss)
- SwiftUI 使用 `ButtonStyle` 表达状态层，保留 action、role、disabled。按下不做玩具式缩放或改变布局。

### Card

- 条目卡承载标题、分类/摘要和书签，用色调容器组织内容，不加装饰 panel、渐变或种子色徽章。
- SwiftUI 书签使用独立 `Button`；不在整卡按钮内再嵌按钮。

### Home Card

- 首页使用默认 violet 的静态 FAB 标本：surfaceContainerLow 纯色卡面，104 × 100 pt / r24 的 primaryContainer 色面承托 56 × 56 pt / r16 的 primary 按钮和 24 pt 铅笔符号。尺寸按卡宽 174 pt 等比缩放。标题 20 pt medium，副文案 11 pt；水平内边距 20 pt。该标本固定展示 violet，规范页内预览也不随 demo 配色切换。
- 标本不做可点击的迷你 app，不堆搜索、导航和按钮；仅外层卡片负责导航。外卡无阴影/描边，只有 FAB 的局部黑色软阴影（0.18 opacity、r3、y3）；按下变为 r2/y1 并叠 12% 状态层，拖动时阴影归零。
- 使用 `miHomePressedStyleID` 短状态层和 `miStyleTitleTransition(style.id)`。闲置时无计时器/循环动画，拖动时无多重阴影，Reduce Motion 保留颜色反馈。

### Sheet / Modal

- 新建 dialog 只输入标题；trim 后为空则显示文字错误，取消不写入，确认才新增默认分类条目。组件页的破坏性演示是「重置演示库」：确认后恢复三个初始条目，再由 Snackbar 撤销；当前没有单项删除或分类编辑。
- dialog 用 surfaceContainerHigh、28 pt 圆角及清楚的标题/正文/动作层级。打开时禁用背景并释放其输入焦点，隔离 VoiceOver 背景；空值错误出现时将无障碍焦点移至错误文字，关闭路径始终可达。
- prompt inspector 使用原生 sheet 关闭/拖拽语义和当前 palette，不另建玻璃壳。
- Snackbar 使用 inverseSurface / inverseOnSurface，撤销动作用 inversePrimary 保持明暗模式下的对比。它在底栏上方占据布局空间，提供显式关闭，不计时自动消失；新操作替换上一条反馈及其单步撤销快照。

### Form

- filled field 使用 surfaceContainerHighest、顶部 4 pt 圆角和底部指示线；默认/聚焦/错误有颜色及文字反馈，不画整圈 capsule。56 pt 高为基准，label 和输入各有位置。[官方 filled field](https://github.com/material-components/material-web/blob/main/tokens/versions/v0_192/_md-comp-filled-text-field.scss)
- SwiftUI 保留 `TextField`、`FocusState` 和键盘提交，支持文本不与输入重叠。
- Switch 轨道 52 × 32 pt；关闭有 outline，打开用 primary；16 / 24 pt thumb 及勾选共同表达状态。整体触达至少 44 pt，通过 `ToggleStyle` 保留语义。[官方 switch](https://github.com/material-components/material-web/blob/main/tokens/versions/v0_192/_md-comp-switch.scss)

### Tab / Segmented Control

- 「全部 / 已收藏」是 40 pt 视觉高度的连体 segment：选中 secondaryContainer、勾选、外缘和共享分界线。[官方 segmented button](https://github.com/material-components/material-web/blob/main/tokens/versions/v0_192/_md-comp-outlined-segmented-button.scss)
- filter chip 为 32 pt 视觉高度、8 pt 圆角；未选中 outlined，选中 secondaryContainer 加勾选。实际触达至少 44 pt。[官方 filter chip](https://github.com/material-components/material-web/blob/main/tokens/versions/v0_192/_md-comp-filter-chip.scss)
- SwiftUI 绑定必须真实改变结果集；空间不足可滚动或改排布，不压小文字。

### Empty state

- 搜索/分类/收藏组合筛选为空时显示统一的无结果状态及清除筛选；组件页加载失败独立显示错误及重试。
- SwiftUI 本地加载示例从 idle 经 800 ms loading 到首次失败，重试后 800 ms 成功，可回到 idle 重演；没有网络调用。

### Paywall / subscription surface

- 可用 surface 分组、单一 filled CTA 和清楚价格说明，不用阴影或色彩制造选择歧义。
- 当前 demo 无支付链路；新 SwiftUI 购买页面仍需接真实购买/恢复状态。

## iOS / SwiftUI Notes

- **SwiftUI primitives**: `Button`、`Toggle`、`TextField`、`ScrollView`、原生 sheet；复用 style 封装视觉和状态，页面组合内容。
- **Recommended modifiers**: palette 传递所有角色，语义字体或 `@ScaledMetric` 适配字号，safe-area inset 管理顶底区域。
- **Native controls to preserve**: 系统输入、键盘、返回/关闭、无障碍焦点和 sheet 拖拽。
- **Performance notes**: 首页静止；本地状态无需添加 service/manager 或外部 SDK；短生命周期 task 离场取消。
- **Dynamic Type notes**: 默认尺寸是比例基准，不是裁切上限；文字和触达优先，不用缩字替代无障碍排版。

### Runtime Component Interfaces

| Interface | Input and host responsibility |
| --- | --- |
| `MiMaterial3Palette` | `.violet / .sage`；通过 `environment(\.miMaterial3Palette, palette)` 传递。颜色适应系统浅/深外观。 |
| `MiMaterial3ButtonStyle(role:)` | `.filled / .tonal / .outlined / .text`；宿主负责 `Button` action、role、disabled。 |
| `MiMaterial3IconButtonStyle(filled:)` | 40 pt 视觉圆面、48 pt 触达；宿主提供图标、accessibility label。 |
| `MiMaterial3FABStyle` | 56 pt / r16；宿主提供图标和 action，颜色取当前 palette。 |
| `MiMaterial3Chip(titleKey:systemImage:isSelected:action:)` | 本地化 key、可选符号和真实选择状态；点击由宿主更新数据。 |
| `MiMaterial3Segment(titles:selection:)` | 本地化 key 数组与 `Binding<Int>`；宿主保证 selection 有效，组件提供横向滚动及 selected traits。 |
| `MiMaterial3ToggleStyle` | 作用于原生 `Toggle`，保留 Boolean binding、disabled 和无障碍开关语义。 |
| `MiMaterial3TextField(titleKey:text:errorKey:)` | `Binding<String>` 与可选错误 key；组件持有输入焦点和清除动作，宿主负责业务校验。 |
| `MiMaterial3Library` | 接收 palette/query/selection/category bindings、collections 和 `onBookmark(UUID)`；不自行持久化。 |
| `MiMaterial3ComponentLab(onNotice:onReset:)` | 上报反馈及重置请求；本地 selection/switch/field/loading 状态归此页所有。 |
| `MiMaterial3CollectionDialog(kind:onCancel:onConfirm:)` | `kind` 为 `.create / .reset`；新建确认回传 trim 后非空标题；重置交由宿主恢复示例并建立撤销快照。 |
| `MiMaterial3ReferenceView(style:onPrompt:)` | 展示当前 palette、类型/形状说明、固定 violet 首页标本及文档入口。 |
| `MiMaterial3PromptSheet(style:)` | 原生 medium / large detents、r28；宿主传入当前 palette。 |

### Host State Contract

- `MiMaterial3DetailView` 持有 palette、目的地、搜索、筛选、收藏集合、dialog、Snackbar 和单步撤销。此页未接持久化；退出再进入恢复示例，不宣称保存到设备或云端。
- 收藏、新建和重置先保存旧 collections 快照，再更新内容；Snackbar 撤销恢复该快照。提示替换或关闭会结束上一条撤销机会。
- 新建成功会清空搜索并回到全部分类/全部条目，确保新条目立刻可见。标题作为用户内容保存，不当作 localization key；新增条目的 category 为 0。
- 重置确认恢复完整初始集合，不逐项删除；当前 query 和 filter 不变。模态打开时背景 `allowsHitTesting(false)` 并从无障碍树隐藏，取消不修改集合。
- 组件页是独立演示状态；切换目的地会重建该页。本地 loading 使用 `.task(id:)`，离场取消等待，不发起网络请求。

## Motion Rules

- **Transition**: 短而连续的颜色/透明度变化，目的地切换不弹跳或大幅 morph。
- **Press feedback**: 用 on-role 半透明状态层覆盖原容器；反馈局限于组件，松手恢复。
- **Loading**: 用户触发才启动，成功/失败可见，无自动循环或伪造网络活动。
- **Gesture response**: 原生滚动、sheet 和键盘优先，局部反馈不干扰首页拖动。
- **Reduced motion fallback**: 读取 `accessibilityReduceMotion`，停用位置/尺寸迁移，保留最终状态、勾选、颜色和文字。

## Accessibility

- **Contrast**: 两套 palette 的浅/深色 on-role 配对需检查；正文至少 4.5:1，必要轮廓和大字至少 3:1。
- **VoiceOver**: nav / segment / chip 有 selected traits，Switch 仍读为开关，书签说明目标与状态，dialog 隔离背景。
- **Dynamic Type**: 内容、dialog、bottom nav、Snackbar 在辅助字号仍完整可读可操作。
- **Touch target**: 32 pt chip、40 pt button 外扩触达；所有交互至少 44 × 44 pt。
- **Color-only meaning**: 选中有勾选/图标变化，错误有文字，加载有进度，收藏有语义标签。

## Prompt Guidance

### Use This Style When Prompt Says

- Trigger phrases: Material 3、Material You、M3 classic、语义配色、色调组件、Google 风格工具界面。
- Related product scenarios: 包含搜索、筛选、收藏、创建、撤销与设置的任务页面。

### AI Output Should Include

- Visual direction: classic baseline、用户任务、内容与规范的分工。
- Token suggestions: light / dark 角色、字体映射、shape scale，说明配色是预设还是实际算法生成。
- Component behavior: 取消、校验、禁用、loading、error、retry、收藏/新建/重置后的单步撤销。
- SwiftUI notes: 原生语义、44 pt 触达、Dynamic Type、safe areas、Reduce Motion。
- Risks and acceptance checks: 紫色、圆角、Android 系统导航或 Expressive 动效都不是 M3 的充分条件。

## Anti-patterns

- Do not: 用紫色发光、背景渐变、大卡套小卡替代语义表面。
- Avoid: 漂浮胶囊顶栏、全 rounded 字体、全局回弹按钮、过度立体感和玻璃。
- Common shallow interpretation: 只换主题色不提供状态；只摆组件不完成任务。
- 不把旧四形状拼盘或种子色十六进制当首页必要构图。
- 不取消官方 outlined 组件边界，也不把边线扩散为所有区域的装饰框。
- 不将配色预设称为壁纸提色，不把本地 loading 说成真实同步。

## Acceptance Checklist

- [ ] 不靠标题也能从角色、比例、组件状态识别 M3 classic。
- [ ] 首页替换旧构图，静止时无渐变、外发光、循环动画。
- [ ] 灵感库可搜索、筛选、查看收藏、新建并校验；收藏、新建、重置演示库支持撤销。
- [ ] filled / tonal / outlined / text、FAB、Switch、chip、segment、field 有真实结果。
- [ ] 三个底部目的地、配色切换和 prompt sheet 可用。
- [ ] violet / sage 的 light / dark 同步影响 demo 组件；静态首页标本保持默认 violet。
- [ ] 触达至少 44 × 44 pt，大字号不被固定尺寸裁切。
- [ ] VoiceOver 状态、模态背景隔离和 Reduce Motion 有实现路径。
- [ ] loading、失败、重试、成功、空结果可触发并恢复。
- [ ] 规范页与运行组件使用同一 palette、type、shape 定义。
- [ ] 验证区分源码检查、编译、模拟器截图、交互与未覆盖项。
