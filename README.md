<div align="center" id="top">
  <p>
    <img src="docs/assets/mira-logo.png" alt="Mira logo" width="116">
  </p>
  <h1>Mira</h1>
  <p>
    面向 iOS / SwiftUI 的设计系统百科，为 AI 辅助界面设计提供稳定、可落地的风格参考。
  </p>
</div>

<hr>

<details id="中文" name="readme-language" open>
  <summary><strong>中文</strong></summary>

  <p>
    Mira 是一个面向 iOS / SwiftUI 的设计系统百科。它把不同视觉风格整理成文档、规则、Skill 和可交互的 App 演示，让 AI 在生成界面时有稳定的参考，而不是只复述几个风格关键词。
  </p>

  <h3>目前已有的设计风格</h3>

  <ul>
    <li>
      <strong>Apple Liquid Glass / 苹果液态玻璃</strong><br>
      Mira 当前默认的 App Shell 风格，用于首页、导航、搜索、悬浮控件和详情页的系统化玻璃质感。
    </li>
    <li>
      <strong>Neumorphism / 新拟态</strong><br>
      以柔和浅色表面、明暗双向阴影、外凸控件和内凹输入框为核心，已经有首页卡片和独立详情页演示。
    </li>
    <li>
      <strong>Neo-Brutalism / 新粗野主义</strong><br>
      使用粗描边、硬阴影、高饱和色块和直接按压反馈，已经有独立详情页和组件演示。
    </li>
    <li>
      <strong>Glassmorphism / 玻璃拟物化设计</strong>、<strong>Acid Graphic / 酸性美学</strong><br>
      已登记为风格条目，后续会逐步补完整的 Design.md 和独立演示模块。
    </li>
  </ul>

  <h3>如何使用 Mira Design Skill</h3>

  <p>
    Skill 入口在：
    <code>skills/mira-ios-design-system/SKILL.md</code>
  </p>

  <p>建议给 AI 的输入包含四件事：</p>

  <ul>
    <li>目标界面：例如订阅页、首页卡片、搜索页、设置页</li>
    <li>用户场景：用户正在做什么、需要看见什么</li>
    <li>选定风格：例如 Apple Liquid Glass、Neumorphism、Neo-Brutalism</li>
    <li>平台约束：iOS / SwiftUI、可访问性、动态字体、减少动态效果</li>
  </ul>

  <p>示例：</p>

  <pre><code>使用 Mira iOS Design System Skill。
目标界面：iOS 订阅页
用户场景：用户比较月付和年付方案
选定风格：Apple Liquid Glass
输出：视觉方向、tokens、布局、组件建议、SwiftUI 注意事项、反模式和验收清单。</code></pre>

  <p>
    Skill 不保存长篇风格正文，它会指向 <code>docs/design-system/</code> 里的权威文档。每个可实现风格都需要自己的
    <code>docs/design-system/styles/&lt;style-slug&gt;/Design.md</code>。
  </p>

  <h3>开发入口</h3>

  <ul>
    <li>打开工程：<code>Mira.xcworkspace</code></li>
    <li>设计系统文档：<code>docs/design-system/</code></li>
    <li>项目标准：<code>project-standards/</code></li>
    <li>风格运行时代码：<code>Mira/Features/Styles/</code></li>
  </ul>
</details>

<hr>

<details id="english" name="readme-language">
  <summary><strong>English</strong></summary>

  <p>
    Mira is an iOS / SwiftUI-first design system encyclopedia. It turns visual styles into documents, rules, skills, and interactive app demos so AI tools can design from concrete references instead of loose style keywords.
  </p>

  <h3>Current Design Styles</h3>

  <ul>
    <li>
      <strong>Apple Liquid Glass</strong><br>
      Mira's default app shell style, used for the home screen, navigation, search, floating controls, and polished system-like detail pages.
    </li>
    <li>
      <strong>Neumorphism / Soft UI</strong><br>
      A light tactile style built from soft surfaces, paired light and dark shadows, raised controls, and inset inputs. It already has a home card and an independent detail page.
    </li>
    <li>
      <strong>Neo-Brutalism</strong><br>
      A bold interface style with thick borders, hard shadows, saturated blocks, and direct press feedback. It already has an independent detail page and component demos.
    </li>
    <li>
      <strong>Glassmorphism</strong> and <strong>Acid Graphic</strong><br>
      Registered style entries. Their full Design.md files and independent demo modules will be expanded later.
    </li>
  </ul>

  <h3>Using the Mira Design Skill</h3>

  <p>
    Skill entry:
    <code>skills/mira-ios-design-system/SKILL.md</code>
  </p>

  <p>A good AI prompt should include:</p>

  <ul>
    <li>Target screen: subscription page, home card, search page, settings page, etc.</li>
    <li>User scenario: what the user is trying to do and what must stay visible.</li>
    <li>Selected style: Apple Liquid Glass, Neumorphism, Neo-Brutalism, etc.</li>
    <li>Platform constraints: iOS / SwiftUI, accessibility, Dynamic Type, Reduced Motion.</li>
  </ul>

  <p>Example:</p>

  <pre><code>Use the Mira iOS Design System Skill.
Target screen: iOS subscription page
User scenario: users compare monthly and yearly plans
Selected style: Apple Liquid Glass
Output: visual direction, tokens, layout, component guidance, SwiftUI notes, anti-patterns, and acceptance checklist.</code></pre>

  <p>
    The skill stays lightweight. It points to the source documents in <code>docs/design-system/</code> instead of duplicating long style content. Every implementation-ready style should have its own
    <code>docs/design-system/styles/&lt;style-slug&gt;/Design.md</code>.
  </p>

  <h3>Development Entry Points</h3>

  <ul>
    <li>Open the app with <code>Mira.xcworkspace</code></li>
    <li>Design system docs: <code>docs/design-system/</code></li>
    <li>Project standards: <code>project-standards/</code></li>
    <li>Style runtime modules: <code>Mira/Features/Styles/</code></li>
  </ul>
</details>
