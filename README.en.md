<div>
  <h1>Mira</h1>

  <p>
    Mira is an iOS / SwiftUI-first design system encyclopedia. It turns visual styles into documents, rules, skills, and interactive app demos so AI tools can design from concrete references instead of loose style keywords.
  </p>

  <h2>Current Design Styles</h2>

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

  <h2>Using the Mira Design Skill</h2>

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

  <h2>Development Entry Points</h2>

  <ul>
    <li>Open the app with <code>Mira.xcworkspace</code></li>
    <li>Design system docs: <code>docs/design-system/</code></li>
    <li>Project standards: <code>project-standards/</code></li>
    <li>Style runtime modules: <code>Mira/Features/Styles/</code></li>
  </ul>
</div>

