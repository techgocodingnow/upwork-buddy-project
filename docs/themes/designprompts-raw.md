
========== terminal ==========
--- record 0 (len 77) ---
{id:"terminal",name:"Terminal",path:"/terminal",mode:"dark",accent:"#33ff00"}
(total 77 chars)
--- record 1 (len 5795) ---
{id:"terminal",name:"Terminal CLI",mode:"dark",fontType:"mono",description:"A raw, functional, and retro-futuristic command-line interface aesthetic. High contrast, monospaced precision, and blinking cursors.",layoutIdeas:{hero:"A massive ASCII art logo or headline. The subheadline types itself out. CTAs are rendered as command prompts.",stats:"Displayed as a system status report or table output (e.g., 'UPTIME: 99.9%', 'USERS: 10k').",features:"A grid of terminal windows or 'man page' style entries. Each feature has a command-line flag (e.g., '--speed', '--security').",howItWorks:"A step-by-step shell script execution log. 'Step 1: Initializing...', 'Step 2: Processing...'.",benefits:"A split-screen layout like a code editor (vim/vscode) showing 'Before' vs 'After' code blocks.",pricing:"An ASCII table layout. Selected plan highlights with an inverted color block.",testimonials:"Git commit logs or IRC chat logs. 'User@host says: ...'",faq:"A 'man' page manual layout or a help command output (e.g., 'help --topic billing').",blog:"A file directory listing (ls -l). Each post is a file with permissions, date, and author.",footer:"A simple system footer showing shell version, current path, and copyright as a comment."},content:'# Design Philosophy\nThe **Terminal CLI** aesthetic pays homage to the raw power of the command line. It strips away the "user interface" layers to reveal the "system" underneath. It is **brutally functional, high-contrast, and authentically retro**. It feels like hacking into a mainframe or configuring a server.\n\nThe vibe is **Cyber-Industrial, Hacker, and System-Level**. It is not "Matrix" rain (too cliché); it is a clean, usable ZSH/BASH shell environment.\n\n**Key visual signatures:**\n*   **Monospace Supremacy**: Every single character, from the largest headline to the smallest footer link, is monospaced.\n*   **The Cursor**: The blinking block or underscore cursor `_` is the heartbeat of the interface.\n*   **Shell Metaphors**: Use prompt characters (`>`, `$`, `~`), command flags (`--help`), and status codes (`[OK]`, `[ERR]`).\n*   **Scanlines (Subtle)**: A very faint CRT scanline effect to give it depth without ruining readability.\n\n# Design Token System\n\n## Colors (Dark Mode Only)\nThe palette mimics a phosphor monitor. High contrast is non-negotiable.\n\n*   **Background**: `#0a0a0a` (Deep black, but not pure OLED black to allow for scanlines)\n*   **Foreground**: `#33ff00` (Classic Terminal Green) or `#ffb000` (Amber) - *Let\'s go with Green for this implementation as the primary, with Amber as secondary.*\n    *   `primary`: `#33ff00` (Bright Neon Green)\n    *   `secondary`: `#ffb000` (Amber/Orange for warnings or accents)\n    *   `muted`: `#1f521f` (Dimmed green for borders/inactive text)\n    *   `accent`: `#33ff00` (Same as primary, used for cursors/active states)\n    *   `error`: `#ff3333` (Bright Red)\n    *   `border`: `#1f521f` (Dimmed green)\n\n## Typography\n*   **Font**: `JetBrains Mono`, `Fira Code`, or `VT323`.\n*   **Style**: **ALL CAPS** for headers. Lowercase for "code" or body text is acceptable, but consistency is key.\n*   **Scale**: Strict modular scale. Headers shouldn\'t be "smooth"; they should snap to grid sizes.\n\n## Radius & Borders\n*   **Radius**: `0px`. Absolutely no rounded corners.\n*   **Borders**: `1px` solid or dashed. Borders are crucial for defining "windows" or "panes".\n\n## Shadows & Effects\n*   **Shadows**: No drop shadows.\n*   **Text Shadow**: A subtle "glow" for the primary text to mimic phosphor persistence.\n    *   `text-shadow: 0 0 5px rgba(51, 255, 0, 0.5)`\n*   **CRT Overlay**: A pointer-events-none overlay with scanlines.\n\n# Component Stylings\n\n## Buttons\n*   **Structure**: Text enclosed in brackets `[ INITIATE ]` or a solid block of color with inverted text.\n*   **Hover**: The background fills with the primary color, text becomes black (inverted video).\n*   **Active**: A "pressed" state might shift the text 1px down or blink rapidly.\n\n## Cards (Windows/Panes)\n*   **Structure**: A black box with a 1px green border.\n*   **Header**: A "title bar" at the top: `+--- SYSTEM STATUS ---+` or a solid inverted bar.\n*   **Content**: Padded monospaced text inside.\n\n## Inputs\n*   **Style**: No box. Just a prompt `user@acme:~$` followed by the input field.\n*   **Cursor**: A blinking block `█` at the caret position.\n*   **Focus**: No ring, just the blinking cursor.\n\n# Layout Strategy\nThe layout should feel like a grid of terminal windows (`tmux` or `vim` splits).\n*   **Strict Grid**: Content is aligned to a rigid character grid.\n*   **Separators**: Use ASCII characters for dividers: `----------------` or `================` or `//`.\n\n# Non-Genericness (The Bold Factor)\n*   **ASCII Art**: Use ASCII art for the logo or key graphic elements.\n*   **Typewriter Effect**: Headlines should appear character-by-character.\n*   **Raw Data Visualization**: Stats shouldn\'t be pie charts; they should be progress bars `[||||||||||.....]`.\n\n# Effects & Animation\n*   **Blink**: Utilities for `animate-blink` (standard cursor blinking).\n*   **Glitch**: Occasional subtle text offsets on hover.\n*   **Typing**: `typing-demo` animation for the hero text.\n\n# Iconography\n*   **Lucide Icons**: Use them, but style them to look pixelated or low-fi if possible, or strict `stroke-width-2`.\n*   **Color**: Icons are always the primary terminal color.\n\n# Responsive Strategy\n*   **Mobile**: The "windows" stack vertically. The text size remains legible (monospaced fonts can be wide, so watch for overflow). Wrap long lines with a `\\` indicator.\n\n# Accessibility\n*   **Contrast**: The bright green on black exceeds AA requirements.\n*   **Focus**: High visibility is inherent to this style (inverted colors).'}
(total 5795 chars)

========== vaporwave ==========
--- record 0 (len 80) ---
{id:"vaporwave",name:"Vaporwave",path:"/vaporwave",mode:"dark",accent:"#FF00FF"}
(total 80 chars)
--- record 1 (len 38746) ---
{id:"vaporwave",name:"Vaporwave",mode:"dark",fontType:"mono",description:"A nostalgic, neon-drenched journey into 80s retro-futurism. High-contrast neon pinks and cyans against deep void purples. Digital grids, glowing horizons, surreal sunset gradients, and CRT scanline overlays create an immersive synthetic world.",layoutIdeas:{hero:"Full-screen immersive perspective grid floor with floating neon sun gradient backdrop. Massive glowing headline split across two lines with gradient text effect. Skewed neon-bordered CTAs with transforming hover states. Version badge with skewed container.",stats:"Dashboard row with bordered stat containers featuring gradient top accent bars. Hover states trigger cyan glow and color transitions. Grid layout adapts from 4 columns to stacked on mobile.",productDetail:"Terminal window interface with cyan borders and window control dots. Split layout with content on left and visual placeholder on right. Command-line styled text prefixes.",features:"Grid of glass-morphic cards with cyan laser top borders and pink side borders. Rotating diamond icon containers that spin on hover. Cards lift upward on hover with smooth transitions.",blog:"Grid of retro data tape/file cards with duotone gradient overlays on images. Hover triggers cyan border glow and card shadow expansion.",howItWorks:"Vertical timeline with alternating left-right steps. Central pink checkpoint dots with glow effects. Bordered step containers with corner accent decorations. Background dot pattern overlay.",benefits:"Windows 95-inspired file explorer window with title bar and status bar. Grid of file icons with centered layouts. Hover states change background to pink tint.",testimonials:"IRC/terminal-style chat boxes with user avatars in bordered containers. Author names wrapped in angle brackets. Cyan accent colors for roles.",pricing:"Three power-up style cards with gradient glow halos behind highlighted tier. Skewed 'MOST_POPULAR' badge. Cyan titles, massive pricing, gradient accent bars.",faq:"Terminal-style accordion in bordered black container. Questions prefixed with '> QUERY:' in pink, answers with '> RESPONSE:' in cyan. Chevron rotation on expand.",footer:"Perspective grid floor effect fading into bottom. Multi-column link groups with cyan headings. Social icons with hover color transitions. Skewed brand logo mark."},content:`# Vaporwave / Outrun Design System

## 1. Design Philosophy

**"Digital Nostalgia meets Neon Future — A synthetic reality drenched in retro-futuristic excess."**

This is a bold celebration of 1980s retro-futurism, vaporwave aesthetics, and early computer graphics. The design transports users to a synthetic digital dimension where neon lights pierce through infinite grids, CRT scanlines distort reality, and every interaction feels like commanding a vintage terminal from the year 2088.

### Core Aesthetic DNA

**Visual Language**: High-contrast maximalism with unapologetic neon saturation. Nothing is subtle. Every element glows, transforms, or pulses with digital energy. The design rejects minimalism in favor of dense, layered visual effects that create depth through overlapping gradients, glows, scanlines, and perspective distortions.

**Emotional Tone**: Nostalgic yet futuristic. Simultaneously retro (80s arcade cabinets, VHS tapes, early Windows UIs) and forward-looking (cyberpunk cityscapes, holographic interfaces, digital utopias). The mood is dreamy, synthetic, slightly surreal — like navigating a computer from a past vision of the future.

**Design Pillars**:
1. **The Infinite Grid**: Perspective-transformed wireframe grids that recede toward the horizon, creating spatial depth and that iconic outrun highway feeling
2. **Neon Glow Supremacy**: Hot magenta (#FF00FF), electric cyan (#00FFFF), and sunset orange (#FF9900) with aggressive drop shadows and box shadows that make elements appear to emit light
3. **CRT Scanlines & Distortion**: Global overlay of horizontal scanlines and subtle RGB chromatic aberration mimicking old CRT monitors
4. **Terminal/Command-Line Interfaces**: Text prefixed with ">" symbols, monospace fonts, window chrome with colored dots, status bars — everything references DOS prompts and early GUIs
5. **Geometric Transformation**: Skewed containers, rotated icons, perspective grids — elements are rarely perfectly aligned; they feel kinetic and dimensional
6. **Gradient Mania**: Multi-stop gradients everywhere — text fills, backgrounds, borders, glows. Especially the iconic sunset gradient (yellow → orange → pink → purple)

### Interaction Philosophy

**Hover States Are Theatrical**: Buttons don't just change color — they un-skew, explode with glow, scale up, and invert colors. Icons rotate. Cards lift off the page. Every interaction is a micro-event.

**Sound Design (Visual)**: If this design had sound, it would be the hum of neon tubes, the buzz of CRT static, retro synthesizers, and lo-fi beats. The visual design echoes this through pulsing animations, glitch effects, and rhythmic repetition (scanlines, grid patterns).

### The "Anti-Patterns" (What This Is NOT)
- **Not Flat**: Aggressive use of shadows, glows, gradients, and depth
- **Not Minimalist**: Dense with effects, borders, patterns, and overlays
- **Not Corporate**: Playful, artistic, experimental — this is a portfolio piece, not a bank
- **Not Muted**: Colors are 100% saturated; contrasts are extreme

## 2. Design Token System (The DNA)

### Colors (Dark Mode Only)

**Philosophy**: Maximum saturation, high contrast, pure digital primaries. These aren't subtle brand colors — they're neon tubes glowing in a dark void.

*   **Background (The Void)**: \`#090014\` — Near-black with a subtle purple tint. This is the infinite digital space where everything floats.
*   **Foreground (Chrome Text)**: \`#E0E0E0\` — Light silver-gray for body text. Readable yet retro.
*   **Card Background (Glass Panels)**: \`rgba(26, 16, 60, 0.8)\` or \`#1a103c\` — Semi-transparent deep purple. Enables glass-morphism with backdrop blur.
*   **Primary Accent (Hot Magenta)**: \`#FF00FF\` — Pure magenta. Used for primary CTAs, highlights, avatars, feature icons, accent borders. This is THE hero color.
*   **Secondary Accent (Electric Cyan)**: \`#00FFFF\` — Pure cyan. Used for links, focus rings, secondary borders, hover states, card title glows. Complements magenta perfectly.
*   **Tertiary Accent (Sunset Orange)**: \`#FF9900\` — Vibrant orange. Used sparingly for special highlights, "sun" gradients, and attention-grabbing elements.
*   **Border (Default)**: \`#2D1B4E\` — Muted dark purple. Non-interactive borders and dividers.
*   **Border (Active)**: \`#00FFFF\` or \`#FF00FF\` — Neon borders for interactive/hovered elements.

**Gradient Combinations**:
- **Sunset Gradient**: \`linear-gradient(to right, #FF9900, #FF00FF, #00FFFF)\` — The signature vaporwave gradient used for text fills
- **Glow Gradient**: \`linear-gradient(to bottom, #FF9900, #FF00FF)\` — Used for the floating "sun" background element
- **Accent Bar**: \`linear-gradient(to right, #FF00FF, #00FFFF)\` — Sharp gradient for top borders and accent lines

### Typography

**Font Philosophy**: Fonts must evoke both retro computing terminals and futuristic sci-fi interfaces. Geometric sans-serifs for impact, monospace for authenticity.

*   **Headings**: \`"Orbitron", sans-serif\` (weights: 400, 500, 700, 900)
    - Geometric, wide, futuristic letterforms
    - Used for: Page titles, section headings, card titles, pricing
    - Characteristics: All-caps preferred, extreme weights (black/900), tight tracking on large sizes
*   **Body/UI/Code**: \`"Share Tech Mono", monospace\` (weight: 400)
    - Technical, terminal-like, fixed-width
    - Used for: Body text, buttons, labels, input fields, status text
    - Characteristics: Uppercase for UI elements, normal case for body copy, wide letter-spacing (tracking)

**Type Scale & Hierarchy**:
- **Hero Headlines**: \`text-5xl\` to \`text-9xl\` (80px-128px) with responsive scaling. Split across multiple lines for drama.
- **Section Headings**: \`text-3xl\` to \`text-6xl\` (30px-60px). Always bold/black weight.
- **Card/Component Titles**: \`text-2xl\` (24px). Cyan color with text glow.
- **Body Text**: \`text-lg\` to \`text-xl\` (18px-20px). Generous line-height for readability.
- **UI Labels/Buttons**: \`text-sm\` to \`text-lg\`, all-caps, wide tracking (\`tracking-wider\`, \`tracking-widest\`).

**Text Effects**:
- **Glow on Headings**: \`drop-shadow-[0_0_10px_rgba(255,255,255,0.5)]\` for white text, \`drop-shadow-[0_0_30px_rgba(255,0,255,0.6)]\` for gradient text
- **Card Title Glow**: \`drop-shadow-[0_0_5px_rgba(0,255,255,0.8)]\` on cyan titles
- **Gradient Text Fill**: Use \`bg-gradient-to-r from-[#FF9900] via-[#FF00FF] to-[#00FFFF] bg-clip-text text-transparent\` for hero statements

### Radius & Borders

**Border Philosophy**: Sharp, geometric, high-contrast. Borders are neon light tubes, not subtle dividers.

*   **Border Radius**: \`rounded-none\` (0px) is primary. Vaporwave is aggressively geometric and angular. Occasional \`rounded-full\` for dots/circles only.
*   **Border Width**: \`border-2\` (2px) is standard. Heavier borders (\`border-4\`) for emphasis or outer containers.
*   **Border Colors**:
    - Default/Inactive: \`#2D1B4E\` (dark purple, subtle)
    - Interactive/Hover: \`#00FFFF\` (cyan) or \`#FF00FF\` (magenta)
    - Top Accent Bars: Gradient or solid cyan (\`border-t-2 border-t-[#00FFFF]\`)
*   **Multi-Border Patterns**: Cards often have a colored top border (\`border-t-2\`) plus subtle side borders in different colors for layered effect

### Shadows & Effects (The Glow)

**Effect Philosophy**: Everything emits light. Shadows are colored glows, not dark drops.

*   **Box Shadows (Neon Glow)**:
    - **Magenta Glow**: \`shadow-[0_0_10px_#FF00FF]\` or \`shadow-[0_0_20px_#FF00FF]\` for intense glow
    - **Cyan Glow**: \`shadow-[0_0_20px_rgba(0,255,255,0.2)]\` for containers, \`shadow-[0_0_15px_#00FFFF]\` for inputs
    - **Large Area Glow**: \`shadow-[0_0_50px_rgba(0,255,255,0.2)]\` for major containers like final CTA
*   **Text Shadows (See Typography section)**
*   **Hover State Glows**: Buttons and interactive elements dramatically increase glow intensity on hover (2x-3x the base glow)

### Textures & Background Patterns

**Pattern Philosophy**: The void is never empty. Layers of grids, scanlines, dots, and gradients create dimensional depth.

*   **Perspective Grid Floor**:
    \`\`\`css
    background-image: linear-gradient(transparent 95%, #FF00FF 95%), linear-gradient(90deg, transparent 95%, #FF00FF 95%);
    background-size: 40px 40px;
    transform: perspective(500px) rotateX(60deg) translateY(-100px) scale(2);
    mask-image: linear-gradient(to bottom, transparent, black);
    \`\`\`
    Creates the iconic receding grid effect
*   **Floating Sun**: Massive blurred gradient orb (\`h-[600px] w-[600px] blur-[100px] bg-gradient-to-b from-[#FF9900] to-[#FF00FF] opacity-20\`)
*   **Global Scanlines Overlay**:
    \`\`\`css
    background: linear-gradient(rgba(18,16,20,0) 50%, rgba(0,0,0,0.25) 50%);
    background-size: 100% 4px;
    \`\`\`
    Applied as fixed overlay to entire page for CRT effect
*   **RGB Chromatic Aberration** (subtle): \`linear-gradient(90deg, rgba(255,0,0,0.06), rgba(0,255,0,0.02), rgba(0,0,255,0.06))\`
*   **Dot Patterns**: \`radial-gradient(#FF00FF 1px, transparent 1px)\` with \`background-size: 20px 20px\` for section backgrounds
*   **Gradient Overlays on Images**: Duotone effect via \`bg-gradient-to-br from-[#FF00FF] to-[#00FFFF] opacity-20 mix-blend-overlay\`

## 3. Component Stylings

### Buttons

**Primary Button** (\`variant="primary"\`):
\`\`\`tsx
// Skewed container that un-skews on hover
-skew-x-12 transform
border-2 border-[#00FFFF]
bg-transparent
text-[#00FFFF]
rounded-none
uppercase tracking-wider font-mono

// Hover state
hover:skew-x-0
hover:bg-[#00FFFF]
hover:text-black
hover:shadow-[0_0_20px_#00FFFF]

// Inner content is counter-skewed
<span className="inline-block skew-x-12 transform">{children}</span>
\`\`\`

**Secondary Button** (\`variant="secondary"\`):
\`\`\`tsx
-skew-x-12 transform
border-2 border-[#FF00FF]
bg-[#FF00FF]
text-white
rounded-none

hover:skew-x-0
hover:scale-105
hover:opacity-80
\`\`\`

**Outline Button** (\`variant="outline"\`):
\`\`\`tsx
border-2 border-[#FF00FF]
bg-transparent
text-[#FF00FF]
rounded-none

hover:bg-[#FF00FF]
hover:text-white
\`\`\`

**Ghost Button** (\`variant="ghost"\`):
\`\`\`tsx
text-[#E0E0E0]
rounded-none

hover:bg-[rgba(0,255,255,0.1)]
hover:text-[#00FFFF]
\`\`\`

**Sizes**: \`sm\` (h-9), \`default\` (h-12), \`lg\` (h-14), \`icon\` (h-10 w-10)

### Cards / Containers

**Standard Card**:
\`\`\`tsx
border border-[#FF00FF]/30
border-t-2 border-t-[#00FFFF]  // Laser accent on top
bg-[#1a103c]/80
backdrop-blur-md
p-6

// Card Title (cyan with glow)
font-heading font-semibold text-2xl
text-[#00FFFF]
drop-shadow-[0_0_5px_rgba(0,255,255,0.8)]

// Card Description
font-mono text-[#E0E0E0]/70 text-sm
\`\`\`

**Terminal Window Container** (Product Detail style):
\`\`\`tsx
// Outer border with glow
border-2 border-[#00FFFF]
bg-black/80
shadow-[0_0_20px_rgba(0,255,255,0.2)]

// Title bar
bg-[#00FFFF]/10
border-b border-[#00FFFF]
px-4 py-2

// Window control dots
<div className="flex gap-2">
  <div className="h-3 w-3 rounded-full bg-[#FF00FF]" />
  <div className="h-3 w-3 rounded-full bg-[#00FFFF]" />
  <div className="h-3 w-3 rounded-full bg-[#FF9900]" />
</div>
\`\`\`

**File Explorer Window** (Benefits section):
\`\`\`tsx
// Container
border-2 border-[#E0E0E0]/20
bg-[#1a103c]/90
backdrop-blur

// Title bar
bg-[#E0E0E0]/10
border-b-2 border-[#E0E0E0]/20

// Status bar
border-t-2 border-[#E0E0E0]/20
bg-[#090014]
text-[#E0E0E0]/50 text-xs
\`\`\`

### Inputs

**Terminal-Style Input**:
\`\`\`tsx
border-b-2 border-[#FF00FF]  // Underline only
bg-black
text-[#00FFFF] font-mono text-lg
px-3 py-2

placeholder:text-[#FF00FF]/50

focus-visible:border-[#00FFFF]
focus-visible:shadow-[0_0_15px_#00FFFF]
focus-visible:outline-none
\`\`\`

## 4. Non-Generic "Bold" Choices (The "Wow" Factor)

These are mandatory unique design signatures that prevent the Vaporwave style from looking generic:

1.  **Aggressive Skewing**: Buttons and badges use \`-skew-x-12\` transform, creating dynamic diagonal shapes that un-skew on hover for a kinetic morphing effect
2.  **Global CRT Scanlines**: Fixed overlay across entire viewport with horizontal line pattern and RGB chromatic aberration
3.  **Perspective Grid Backgrounds**: Multiple sections use CSS perspective transforms to create the iconic receding grid floor effect
4.  **Gradient Text Fills**: Hero headlines use multi-stop gradient backgrounds clipped to text (\`bg-clip-text text-transparent\`)
5.  **Rotating Icon Containers**: Feature icons sit inside \`rotate-45\` diamond containers that spin to \`rotate-90\` on hover
6.  **Dual-Border Patterns**: Cards combine a bright cyan top border with subtle pink side borders for layered neon tube aesthetic
7.  **Terminal/Window Chrome**: Multiple UI patterns mimic vintage OS interfaces (window title bars with colored dots, file explorer layouts, command prompts)
8.  **Massive Blurred Sun**: Giant gradient orb in background (\`600px\` diameter with \`blur-[100px]\`) creates atmospheric depth
9.  **IRC-Style Elements**: Testimonials use chat message formatting with \`<username>\` angle bracket syntax
10. **Alternating Timeline Layout**: How It Works section uses alternating left-right layout with central checkpoint line
11. **Glowing Hover Amplification**: Interactive elements don't just highlight — they explode with 2-3x glow intensity and trigger color inversions

## 5. Animation & Motion

**Philosophy**: Snappy, mechanical, retro-digital. Like a CRT monitor warming up or old computer software responding to input.

*   **Transition Speed**: \`duration-200 ease-linear\` — Fast, unnatural, digital. No organic easing curves.
*   **Hover Transformations**:
    - Buttons: Un-skew, fill with color, invert text, explode glow
    - Cards: Translate upward (\`-translate-y-2\`), increase shadow
    - Icons: Rotate 45° or scale
    - Links: Add underline, change color, add glow
*   **Continuous Animations**:
    - Trust indicator: \`animate-pulse\` for attention
    - Terminal cursor: Could add blinking effect
    - Icons: \`animate-pulse\` on placeholders
*   **Transform Origins**: Use \`transform-origin\` carefully on perspective grids (\`top center\`, \`bottom center\`)
*   **Transition Classes**: \`transition-all\`, \`transition-colors\`, \`transition-transform\` depending on what's changing

## 6. Layout Strategy & Spacing

**Container Width**: \`max-w-7xl\` for main content, \`max-w-6xl\` for pricing, \`max-w-4xl\` for FAQ/Final CTA, \`max-w-5xl\` for hero

**Spacing System**:
*   **Section Padding**: \`py-20 sm:py-32\` (80px-128px vertical rhythm)
*   **Component Gaps**: \`gap-8\` (32px) for grids, \`gap-12\` (48px) for larger spacing
*   **Inner Padding**: Cards use \`p-6\` or \`p-8\`, containers use \`px-4\` on mobile
*   **Margins**: Generous — headings have \`mb-8\` to \`mb-20\` depending on size

**Grid Usage**:
*   Features: \`grid-cols-1 md:grid-cols-3\`
*   Stats: \`grid-cols-1 md:grid-cols-2 lg:grid-cols-4\`
*   Blog: \`grid-cols-1 md:grid-cols-3\`
*   Benefits: \`grid-cols-1 md:grid-cols-2 lg:grid-cols-3\`
*   Pricing: \`grid-cols-1 md:grid-cols-3\`

**Z-Index Layering** (back to front):
1. Background grid (fixed, \`z-0\`)
2. Floating sun gradient (fixed)
3. Section backgrounds
4. Content (\`z-10\` for nav/sections)
5. Scanline overlay (fixed, \`z-50\`)

## 7. Responsive Strategy

**Breakpoints**: Mobile-first approach using \`sm:\`, \`md:\`, \`lg:\` prefixes

**Mobile Adaptations** (< 640px):
*   **Typography**: Scale down headings by 1-2 sizes (e.g., \`text-5xl\` instead of \`text-8xl\`)
*   **Spacing**: Reduce section padding from \`py-32\` to \`py-20\`, margins from \`mb-20\` to \`mb-12\`
*   **Grids**: Stack to single column (\`grid-cols-1\`)
*   **Buttons**: Full-width CTA buttons in hero, stacked vertically
*   **Timeline**: Left-aligned with offset instead of alternating layout
*   **Borders**: Maintain neon borders (essential to vibe)
*   **Glow Effects**: Slightly reduce intensity to prevent overwhelming small screens
*   **Grid Backgrounds**: Keep perspective grids but simplify (they add essential atmosphere)
*   **Touch Targets**: Buttons maintain minimum 44px height via \`h-12\` and \`h-14\` sizes

**Tablet** (640px - 1024px):
*   **Grids**: Often 2 columns before jumping to 3/4
*   **Typography**: Mid-range sizes
*   **Navigation**: Show full menu on tablets

**Key**: The vaporwave aesthetic MUST survive on mobile. Neon glows, borders, and grid backgrounds are non-negotiable even on small screens.`},web3:{id:"web3",name:"Crypto",mode:"dark",fontType:"sans-serif",description:"A bold, futuristic aesthetic inspired by Bitcoin and decentralized finance. Deep void backgrounds with Bitcoin orange accents, golden highlights, glowing elements, and precision data visualization.",layoutIdeas:{hero:"Split layout with 60/40 ratio. Left: Massive headline with Bitcoin orange gradient text and trust badge. Right: Floating animated 3D orb with spinning orbital rings and floating stat cards. Background features subtle grid pattern with radial gradient blur effects.",stats:"Horizontal grid of four key metrics with monospace numbers, uppercase labels, and subtle trend indicators. Dark surface background with top/bottom borders for ticker-tape feel.",productDetail:"Two-column layout with mockup on left, content on right. Abstract UI mockup with glass morphism, grid backgrounds, and holographic gradients.",features:"Three-column grid of elevated cards with background icon watermarks, glowing accent borders on hover, and icon containers with gradient backgrounds.",blog:"Three-column grid of image-led cards. Full-bleed images with gradient overlays, date badges, and hover scale effects that increase contrast.",howItWorks:"Vertical timeline with centered connection line. Alternating left/right content cards with numbered nodes on the centerline. Cards have corner accent borders.",benefits:"Three-column grid of cards with check icons in glowing circles. Gradient borders appear on hover.",testimonials:"Three-column grid of glass-morphic cards with large quote marks, avatar rings with orange glow, and role badges in accent color.",pricing:"Three-column grid with center card elevated and scaled. Popular badge floats above. Gradient buttons for highlighted tier.",faq:"Accordion with chevron indicators. Glass-morphic backgrounds with smooth height transitions and padding reveals.",footer:"Multi-column grid with brand on left spanning two columns. Monospace section headers, subtle link hover states with orange accent."},content:'# Design Philosophy: The "Bitcoin DeFi" Aesthetic\n\nThis style embodies the visual DNA of Bitcoin and decentralized finance—a sophisticated fusion of precision engineering, cryptographic trust, and digital gold. It is **not generic dark mode**; it is a deep cosmic void where data structures glow with the warmth of Bitcoin orange and the brilliance of digital gold.\n\n## Core Design Principles\n\n1.  **Luminescent Energy**: Light emanates from interactive elements themselves. Bitcoin orange glows, golden highlights shimmer, and data points pulse with life against the true void background. Shadows are colored (orange/gold tints), not just black.\n\n2.  **Mathematical Precision**: Everything follows strict geometric rules. Ultra-thin 1px borders define boundaries, monospace fonts display data with technical accuracy, and grids provide the underlying structure of the blockchain aesthetic.\n\n3.  **Layered Depth**: Create three-dimensional space through transparency stacking (glass morphism), colored glow shadows, and backdrop blur effects. Elements float in Z-space without heavy skeuomorphism—it\'s digital depth, not physical.\n\n4.  **Textured Void**: Backgrounds are never flat. Subtle grid patterns (representing blockchain networks), radial gradient blurs (representing energy fields), and noise textures bring the void to life. The darkness breathes.\n\n5.  **Trust Through Design**: High contrast, clear hierarchy, and technical precision communicate security and reliability. The aesthetic says "your assets are safe here."\n\nThe vibe is **Secure, Technical, and Valuable**. This is digital gold—it should feel premium, cutting-edge, and engineered to perfection. Think Bitcoin mining rigs humming in the darkness, glowing with orange heat.\n\n# Design Token System\n\n## Colors (Dark Mode Only)\nThis palette uses a "True Void" foundation with "Bitcoin Fire" energy—the warmth of Bitcoin orange and the brilliance of digital gold.\n\n*   **Background**: `#030304` (True Void) - The deepest space where all begins\n*   **Surface**: `#0F1115` (Dark Matter) - Elevated surfaces, cards, and panels\n*   **Foreground**: `#FFFFFF` (Pure Light) - Primary text, maximum contrast\n*   **Muted**: `#94A3B8` (Stardust) - Secondary text, descriptions, metadata\n*   **Border**: `#1E293B` (Dim Boundary) - Subtle borders at rest (often at 10-20% opacity when using white)\n*   **Primary Accent**: `#F7931A` (Bitcoin Orange) - The iconic color of decentralization. Primary CTAs, links, active states, and trust indicators\n*   **Secondary Accent**: `#EA580C` (Burnt Orange) - A deeper, warmer orange for gradients, secondary elements, and visual depth\n*   **Tertiary Accent**: `#FFD600` (Digital Gold) - The color of value. Used in gradients with Bitcoin Orange, highlights, and success states\n\n**Gradient Formula**: The signature look is `linear-gradient(to right, #EA580C, #F7931A)` or `linear-gradient(to right, #F7931A, #FFD600)` for text and buttons.\n\n## Typography\nThe type system balances technical precision with modern geometric forms.\n\n*   **Headings**: `Space Grotesk` (Google Font) - A geometric grotesque with quirky technical character\n    *   Weights: 400 (Regular), 500 (Medium), 600 (Semibold), 700 (Bold)\n    *   Usage: All headings (h1-h6), section titles, card titles\n    *   Apply `font-heading` class\n\n*   **Body**: `Inter` (Google Font) - Highly legible sans-serif optimized for screens\n    *   Weights: 400 (Regular), 500 (Medium), 600 (Semibold)\n    *   Usage: Body copy, descriptions, buttons\n    *   Apply `font-body` class\n\n*   **Mono/Data**: `JetBrains Mono` (Google Font) - Technical monospace for precision\n    *   Weights: 400 (Regular), 500 (Medium)\n    *   Usage: Stats, prices, badges, technical labels, navigation links\n    *   Apply `font-mono` class\n\n*   **Scale Philosophy**: Dramatic contrast between display and body. Heroes are massive (`text-4xl` → `md:text-7xl`), body is comfortable (`text-base` or `text-lg`). Mobile-first scaling prevents overwhelming small screens.\n\n*   **Leading & Tracking**: Tight leading on headings (`leading-tight`), relaxed on body (`leading-relaxed`). Uppercase mono text gets generous tracking (`tracking-wider`, `tracking-widest`).\n\n## Radius & Borders\nGeometric precision with soft curves for approachability.\n\n*   **Radius Tokens**:\n    *   Cards/Containers: `rounded-2xl` (16px) or `rounded-xl` (12px)\n    *   Buttons: `rounded-full` (pill shape)\n    *   Inputs: `rounded-lg` (8px) or bottom-border only for minimalism\n    *   Small elements (badges, icons): `rounded-lg` or `rounded-full`\n\n*   **Border Philosophy**: Ultra-thin `1px` borders create delicate boundaries without visual weight\n    *   Default state: `border border-white/10` (barely visible structure)\n    *   Hover state: `border-[#F7931A]/50` (orange accent, 50% opacity)\n    *   Active/Focus: `border-[#F7931A]` (full intensity)\n\n*   **Special Border Techniques**:\n    *   Corner accents: Small decorative border segments at corners (see How It Works cards)\n    *   Gradient borders: Simulate with inner pseudo-elements or subtle box-shadow gradients\n\n## Shadows & Effects (The Glow)\nThe signature of this style is **colored luminescence**—shadows and glows in Bitcoin orange and gold tints.\n\n*   **Orange Glow** (Primary): `shadow-[0_0_20px_-5px_rgba(234,88,12,0.5)]` or `shadow-[0_0_30px_-5px_rgba(247,147,26,0.6)]`\n    *   Used on buttons, cards on hover, primary CTAs, and interactive elements\n\n*   **Gold Glow** (Accent): `shadow-[0_0_20px_rgba(255,214,0,0.3)]`\n    *   Used on special highlights, success states, value indicators\n\n*   **Subtle Card Elevation**: `shadow-[0_0_50px_-10px_rgba(247,147,26,0.1)]`\n    *   Used on product mockups, major sections\n\n*   **Glass Morphism**:\n    *   Formula: `backdrop-blur-lg` + `bg-white/5` or `bg-black/40`\n    *   Creates floating, translucent panels that reveal background blur\n    *   Used on floating cards (hero), testimonials, "How It Works" cards\n\n*   **Radial Blur Backgrounds**: Large, soft radial gradients with heavy blur for ambient background glow\n    *   Example: `bg-[#F7931A] opacity-10 blur-[120px]` positioned absolutely\n\n## Textures & Patterns\nBackgrounds breathe with subtle, non-distracting patterns that reinforce the blockchain/network theme.\n\n*   **Grid Pattern** (Signature):\n    ```css\n    background-size: 50px 50px;\n    background-image:\n      linear-gradient(to right, rgba(30, 41, 59, 0.5) 1px, transparent 1px),\n      linear-gradient(to bottom, rgba(30, 41, 59, 0.5) 1px, transparent 1px);\n    mask-image: radial-gradient(circle at center, black 40%, transparent 100%);\n    ```\n    *   Creates a fading grid that disappears toward edges (vignette effect)\n    *   Used on hero section\n\n*   **External Texture Overlays**:\n    *   Example: `bg-[url(\'https://www.transparenttextures.com/patterns/cubes.png\')] opacity-5`\n    *   Very subtle, barely visible patterns for visual interest\n\n*   **Radial Gradient Blurs**: Massive, soft color blobs for ambient lighting\n    *   Position absolutely, use low opacity (5-10%), apply blur-[120px] or blur-[150px]\n    *   Creates depth and guides eye to focal points\n\n# Component Stylings\n\n## Buttons\nButtons are bold, pill-shaped, and emit colored light. All use `rounded-full` for the signature crypto pill shape.\n\n*   **Primary (Default)**:\n    *   Background: `bg-gradient-to-r from-[#EA580C] to-[#F7931A]`\n    *   Text: White, bold, uppercase with `tracking-wider`\n    *   Shadow: `shadow-[0_0_20px_-5px_rgba(234,88,12,0.5)]`\n    *   Hover: `scale-105` + intensified shadow `shadow-[0_0_30px_-5px_rgba(247,147,26,0.6)]`\n    *   Min height: 44px (touch-friendly)\n\n*   **Outline**:\n    *   Background: Transparent\n    *   Border: `border-2 border-white/20`\n    *   Text: White\n    *   Hover: `border-white` + `bg-white/10`\n\n*   **Ghost**:\n    *   Background: Transparent, no border\n    *   Text: White\n    *   Hover: `bg-white/10` + `text-[#F7931A]`\n\n*   **Link**:\n    *   Text: `text-[#F7931A]`\n    *   Hover: Underline\n\nAll buttons include smooth `transition-all` for responsive micro-interactions.\n\n## Cards (The "Block" Concept)\nCards are elevated surfaces that float above the void, representing blocks in the chain.\n\n*   **Standard Card**:\n    *   Background: `bg-[#0F1115]` (Dark Matter surface)\n    *   Border: `border border-white/10` (subtle boundary)\n    *   Radius: `rounded-2xl` (16px)\n    *   Padding: `p-8` (generous spacing)\n    *   Hover: `hover:-translate-y-1` (lift) + `hover:border-[#F7931A]/50` + `hover:shadow-[0_0_30px_-10px_rgba(247,147,26,0.2)]`\n    *   Transition: `transition-all duration-300`\n\n*   **Glass Cards** (Floating/Special):\n    *   Background: `bg-black/40` or `bg-white/5`\n    *   Backdrop: `backdrop-blur-sm` or `backdrop-blur-lg`\n    *   Border: `border border-white/10`\n    *   Creates translucent, floating effect\n\n*   **Pricing Cards**:\n    *   Highlighted tier: `scale-105`, `border-[#F7931A]`, elevated z-index, `shadow-[0_0_40px_-10px_rgba(247,147,26,0.15)]`\n    *   Others: Lower opacity (`opacity-80`), scale up on hover\n\n*   **Card Hierarchy**:\n    *   Header: `p-8 pb-4`\n    *   Title: `font-heading font-semibold text-2xl`\n    *   Description: `text-[#94A3B8] text-sm`\n    *   Content: `p-8 pt-0`\n    *   Footer: `p-8 pt-0`\n\n## Inputs\nMinimalist, precise input fields with bottom-border styling for a technical aesthetic.\n\n*   **Background**: `bg-black/50` (semi-transparent dark)\n*   **Border**: Bottom border only - `border-b-2 border-white/20`\n*   **Height**: `h-12` (48px for touch targets)\n*   **Padding**: `px-4 py-2`\n*   **Text**: `text-white text-sm`\n*   **Placeholder**: `placeholder:text-white/30`\n*   **Focus State**:\n    *   Border: `focus-visible:border-[#F7931A]`\n    *   Glow: `focus-visible:shadow-[0_10px_20px_-10px_rgba(247,147,26,0.3)]`\n    *   No outline: `focus-visible:outline-none`\n*   **Disabled**: `disabled:opacity-50 disabled:cursor-not-allowed`\n\nInputs feel like data entry terminals—clean, precise, and purposeful.\n\n## Icons\nIcons from `lucide-react` reinforce the technical, precise aesthetic.\n\n*   **Stroke Width**: Default (1.5-2px for clean, technical lines)\n*   **Colors**: Use accent colors to create hierarchy\n    *   Orange: `text-[#F7931A]` or `text-[#EA580C]`\n    *   Gold: `text-[#FFD600]`\n    *   Muted: `text-[#94A3B8]`\n    *   White: `text-white`\n\n*   **Icon Containers**: Wrap in colored, glowing containers\n    *   Example: `bg-[#EA580C]/20 border border-[#EA580C]/50 rounded-lg p-3`\n    *   Creates a "holographic node" effect\n    *   Hover: Add glow shadow `hover:shadow-[0_0_20px_rgba(234,88,12,0.4)]`\n\n*   **Decorative Icons**: Large, watermark-style icons in card backgrounds\n    *   High opacity on hover for subtle reveal effect\n    *   Example: `opacity-20 group-hover:opacity-100`\n\n# Non-Generic "Bold" Choices\n\nThis design MUST NOT look like default Tailwind. These bold choices create unmistakable personality:\n\n1.  **Gradient Text on Headlines**: Apply `bg-gradient-to-r from-[#F7931A] to-[#FFD600] bg-clip-text text-transparent` to final 1-2 words of hero headlines. Creates instant visual hierarchy and Bitcoin brand association.\n\n2.  **Spinning Orbital Rings**: Hero section features animated 3D-style orb with CSS rotating rings (`animate-[spin_10s_linear_infinite]` and reverse). Floating stat cards bounce around it with staggered delays.\n\n3.  **Corner Border Accents**: "How It Works" cards use decorative corner borders (`border-t border-l` on top-left, `border-r border-b` on bottom-right) in Bitcoin orange, creating a "selected node" effect.\n\n4.  **Glowing Animated Badges**: Pulsing dot badges (`animate-ping`) on trust indicators and status markers. Suggests live network activity.\n\n5.  **Background Icon Watermarks**: Large, rotated, low-opacity icons in feature card backgrounds that reveal on hover (`opacity-20 group-hover:opacity-100`).\n\n6.  **Timeline as Blockchain**: "How It Works" uses a vertical gradient line (orange to transparent) with numbered circular nodes, mimicking a blockchain ledger.\n\n7.  **Asymmetric Pricing Scale**: The popular pricing tier is `scale-105` and elevated, while others are `opacity-80`, creating intentional hierarchy through scale manipulation.\n\n8.  **Glass Morphism with Grid Patterns**: Combine `backdrop-blur` with background grid patterns visible through transparency, creating layered depth.\n\n9.  **Colored Shadows Replace Black**: ALL shadows use orange/gold tints. No pure black shadows exist in this design system.\n\n# Layout & Spacing\n\n*   **Container Width**: `max-w-7xl` (1280px) - Wide and expansive to showcase data and content without cramping\n*   **Section Padding**: Generous vertical `py-24` (96px) creates breathing room between major sections\n*   **Density**: Spacious approach with `gap-8` (32px) or `gap-12` (48px) between grid items\n*   **Section Dividers**: NO hard lines or `<hr>` elements. Sections separate through:\n    *   Vertical spacing (`py-24`)\n    *   Alternating backgrounds (`bg-[#030304]` → `bg-[#0F1115]` → `bg-[#030304]`)\n    *   Subtle top/bottom borders on specific sections (e.g., stats ticker has `border-y`)\n\n*   **Responsive Grids**:\n    *   Mobile-first: Single column by default\n    *   Tablet: `md:grid-cols-2` or `md:grid-cols-3`\n    *   Desktop: Keep `md:grid-cols-3` or `lg:grid-cols-4` for features\n    *   Pricing: Always `md:grid-cols-3` for tier comparison\n\n# Animation & Motion\n\nMotion should feel **precise, snappy, and purposeful**—like a high-performance trading terminal.\n\n*   **Custom Float Animation**:\n    ```css\n    @keyframes float {\n      0%, 100% { transform: translateY(0px); }\n      50% { transform: translateY(-20px); }\n    }\n    .animate-float {\n      animation: float 8s ease-in-out infinite;\n    }\n    ```\n    *   Applied to hero 3D orb graphic\n    *   Slow, smooth, endless float creates ethereal quality\n\n*   **Spinning Orbitals**:\n    *   `animate-[spin_10s_linear_infinite]` for outer ring\n    *   `animate-[spin_15s_linear_infinite_reverse]` for inner ring (reverse direction)\n    *   Creates mesmerizing 3D depth illusion\n\n*   **Bouncing Cards**: Floating stat cards use `animate-bounce` with custom durations (`3s`, `4s`) and delays (`delay-1s`) for staggered motion\n\n*   **Pulsing Indicators**: Status badges use `animate-ping` for "live" feel\n\n*   **Interaction Speed**: Fast and responsive (`duration-200` or `duration-300`)\n    *   Button hover: `transition-all duration-300`\n    *   Card lift: `transition-all duration-300`\n    *   Input focus: Instant (`duration-200`)\n\n*   **Hover Effects**:\n    *   Cards: Lift (`-translate-y-1`), border color shift, glow intensification\n    *   Buttons: Scale (`scale-105`), glow spread\n    *   Images: Scale (`scale-110`), contrast boost (`contrast-125`)\n\nThe motion design communicates **speed, precision, and responsiveness**—critical values in crypto/finance.\n\n# Responsive Strategy\n\nThe design must maintain its bold personality across all screen sizes while adapting gracefully.\n\n*   **Mobile-First Philosophy**: Start with single-column layouts, scale up for larger screens\n*   **Breakpoints**:\n    *   `sm`: 640px - Minor adjustments\n    *   `md`: 768px - Major layout shifts (2-3 columns activate)\n    *   `lg`: 1024px - Full desktop experience\n    *   `xl`: 1280px - Maximum width container (`max-w-7xl`)\n\n*   **Typography Scaling**: All headings use responsive classes\n    *   Hero: `text-4xl sm:text-5xl md:text-7xl`\n    *   Section Titles: `text-2xl md:text-4xl` or `md:text-5xl`\n    *   Body: `text-base md:text-lg`\n    *   Keep mobile readable, don\'t overwhelm small screens\n\n*   **Touch Targets**: All interactive elements minimum 44px (`min-w-[44px]`, `h-10+`)\n\n*   **Mobile Adaptations**:\n    *   Navigation: Show only essential CTA on mobile, hide secondary nav\n    *   Hero 3D graphic: Smaller size on mobile (`h-[300px] md:h-[450px]`)\n    *   Grids: Single column → 2-3 columns at `md`\n    *   Pricing cards: Stack vertically, remove scale effect on mobile\n    *   How It Works timeline: Left-aligned on mobile with simpler layout\n\n*   **Maintain Core Aesthetic**: Grid patterns, glows, and gradients persist on mobile—don\'t strip personality for smaller screens\n\n# Accessibility & Best Practices\n\n*   **Color Contrast**: White text on `#030304` exceeds WCAG AAA (21:1 ratio). Orange `#F7931A` on dark backgrounds meets AA for large text.\n*   **Focus States**: All interactive elements have visible focus rings using `focus-visible:ring-2 focus-visible:ring-[#F7931A]`\n*   **Semantic HTML**: Proper heading hierarchy (h1 → h2 → h3), `<nav>`, `<section>`, `<button>` elements\n*   **Alt Text**: All images require descriptive alt attributes\n*   **Keyboard Navigation**: All interactive elements accessible via Tab, buttons activate on Enter/Space\n*   **Motion Preferences**: Consider `prefers-reduced-motion` for users sensitive to animation (disable float/spin animations)\n\n# Implementation Notes\n\n*   **Font Loading**: Use `fontImport()` helper to load Google Fonts\n*   **Custom Classes**: Define `.font-heading`, `.font-body`, `.font-mono` in style block\n*   **Grid Pattern**: Define `.bg-grid-pattern` with CSS-in-JS in style block\n*   **Glass Morphism**: Define `.holographic-gradient` helper class\n*   **Components**: Build Button, Card, and Input components using `cva` (class-variance-authority) following Shadcn patterns but with Crypto-specific styling\n*   **Icons**: Import specific icons from `lucide-react` as needed (Zap, Lock, Layers, Globe, Check, etc.)\n\nThis is not a generic dark theme. This is the **Bitcoin DeFi aesthetic**—engineered for precision, security, and digital value.'}
(total 38746 chars)

========== sketch ==========
--- record 0 (len 72) ---
{id:"sketch",name:"Sketch",path:"/sketch",mode:"light",accent:"#ff4d4d"}
(total 72 chars)
--- record 1 (len 27347) ---
{id:"sketch",name:"Hand-Drawn / Sketch",mode:"light",fontType:"sans-serif",description:"Organic wobbly borders, handwritten typography, paper textures, and playful imperfection. Every element feels sketched with markers and pencils on textured paper.",layoutIdeas:{hero:"Split 2-column grid with oversized marker-style headline, decorative hand-drawn arrow pointing to CTA, and polaroid-frame product mockup with wobbly borders. Trust indicators use overlapping avatar circles.",stats:"Horizontal grid of stats displayed in irregular organic shapes (wobbly circles) with varying border radii. Each stat has playful rotation for authentic hand-drawn feel.",productDetail:"Centered content in white card with wobbly borders, sticky-note tag at top center, drop-cap first letter treatment, and constrained text width for readability.",features:"3-column grid of post-it yellow cards with tape decoration at top. Each card includes rough circular icon container and wobbly borders for sketchy aesthetic.",blog:"3-column grid with polaroid-style frames. Dashed borders on image placeholders, hard offset shadows, and playful rotation on hover for scrapbook feel.",howItWorks:"3-column step layout with decorative squiggly connecting line (desktop). Steps numbered in wobbly-border circles with hard offset shadows.",benefits:"Centered white container with thick wobbly border and hard shadow. 2-column grid with hand-drawn bullet points (filled circles) for each benefit item.",testimonials:"3-column grid of speech bubbles with geometric tail pointing down-left. Quote icon, italic text, and author info with circular avatar below bubble.",pricing:"3-column grid with wobbly-border cards. Highlighted plan has rotating badge, dashed circle overlay, slight scale, and stronger shadow for emphasis.",faq:"Single column, dashed border dividers between questions. Bold headings with relaxed body text for easy scannability.",footer:"4-column grid navigation with wavy underline on section headers. Social icons in wobbly circles, dashed border separator at bottom."},content:`# Design Philosophy

The Hand-Drawn design style celebrates authentic imperfection and human touch in a digital world. It rejects the clinical precision of modern UI design in favor of organic, playful irregularity that evokes sketches on paper, sticky notes on a wall, and napkin diagrams from a brainstorming session.

**Core Principles:**
- **No Straight Lines**: Every border, shape, and container uses irregular border-radius values to create wobbly, hand-drawn edges that reject geometric perfection
- **Authentic Texture**: The design layer paper grain, dot patterns, and subtle background textures to simulate physical media (notebook paper, post-its, sketch pads)
- **Playful Rotation**: Elements are deliberately tilted using small rotation transforms (-2deg to 2deg) to break rigid grid alignment and create casual energy
- **Hard Offset Shadows**: Reject soft blur shadows entirely. Use solid, offset box-shadows (4px 4px 0px) to create a cut-paper, layered collage aesthetic
- **Handwritten Typography**: Use exclusively handwritten or marker-style fonts (Kalam, Patrick Hand) that feel human and approachable, never corporate or sterile
- **Scribbled Decoration**: Add visual flourishes like dashed lines, hand-drawn arrows, tape effects, thumbtacks, and irregular shapes to reinforce the sketched aesthetic
- **Limited Color Palette**: Stick to pencil blacks, paper whites, correction marker red, and post-it yellow for bold but cohesive simplicity
- **Intentional Messiness**: Embrace overlap, asymmetry, and visual "mistakes" that make the design feel spontaneous and creative rather than manufactured

**Emotional Intent:**
This style should feel approachable, creative, human-centered, and fun. It lowers barriers and invites interaction by appearing unfinished and work-in-progress, making users feel like collaborators rather than consumers. Perfect for creative tools, brainstorming platforms, educational content, or any product that wants to emphasize human creativity over corporate polish.

# Design Token System

## Colors (Single Palette - Light Mode)
- **Background**: \`#fdfbf7\` (Warm Paper)
- **Foreground**: \`#2d2d2d\` (Soft Pencil Black - never pure black)
- **Muted**: \`#e5e0d8\` (Old Paper / Erased Pencil)
- **Accent**: \`#ff4d4d\` (Red Correction Marker)
- **Border**: \`#2d2d2d\` (Pencil Lead)
- **Secondary Accent**: \`#2d5da1\` (Blue Ballpoint Pen)

## Typography
- **Headings**: \`Kalam\` (wght 700) - Looks like a thick felt-tip marker.
- **Body**: \`Patrick Hand\` (wght 400) - Legible but distinctly handwritten.
- **Scale**: Large and readable. Headings should vary in size dramatically to look like emphasized notes.

## Radius & Border
- **Wobbly Borders**: CRITICAL. Do NOT use standard \`rounded-*\` classes alone.
- **Technique**: Use inline \`style={{ borderRadius: ... }}\` with multiple values to create irregular organic ellipses.
  - Example: \`border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;\`
  - Store reusable radius values in config as \`wobbly\` and \`wobblyMd\`
- **Border Width**: Thick and variable. \`border-2\` is the minimum. Use \`border-[3px]\` or \`border-4\` for emphasis.
- **Style**: \`border-solid\` is default for most elements. Use \`border-dashed\` for secondary elements, dividers, and sketchy overlays.

## Shadows/Effects
- **Hard Offset Shadows**: No blur. Just a solid offset to create a cut-paper, layered collage aesthetic.
  - Standard: \`box-shadow: 4px 4px 0px 0px #2d2d2d;\`
  - Emphasized: \`box-shadow: 8px 8px 0px 0px #2d2d2d;\`
  - Hover State: Reduce offset \`2px 2px\` or \`6px 6px\` to create "lifting" effect
- **Paper Texture**: Use \`radial-gradient\` dot pattern on body background to simulate notebook paper grain
  - \`backgroundImage: radial-gradient(#e5e0d8 1px, transparent 1px)\`
  - \`backgroundSize: 24px 24px\`
- **Subtle Animations**: Gentle bounce (3s duration) for decorative elements, rotation on hover for playful interaction

# Component Stylings

## Buttons
- **Shape**: Irregular wobbly oval using custom border-radius from config
- **Normal State**:
  - White background, \`border-[3px]\` black border, black text
  - Hard offset shadow: \`shadow-[4px_4px_0px_0px_#2d2d2d]\`
  - Font: Patrick Hand (body font)
- **Hover State**:
  - Background fills with Accent red \`#ff4d4d\`, text turns white
  - Shadow reduces to \`shadow-[2px_2px_0px_0px_#2d2d2d]\`
  - Subtle translate: \`translate-x-[2px] translate-y-[2px]\`
- **Active State**:
  - Shadow disappears completely (button "presses flat")
  - Translate increases: \`translate-x-[4px] translate-y-[4px]\`
- **Secondary Variant**: Uses muted background \`#e5e0d8\`, hovers to blue \`#2d5da1\`

## Cards/Containers
- **Base Style**: White background (\`#ffffff\`) with wobbly black border (\`border-2\`)
- **Border Radius**: Use \`wobblyMd\` radius from config for medium containers
- **Shadow**: Subtle \`3px 3px 0px 0px rgba(45, 45, 45, 0.1)\` for depth
- **Decoration Options**:
  - \`decoration="tape"\`: Translucent gray bar positioned at top center with slight rotation
  - \`decoration="tack"\`: Red circular thumbtack at top center
  - No decoration for minimal aesthetic
- **Special Treatments**:
  - Post-it yellow background \`#fff9c4\` for feature cards
  - Speech bubble style for testimonials with geometric tail using border-based triangle
  - Sticky-note tags for section labels

## Inputs
- **Style**: Full box with wobbly borders (not just underline)
- **Border**: \`border-2\` with wobbly radius matching button aesthetic
- **Font**: Patrick Hand (body font) for authentic hand-written feel
- **Background**: White with placeholder text in muted color \`#2d2d2d/40\`
- **Focus State**:
  - Border changes to blue \`#2d5da1\`
  - Ring effect: \`ring-2 ring-[#2d5da1]/20\`
  - No standard outline, maintains wobbly aesthetic

# Layout Strategy
- **Grid System**: Use Tailwind's responsive grid (\`md:grid-cols-2\`, \`md:grid-cols-3\`) but add visual irregularity
- **Rotation**: Apply small rotations (\`rotate-1\`, \`-rotate-2\`) to cards, images, and decorative elements
- **Breaking Alignment**:
  - Stats: Organic shapes with varied border-radius instead of perfect circles
  - Cards: Slight rotation on hover (\`hover:rotate-1\` or \`hover:-rotate-1\`)
  - Pricing: Scale up highlighted card slightly on desktop (\`md:scale-105\`)
- **Overlap & Layering**:
  - Overlapping avatar circles with negative margin (\`-space-x-4\`)
  - Decorative elements positioned absolutely outside parent bounds
  - Speech bubble tails extending beyond card borders
- **Whitespace**:
  - Consistent section padding (\`py-20\`) for rhythm
  - Generous gap in grids (\`gap-8\`) to prevent crowding
  - Max-width containers (\`max-w-5xl\`, \`max-w-3xl\`) for focused content
- **Z-Index Layering**: Decorative SVG backgrounds at low z-index, step numbers elevated with \`z-10\`

# Non-Genericness (Bold Choices)

**Unique Visual Signatures:**
- **NO STRAIGHT LINES**: Every container, button, card, and frame uses irregular border-radius values—never standard Tailwind rounded classes
- **Hand-Drawn SVG Decorations**:
  - Arrow pointing to hero CTA with dashed path
  - Squiggly connecting line between "How It Works" steps
  - Corner frame marks on hero image placeholder
- **Authentic Paper Effects**:
  - Tape strips (translucent gray rectangles) on feature cards
  - Thumbtack pins (colored circles) for card decoration
  - Dashed circle overlay highlighting popular pricing tier
  - Speech bubble geometric tails on testimonials
- **Playful Typography Treatments**:
  - Rotating exclamation mark in hero headline
  - Wavy underline decoration on navigation links and footer headers
  - Drop-cap first letter treatment in Product Detail section
  - Post-it yellow sticky-note tag on Product Detail card
- **Scribbled Accents**:
  - Bouncing decorative circle near hero image (desktop only)
  - Dashed borders on secondary elements and dividers
  - Emoji sketches in blog post placeholders
  - Line-through hover effect on footer links
- **Interactive Personality**:
  - Buttons "press flat" by eliminating shadow on active state
  - Cards rotate slightly on hover
  - Blog cards increase shadow offset on hover for "lift" effect
  - Grayscale-to-color transition on blog images (removed in final implementation for simplicity)

# Effects & Animation
- **Hover**: "Jiggle" effect. \`hover:rotate-1\` or \`hover:-rotate-2\`.
- **Transition**: \`transition-transform duration-100\` (Fast and snappy).

# Spacing, Layout & Iconography
- **Max Width**: \`max-w-5xl\` (Keep it contained like a sketchbook).
- **Icons**: \`lucide-react\` icons with \`stroke-width={2.5}\` or \`3\`.
- **Icon Style**: Enclose key icons in rough circles.

# Responsive Strategy

**Mobile-First Approach:**
- **Typography Scaling**:
  - Headings: \`text-4xl md:text-5xl\` or \`text-5xl md:text-6xl\`
  - Body text: \`text-lg md:text-xl\` or \`text-base md:text-xl\`
  - Buttons: \`text-lg md:text-2xl\`
- **Layout Stacking**:
  - All grids collapse to single column on mobile, expand to 2-3 columns on \`md:\` breakpoint
  - Hero switches from 2-column to stacked with \`md:grid-cols-2\`
  - Stats: 2-column grid on mobile (\`grid-cols-2\`), 4-column on desktop (\`md:grid-cols-4\`)
- **Hide Decorative Elements**:
  - Hand-drawn arrow near CTA: \`hidden md:block\`
  - Bouncing decorative circle: \`hidden md:block\`
  - Squiggly connecting line in "How It Works": \`hidden md:block\`
  - Dashed circle on pricing card: \`hidden md:block\`
- **Maintain Core Aesthetic**:
  - Keep wobbly borders and handwritten fonts on all screen sizes
  - Reduce rotation slightly if needed (\`-rotate-1\` instead of \`-rotate-2\`)
  - Maintain hard offset shadows (never add blur)
  - Preserve playful personality and irregular shapes
- **Touch-Friendly Targets**:
  - Buttons use minimum \`h-12\` (48px) for accessibility
  - Adequate spacing between interactive elements with \`gap-8\`
- **Spacing Adjustments**:
  - Section padding remains \`py-20\` for vertical rhythm
  - Reduce horizontal padding when needed: \`px-6\`
  - Stats scale down: \`h-24 w-24 md:h-32 md:w-32\`
  - Pricing cards: \`p-6 md:p-8\` for better mobile fit`},"swiss-minimalist":{id:"swiss-minimalist",name:"Swiss",mode:"light",fontType:"sans-serif",description:"A rigorous implementation of the International Typographic Style (1950s). Characterized by objective typography, sans-serif fonts (Inter), mathematical grids with subtle texture patterns, and a strict black/white/red palette. Prioritizes readability, precision, asymmetrical organization, and visual depth through layered patterns.",layoutIdeas:{hero:"Split screen composition with asymmetric 8:4 grid ratio. Left: massive typography (text-6xl to text-[10rem]) with geometric accent bar and functional CTAs. Right: geometric abstract composition with grid pattern overlay, featuring basic shapes (circles, rectangles, lines) in black/red on muted background.",stats:"Horizontal strip divided by visible borders. 2x2 grid on mobile, 1x4 on desktop. Massive numbers with hover scale animation, rotating plus icons, and color inversion on hover (black → red). No decorative icons, pure data presentation.",productDetail:"Split 7:5 grid. Left: 2x2 visual grid of geometric compositions with texture overlays (dots, diagonals, grid patterns). Right: large typographic headline with body text. Mobile stacks vertically.",features:"Asymmetric two-column layout. Left: sticky header with dots pattern overlay and numbered label (01. System). Right: stacked feature cards with thick borders, numbered indicators, diagonal arrow icons, and full hover state color inversion.",howItWorks:"Three-column grid with visible borders and black background. Each step features giant watermark numbers (text-8xl at 10% opacity), red accent border on left, and white text on black.",benefits:"Asymmetric 5:7 grid split. Left: diagonal pattern overlay with section header. Right: stacked list items with numbered box indicators, hover state inverts to black background with red accent numbers.",testimonials:"Three-column responsive grid (1 col mobile, 2 col tablet, 3 col desktop). Large red quotation mark, bold uppercase quote text, thick top border that changes to red on hover, subtle upward translation on hover.",pricing:"Three-column card layout with 4px black borders. Highlighted plan uses inverted colors (black bg, white text, red accents). Strict rectangular shapes, no rounded corners.",faq:"Two-column rigid grid (1 col mobile) with 4px black borders and 1px gaps creating visual grid. Each FAQ is a card with numbered label, rotating plus icon, and full hover inversion (white → red bg).",blog:"Four-column layout: 1 col sidebar with grid pattern (section header + CTA), 3 col article grid. Articles have date, title, read link with arrow. Hover inverts to black background.",footer:"Black background with four-column layout. Large uppercase brand name, underlined email input (not boxed), square social icons with white bg that invert to red on hover."},content:`# Design Style: Swiss International (International Typographic Style)

## Design Philosophy

**The International Typographic Style (Swiss Style)** is not merely a visual trend; it is a philosophy of objective communication born in 1950s Switzerland. It rejects personal expression and subjectivity in favor of universal clarity, mathematical precision, and logical structure.

**Core Tenets:**

1.  **Objectivity over Subjectivity**: The design must recede to let the content speak. Every visual decision must be justifiable by the content's needs. Personal ornamentation is eliminated in favor of functional communication. The designer is not an artist expressing themselves, but a conduit for information.

2.  **The Grid as Law**: The grid is the absolute authority. It is not a guideline; it is the visible skeleton of the information. We generally avoid static center-alignment in favor of **asymmetrical organization** to create dynamic visual rhythm and tension. Grid patterns are made visible through subtle background textures.

3.  **Typography is the Interface**: Type is not just for reading; it is the primary structural and graphical element. We use grotesque sans-serif typefaces (Inter, Helvetica) because they are neutral vessels for meaning. Scale, weight, and position are the only tools needed to create hierarchy.

4.  **Active Negative Space**: White space is not "empty"; it is an active structural element. It defines boundaries, gives weight to the massive typography, and creates breathing room for the intellect.

5.  **Layered Texture & Depth**: While maintaining flatness (no shadows or 3D effects), we achieve visual depth through **subtle pattern overlays**: grid lines (24px), dot matrices (16px), diagonal stripes, and noise textures. These patterns add tactile richness without compromising the objective aesthetic.

6.  **Universal Intelligibility**: The design should be understood instantly. It is clean, legible, and undeniably modern.

**The Vibe**:
*   **Intellectual & Architectural**: The page should feel like a well-engineered building, a museum exhibition, or a transit map—functional, safe, and efficient.
*   **Structured yet Organic**: While brutally honest in its geometry, subtle texture patterns provide warmth and visual interest—like fine paper grain or screen printing texture.
*   **Brutally Precise**: No gradients to hide bad layout. Depth comes from pattern, not shadow. The design is flat yet rich, stark yet nuanced.
*   **Timeless**: By avoiding ephemeral trends (glassmorphism, neumorphism, soft rounded corners), the design aims for permanence.

**Visual Signatures**:
*   **Flush-Left, Ragged-Right Text**: Text blocks are strictly left-aligned to the grid.
*   **Grotesque Sans-Serif**: Neutral, objective fonts with high x-heights (Inter, weight 400-900).
*   **Mathematical Scales**: Font sizes that relate to each other through clear ratios (responsive scaling from mobile to desktop).
*   **The "Swiss Red" (#FF3000)**: Used not as decoration, but as a functional signal—a stop sign, a warning, a highlight—piercing the monochrome calm.
*   **Pattern-Based Texture**: Subtle CSS-generated patterns (grid, dots, diagonals, noise) applied to background surfaces for visual depth without breaking flatness.
*   **Geometric Abstraction**: Basic shapes (circles, squares, rectangles, lines) arranged in Bauhaus-inspired compositions.

## Design Token System (The DNA)

### Colors (Strict Palette)
*   **Background**: \`#FFFFFF\` (Pure White) - The canvas must be neutral.
*   **Foreground**: \`#000000\` (Pure Black) - Text is absolute.
*   **Muted**: \`#F2F2F2\` (Light Gray) - Used for secondary backgrounds to create rhythm.
*   **Accent**: \`#FF3000\` (Swiss Red) - The **only** signal color. Used sparingly for CTAs and critical emphasis.
*   **Border**: \`#000000\` (Pure Black) - Structure is visible.

### Typography
*   **Font Family**: \`Inter\` (Google Font). Ideally closest to Helvetica/Akzidenz-Grotesk.
*   **Weights**: Heavy use of **Black (900)** and **Bold (700)** for headings. **Regular (400)** or **Medium (500)** for body.
*   **Style**: **UPPERCASE** for almost all headings and labels.
*   **Tracking**: \`tracking-tighter\` for large headlines, \`tracking-widest\` for small labels.
*   **Scale**: Extreme contrast. Headlines should be massive (\`text-7xl\` to \`text-9xl\`+). Body text is legible and objective.

### Radius & Border
*   **Radius**: \`0px\` (Strictly Rectangular). No rounded corners.
*   **Borders**: Thick, visible borders (\`border-2\` or \`border-4\`). Used to define the grid.

### Shadows & Effects
*   **Shadows**: No drop shadows. The design maintains flatness. Only use subtle ring shadows for compositional geometry (e.g., \`shadow-[0_0_0_8px_rgba(255,48,0,0.1)]\` for accent circles).
*   **Effects**: Interactive elements use simple color inversion (Black → White, White → Red), scale transforms (1.0 → 1.05), rotation (0deg → 90deg for plus icons), and vertical translation (-1px lift on hover).

### Textures & Patterns (Critical for Depth)
These CSS-based patterns add visual richness while maintaining the flat, objective aesthetic:

*   **Grid Pattern** (\`.swiss-grid-pattern\`):
    - Subtle 24×24px grid lines at 3% opacity
    - Applied to hero composition area, blog sidebar, muted backgrounds
    - Creates visible structure without overwhelming content

*   **Dot Matrix** (\`.swiss-dots\`):
    - Radial gradient dots, 16×16px spacing, 4% opacity
    - Applied to section headers, feature sidebars
    - Evokes traditional print techniques

*   **Diagonal Lines** (\`.swiss-diagonal\`):
    - 45-degree repeating lines, 10px spacing, 2% opacity
    - Applied to benefits sidebar, accent backgrounds
    - Adds directional energy to static layouts

*   **Noise Texture** (\`.swiss-noise\`):
    - Fractal noise overlay via SVG filter, 1.5% opacity
    - Applied globally to body background
    - Simulates paper texture, adds warmth to stark white backgrounds

**Application Strategy**: Use patterns on muted gray backgrounds (\`#F2F2F2\`) and occasionally on white surfaces. Never apply patterns to pure black backgrounds or red accent areas. Patterns should enhance, not dominate.

## Component Stylings

### Buttons
*   **Shape**: Strictly rectangular (\`rounded-none\`).
*   **Style**: Solid Black background with White text (Primary). White background with Black border (Secondary).
*   **Hover**: Invert colors or switch to Swiss Red (\`#FF3000\`).
*   **Typography**: Uppercase, bold, tracking-wide.

### Cards / Containers
*   **Structure**: Defined by their borders (\`border-black\`).
*   **Background**: White or Muted Gray (\`#F2F2F2\`).
*   **Padding**: Generous and uniform (\`p-8\`, \`p-12\`).
*   **Hover**: Entire card background changes color (e.g., to Swiss Red or Black) with text color inversion.

### Inputs
*   **Style**: Underlined (\`border-b\`) or solid rectangular box with thick border.
*   **Focus**: Sharp change in border color to Swiss Red. No glow rings.

## Layout Strategy

*   **The Grid**: The grid is God. It should often be **visible** (using borders on elements).
*   **Asymmetry**: Embrace asymmetrical balance. A large photo on the left balanced by negative space and small text on the right.
*   **Alignment**: Strict left alignment for text.
*   **Separators**: Use horizontal and vertical lines to divide sections.

## Non-Genericness (The "Bold" Factor)

This implementation goes beyond "generic Swiss style" by incorporating:

*   **Massive Responsive Typography**: Headlines scale from \`text-6xl\` (mobile) to \`text-[10rem]\` (desktop). Let words be images.
*   **Visible Structure**: The layout grid is made tangible through:
    - Thick 4px black borders defining sections
    - Visible grid patterns (24px) on backgrounds
    - Asymmetric column ratios (8:4, 7:5, 5:7) creating dynamic tension
*   **Numbered Section Labels**: Every major section has a prefix (01. System, 02. Method, 03. Advantages, 04. Journal) in red accent with uppercase tracking
*   **Layered Geometric Compositions**:
    - Hero features abstract Bauhaus-style composition with overlapping shapes
    - Product detail uses 2×2 grid of geometric elements with different texture patterns
    - Each composition combines circles, rectangles, lines in purposeful arrangement
*   **Pattern-Based Texture**: Four distinct CSS patterns (grid, dots, diagonal, noise) applied strategically to create depth without shadows
*   **Bold Interaction States**:
    - Full color inversions (not just opacity fades)
    - Rotating icons (plus signs spin 90°)
    - Scale transforms on hover
    - Vertical slide animations in navigation
*   **Active Negative Space**: Generous padding (p-12, p-24) and asymmetric layouts create breathing room and visual tension
*   **Functional Color System**: Red is used only for:
    - Primary CTAs and accents
    - Hover states as visual feedback
    - Section number prefixes
    - Never as decorative fill

## Spacing & Iconography

*   **Spacing**: High density in information clusters (tables), but high spaciousness in narrative sections.
*   **Iconography**: Use \`lucide-react\` icons, but treat them as functional symbols. Stroke width should match typography. Often enclosed in geometric shapes (squares/circles).

## Animation

*   **Feel**: Instant, mechanical, snappy, precise. Movement is purposeful and geometric.
*   **Transitions**: \`duration-200 ease-out\` or \`duration-150 ease-linear\` for rapid feedback. No elastic or spring animations.
*   **Micro-interactions**:
    - **Navigation Links**: Vertical slide animation with color change (text slides up, red replacement slides in from below)
    - **Stats Cards**: Scale transform on numbers (1.0 → 1.05), rotating plus icons (0° → 90°), background color snap (black → red)
    - **Feature Cards**: Color inversion on hover (white → accent red), arrow rotation (-45° → 0°)
    - **Testimonials**: Subtle upward lift (-1px translateY), border color change (black → red), quote text color change
    - **FAQ Cards**: Rotating plus icons, full background color inversion (white → red)
    - **Buttons**: Instant background color changes, no scale transforms
*   **Hover States**: Always indicate interactivity through color, scale, or position changes—never subtle fades. Swiss style is bold and immediate.

## Responsive Strategy

The Swiss style must maintain its bold character across all screen sizes:

**Mobile (< 768px)**:
*   Typography scales down but remains bold: \`text-6xl\` for hero headlines
*   Single column layouts with vertical stacking
*   Borders remain 4px thick (never thin out)
*   CTAs become full-width buttons with consistent height (\`h-16\`)
*   Grid patterns and textures maintain same opacity/scale
*   Stats become 2×2 grid instead of 1×4
*   Navigation collapses (visible only on desktop)

**Tablet (768px - 1024px)**:
*   Two-column layouts for testimonials, FAQ, features
*   Typography scales to \`text-8xl\` for headlines
*   Asymmetric grids start to appear
*   Touch targets remain minimum 44×44px

**Desktop (1024px+)**:
*   Full asymmetric grid layouts (8:4, 7:5, 5:7 ratios)
*   Maximum typography scale (\`text-9xl\`, \`text-[10rem]\`)
*   Multi-column layouts (3-4 columns for blog, footer)
*   Sticky positioning for section headers
*   All hover states and micro-interactions active

**Key Principles**:
- Never compromise on border thickness or contrast
- Maintain uppercase typography and tight tracking
- Patterns remain visible at all breakpoints
- Red accent color used consistently across devices
- Spacing remains generous (reduce from p-24 to p-12 on mobile, but never less)

## Accessibility

*   **Contrast**: The Black/White/Red scheme naturally offers ultra-high contrast (21:1 for black/white). Ensure red text on white meets AA standards.
*   **Focus**: High-contrast 2px ring in red (\`focus-visible:ring-2 focus-visible:ring-swiss-accent focus-visible:ring-offset-2\`)
*   **Touch Targets**: All interactive elements minimum 44×44px on mobile
*   **Motion**: All animations are CSS-based and respect \`prefers-reduced-motion\`
*   **Semantics**: Proper heading hierarchy, semantic HTML5 elements, ARIA labels where needed`}
(total 27347 chars)

========== minimal-dark ==========
--- record 0 (len 89) ---
{id:"minimal-dark",name:"Minimal Dark",path:"/minimal-dark",mode:"dark",accent:"#F59E0B"}
(total 89 chars)
--- record 1 (len 33547) ---
{id:"minimal-dark",name:"Simple Dark",mode:"dark",fontType:"sans-serif",description:"An atmospheric dark mode design system built on deep slate tones with warm amber accents. Features ambient glow effects, glass-like translucent cards, geometric typography, and generous breathing room. Ethereal yet grounded—like a premium app at midnight.",layoutIdeas:{hero:"Centered layout with massive headline. Ambient glow behind text creates depth. Trust badge floats above with subtle glow and pulsing dot. CTAs side by side with amber glow effect on primary button hover. Background has very subtle radial gradient warmth.",stats:"Horizontal strip with glass-effect background. Stats separated by subtle vertical dividers (1px, low opacity). Numbers in display font with amber accent. Subtle top/bottom borders.",productDetail:"Two-column layout. Left side has ambient glow orb decoration. Text content right-aligned on left column. Right column has floating glass card with abstract UI mockup inside.",features:"Clean 3-column grid of glass cards. Icons in amber-tinted circles. Hover reveals subtle glow. First feature can span 2 columns for emphasis. Consistent card heights.",howItWorks:"Horizontal numbered steps. Large circled numbers with amber fill. Connecting line between steps (subtle, dashed). Cards below each with glass effect.",benefits:"Split layout with large ambient orb on left side. Benefits as a clean list on right with amber checkmarks. Generous spacing between items.",pricing:"3-column glass cards. Highlighted tier has amber border glow, 'Popular' badge, and is slightly larger (scale-105 + translate-y-4 on desktop for prominence). Prices large in display font. Feature lists with subtle checkmarks.",testimonials:"Staggered 3-column layout. Glass cards with subtle amber accent line on left edge. Avatar images with ring border. Quote in italic.",faq:"Clean accordion with plus/minus icons. Questions in medium weight, answers in regular. Subtle dividers between items. No backgrounds.",blog:"3-column grid with glass card effect on images. Hover lifts card slightly. Date/author in muted text. Clean typography hierarchy.",footer:"Multi-column with subtle top border. Logo and description left. Nav groups right. Social icons as subtle ghost buttons. Very clean, minimal."},content:`# Design Style: Minimalist Dark

## Design Philosophy

### Core Principle

**Atmospheric Depth.** Minimalist Dark creates visual interest not through color saturation or complex patterns, but through carefully orchestrated layers of darkness. Multiple shades of slate and charcoal stack upon each other, with warm amber accents that glow like embers in the night. The design breathes—generous whitespace (or rather, "darkspace") gives every element room to exist.

### Visual Vibe

**Emotional Keywords**: Atmospheric, Sophisticated, Calm, Premium, Nocturnal, Refined, Spacious, Warm-cool contrast, Ethereal, Grounded

This is the visual language of:
- Premium dark mode applications (Linear, Raycast, Arc)
- High-end developer tools (Vercel, Railway)
- Luxury tech products at night
- A beautifully designed app you'd use at 2am
- The quiet confidence of well-crafted software

The design feels like working in a perfectly lit room at night—everything is visible, nothing strains the eyes, and there's a sense of calm focus.

### What This Design Is NOT

- ❌ Pure black (uses rich slate tones instead)
- ❌ Harsh or high contrast
- ❌ Colorful or vibrant
- ❌ Cold or sterile
- ❌ Flat or shadowless
- ❌ Similar to Minimalist Modern (no blue gradients, no rounded-lg everywhere)
- ❌ Similar to Minimalist Monochrome (has color accent, softer edges, not editorial)

### The DNA of Minimalist Dark

#### 1. Layered Slate Palette
Not pure black—rich slate tones (#0A0A0F as the deepest, #12121A as card backgrounds, #1A1A24 as elevated surfaces). Each layer is subtly different, creating depth through darkness itself.

#### 2. Warm Amber Accent
A single warm accent color (#F59E0B / amber-500) creates beautiful contrast against cool dark tones. Used sparingly for interactive elements, highlights, and focal points. The warmth prevents the design from feeling cold.

#### 3. Ambient Glow Effects
Soft, blurred glows behind key elements create atmospheric depth. Not harsh drop shadows—think ambient light bleeding through darkness. Applied to buttons on hover (0_0_20px with 0.4 opacity), hero badges, testimonial accent lines, and decorative orbs. The glows are subtle but critical to the atmospheric quality—they create that "light in the darkness" feeling.

#### 4. Glass-Effect Cards
Cards use semi-transparent backgrounds with subtle backdrop blur. Border opacity is low (10-15%). This creates a layered, floating effect without harsh edges.

#### 5. Geometric Sans Typography
Space Grotesk for display, Inter for body. Clean, geometric letterforms that feel modern and technical. Strong hierarchy through size and weight, not color variation.

#### 6. Generous Breathing Room
Extremely spacious layouts. Large section padding. Content doesn't crowd—it floats in space. This breathing room is essential to the premium feel.

#### 7. Subtle Borders
Borders exist but are very subtle—usually 1px at 10-20% opacity. They define edges without drawing attention. No thick, heavy borders.

### Differentiation from Other Minimalist Styles

| Aspect | Minimalist Modern | Minimalist Monochrome | Minimalist Dark |
|--------|-------------------|----------------------|-----------------|
| Mode | Light | Light | **Dark** |
| Background | Off-white | Pure white | Deep slate (#0A0A0F) |
| Accent | Blue gradients | None (black only) | Warm amber (#F59E0B) |
| Typography | Sans + Display serif | Serif throughout | Geometric sans |
| Corners | Rounded (lg, xl) | Sharp (0px) | Soft rounded (md, lg) |
| Depth | Shadows + glows | Flat, no shadows | Ambient glows + glass |
| Feel | Energetic, contemporary | Editorial, austere | Atmospheric, calm |
| Borders | Subtle | Heavy black lines | Very subtle, low opacity |

---

## Design Token System

### Colors (Dark Slate + Amber)

\`\`\`
background:       #0A0A0F (Deep slate - almost black but warmer)
backgroundAlt:    #12121A (Slightly elevated surfaces)
foreground:       #FAFAFA (Near-white text)
muted:            #1A1A24 (Card backgrounds, elevated surfaces)
mutedForeground:  #71717A (Secondary text - zinc-500)
accent:           #F59E0B (Amber-500 - warm, glowing)
accentForeground: #0A0A0F (Dark text on amber)
accentMuted:      rgba(245, 158, 11, 0.15) (Amber glow backgrounds)
border:           rgba(255, 255, 255, 0.08) (Very subtle borders)
borderHover:      rgba(255, 255, 255, 0.15) (Borders on hover)
card:             rgba(26, 26, 36, 0.6) (Semi-transparent cards)
cardSolid:        #1A1A24 (Solid card background)
ring:             #F59E0B (Focus ring)
\`\`\`

### Typography

**Font Stack**:
- **Display/Headlines**: \`"Space Grotesk", system-ui, sans-serif\` - Geometric, technical, distinctive
- **Body**: \`"Inter", system-ui, sans-serif\` - Clean, highly readable
- **Mono**: \`"JetBrains Mono", monospace\` - For code, labels, metadata

**Type Scale**:
\`\`\`
xs:   0.75rem   (12px)
sm:   0.875rem  (14px)
base: 1rem     (16px)
lg:   1.125rem (18px)
xl:   1.25rem  (20px)
2xl:  1.5rem   (24px)
3xl:  2rem     (32px)
4xl:  2.5rem   (40px)
5xl:  3.5rem   (56px)
6xl:  4.5rem   (72px)
7xl:  6rem     (96px)
\`\`\`

**Tracking**:
- Headlines: \`tracking-tight\` (-0.025em)
- Body: \`tracking-normal\` (0)
- Labels/Mono: \`tracking-wide\` (0.025em)

### Border Radius

\`\`\`
sm:   0.375rem (6px)
md:   0.5rem   (8px) - Default for most elements
lg:   0.75rem  (12px) - Cards, larger containers
xl:   1rem     (16px) - Hero elements, large cards
2xl:  1.5rem   (24px) - Special decorative elements
full: 9999px   - Pills, avatars
\`\`\`

Softer than sharp corners, but not as dramatically rounded as Modern.

### Shadows & Glows

\`\`\`
// Subtle elevation shadows
sm:   0 1px 2px rgba(0, 0, 0, 0.3)
md:   0 4px 6px rgba(0, 0, 0, 0.3)
lg:   0 10px 15px rgba(0, 0, 0, 0.3)
xl:   0 20px 25px rgba(0, 0, 0, 0.4)

// Ambient glows (the signature effect)
glowSm:   0 0 20px rgba(245, 158, 11, 0.15)
glowMd:   0 0 40px rgba(245, 158, 11, 0.2)
glowLg:   0 0 60px rgba(245, 158, 11, 0.25)

// Border glow for highlighted elements
borderGlow: 0 0 0 1px rgba(245, 158, 11, 0.3), 0 0 20px rgba(245, 158, 11, 0.15)
\`\`\`

### Textures & Patterns

**Subtle Noise Overlay** (very low opacity):
\`\`\`css
background-image: url("data:image/svg+xml,...noise...");
opacity: 0.02;
\`\`\`

**Radial Gradient Ambience** (for section backgrounds):
\`\`\`css
background: radial-gradient(ellipse at top, rgba(245, 158, 11, 0.03) 0%, transparent 50%);
\`\`\`

**Subtle Grid** (optional, for specific sections):
\`\`\`css
background-image: linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
                  linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
background-size: 40px 40px;
\`\`\`

---

## Component Stylings

### Buttons

**Primary Button**:
\`\`\`
- Background: #F59E0B (amber)
- Text: #0A0A0F (dark)
- Border: none
- Radius: rounded-lg (12px)
- Padding: px-6 py-3 (h-11 for default size)
- Font: font-medium, no uppercase
- Hover: brightness-110, shadow-[0_0_20px_rgba(245,158,11,0.4)]
- Active: scale-[0.98] (subtle press effect)
- Focus-visible: ring-2 ring-[var(--accent)] ring-offset-2
- Transition: all 200ms ease-out
\`\`\`

**Secondary/Outline Button**:
\`\`\`
- Background: transparent
- Text: #FAFAFA
- Border: 1px solid rgba(255,255,255,0.15)
- Hover: bg-white/5, border-white/25
- Active: scale-[0.98]
- Focus-visible: Same as primary
\`\`\`

**Ghost Button**:
\`\`\`
- Background: transparent
- Text: #FAFAFA
- Border: none
- Hover: bg-white/5
- Active: scale-[0.98]
- Focus-visible: Same as primary
\`\`\`

### Cards (Glass Effect)

**Standard Card**:
\`\`\`css
background: rgba(26, 26, 36, 0.6);
backdrop-filter: blur(8px);
border: 1px solid rgba(255, 255, 255, 0.08);
border-radius: 12px;
transition: all 300ms ease-out;
\`\`\`

**Hover State** (when interactive):
\`\`\`css
border-color: rgba(255, 255, 255, 0.15);
background: rgba(26, 26, 36, 0.8);
transform: scale(1.02);
box-shadow: 0 10px 15px rgba(0, 0, 0, 0.3);
\`\`\`

**Highlighted Card** (e.g., featured pricing tier):
\`\`\`css
/* Same as standard plus: */
border: 1px solid rgba(245, 158, 11, 0.2);
box-shadow: 0 0 0 1px rgba(245, 158, 11, 0.2), 0 0 30px rgba(245, 158, 11, 0.15);
/* On desktop, can also use scale(1.05) and translate-y for emphasis */
\`\`\`

### Inputs

\`\`\`
- Background: rgba(26, 26, 36, 0.6)
- Backdrop-filter: blur(8px)
- Border: 1px solid rgba(255,255,255,0.08)
- Radius: rounded-lg
- Height: h-11 (44px for proper touch target)
- Text: #FAFAFA
- Placeholder: #71717A
- Focus: border-amber-500/50, ring-2 ring-amber-500/20, shadow-[0_0_20px_rgba(245,158,11,0.1)]
- Transition: all 200ms
\`\`\`

---

## Layout Strategy

### Container
\`\`\`
max-width: max-w-6xl (72rem)
padding: px-6 md:px-8 lg:px-12
\`\`\`

### Section Spacing
\`\`\`
padding: py-24 md:py-32 lg:py-40
\`\`\`
Very generous—let the dark space breathe.

### Grid System
- Prefer simple grids: 2-col, 3-col
- Gap: gap-6 or gap-8
- Items don't need to touch—floating in space is fine

---

## Effects & Animation

**Motion Philosophy**: Smooth and subtle with delightful micro-interactions

- **Transitions**: 200-300ms, ease-out (cards use 300ms for smoother feel)
- **Hover effects**:
  - Cards: Subtle scale (scale-[1.02]), border brightening, glow increase
  - Buttons: Glow increase (shadow intensity up to 0.4), brightness boost
  - Links: Color shift to accent on focus-visible
- **Active states**: Buttons have subtle press effect (scale-[0.98])
- **Animations**:
  - Hero badge pulse dot (animate-pulse with glow)
  - FAQ accordion smooth height transition (max-h with opacity fade)
- **No**: Bouncy animations, dramatic transforms
- **Yes**: Gentle fades, soft glows, smooth state changes, subtle scales

\`\`\`css
/* Cards */
transition: all 300ms ease-out;

/* Buttons & Quick Interactions */
transition: all 200ms ease-out;
\`\`\`

**Ambient Orbs** (decorative background elements):
- Large blurred circles with amber glow
- Very low opacity (0.02-0.04)
- Positioned strategically (top center, bottom right as fixed backgrounds)
- Blur values: 100px-150px for soft, diffused light
- Responsive: Smaller dimensions on mobile for performance (h-[400px] on mobile vs h-[600px] on desktop)

---

## Iconography

**Style**: Clean, thin strokes

\`\`\`tsx
<Icon size={20} strokeWidth={1.5} className="text-zinc-400" />
// Active/accent state:
<Icon size={20} strokeWidth={1.5} className="text-amber-500" />
\`\`\`

Icons should be subtle, not attention-grabbing. They support content, not dominate it.

---

## Responsive Strategy

**Mobile Adaptations**:
- Maintain dark palette and warm accent - no compromises on aesthetic
- Scale typography smoothly: \`text-4xl sm:text-5xl md:text-6xl lg:text-7xl\`
- Stack columns vertically (\`lg:grid-cols-2\` for two-column layouts)
- Reduce ambient glow orb sizes for performance (but keep them!)
- Generous vertical spacing maintained (\`py-24 md:py-32 lg:py-40\`)
- Touch targets: minimum 44px height (buttons use h-11 or h-12)
- Navigation hidden on mobile (\`hidden md:flex\`), hamburger menu implied
- All hover states also work as active states on touch devices
- Glass effects maintained (backdrop-blur is performant on modern mobile)

**Key Principle**: The atmospheric quality must survive on mobile. This isn't a "mobile-simplified" version—it's the same premium experience, just adapted to screen size.

---

## Accessibility

**Contrast**:
- Primary text (#FAFAFA) on background (#0A0A0F): 18.4:1 ratio (exceeds AAA)
- Muted text (#71717A) on background: 4.9:1 ratio (meets AA)
- Amber accent readable on both dark and light contexts

**Focus States**:
All interactive elements have clear, accessible focus states using \`focus-visible\`:

**Buttons**:
\`\`\`css
focus-visible:outline-none
focus-visible:ring-2
focus-visible:ring-[var(--accent)]
focus-visible:ring-offset-2
focus-visible:ring-offset-[var(--background)]
\`\`\`

**Links** (nav, footer, etc.):
\`\`\`css
focus-visible:text-[var(--accent)]
focus-visible:outline-none
\`\`\`

**Inputs**:
\`\`\`css
focus:border-[var(--accent)]/50
focus:outline-none
focus:ring-2
focus:ring-[var(--accent)]/20
\`\`\`

The amber accent color is used consistently for all focus indicators, maintaining brand coherence while ensuring visibility.

---

## Bold Choices (Non-Negotiable)

1. **Layered darkness**: At least 3 distinct dark tones visible (#0A0A0F → #12121A → #1A1A24)
2. **Warm amber accent**: No cold blues—#F59E0B amber creates the signature warmth
3. **Ambient glow effects**:
   - Hero badge: subtle glow + pulsing dot
   - Buttons on hover: 0_0_20px glow at 0.4 opacity
   - Testimonial accent lines: soft glow
   - Background ambient orbs: massive blur (100-150px)
4. **Glass-effect cards**: Semi-transparent (0.6 opacity) with backdrop blur (8px)
5. **Generous spacing**: py-24 md:py-32 lg:py-40 sections feel spacious, not cramped
6. **Subtle borders**: rgba(255,255,255,0.08) - just 8% opacity, never harsh
7. **Geometric typography**: Space Grotesk for headlines, Inter for body, JetBrains Mono for labels
8. **Atmospheric background**: Fixed ambient orbs + subtle noise texture (0.015 opacity)
9. **Micro-interactions**:
   - Cards scale up on hover (1.02)
   - Buttons scale down on active (0.98)
   - Smooth FAQ accordion with height + opacity transitions
   - All focus states use amber accent

---

## What Success Looks Like

A successfully implemented Minimalist Dark design should feel like:
- Using Linear or Raycast at night
- A premium developer tool's marketing site
- Software designed for focus and calm
- Warm light glowing in a dark room

It should NOT feel like:
- A generic dark theme with colors inverted
- Harsh or high-contrast
- Cold or unwelcoming
- A copy of Minimalist Modern with dark colors
- Just "dark mode"—it should have its own personality`},"modern-dark":{id:"modern-dark",name:"Modern Dark",mode:"dark",fontType:"sans-serif",description:"A cinematic, high-precision dark mode design featuring layered ambient lighting through animated gradient blobs, mouse-tracking spotlight effects, and meticulously crafted micro-interactions that feel like premium software.",layoutIdeas:{hero:"Centered cinematic hero with parallax scroll effects, gradient headline treatment, and floating announcement badge with ping animation. Trust indicators displayed as overlapping avatars below CTAs.",stats:"Bold 4-column grid with gradient text for numbers, trend badges, and subtle hover glow effects. Numbers use massive typography (text-7xl) with gradient fills.",productDetail:"Split 2-column layout with text content on left and mock interface visual on right. Mock interface includes macOS-style window controls and abstract UI components with accent highlights.",features:"Asymmetric 6-column bento grid with varying card sizes. Hero feature card spans 4 columns and 2 rows with integrated data visualization. Cards use mouse-tracking spotlight effects.",blog:"Magazine-style 3-column grid with hover-zoom images, gradient overlays on hover, and clean metadata presentation. Images have subtle opacity transitions.",howItWorks:"3-column grid with numbered cards featuring glowing accent borders. Step numbers displayed in large format with glow effects. Connection line spans across cards on desktop.",benefits:"Sticky left column with scrolling right column. Right side features stacked cards with checkmark icons and hover border accent effects.",testimonials:"3-column masonry grid with star ratings, quote text, and author cards. Cards lift slightly on hover with subtle shadow enhancement.",pricing:"3-column tier grid with highlighted middle tier. Badge labels, large pricing typography, checkmark feature lists, and full-width CTAs. Highlighted tier has enhanced glow shadow.",faq:"Centered single-column accordion with animated height transitions and rotating chevron icons. Smooth expand/collapse with expo-out easing.",footer:"5-column grid with brand section, navigation columns, and social links. Subtle separation with top border and legal links in footer bottom."},content:`# Design Style: Linear / Modern

## Design Philosophy

**Core Principles:** Precision, depth, and fluidity define this design system. Every surface exists in three-dimensional space, illuminated by soft ambient light sources that breathe and move. The design communicates "premium developer tools"—fast, responsive, and obsessively crafted like Linear, Vercel, or Raycast. Nothing is arbitrary: every shadow has three layers, every gradient transitions through multiple colors, every animation uses refined expo-out easing. The goal is software that feels expensive without feeling ostentatious.

**Vibe:** Cinematic meets technical minimalism. Imagine a developer's code editor crossed with a Blade Runner interface—deep near-blacks (#050506, never pure black) punctuated by soft pools of indigo light. The aesthetic is sophisticated but never cold, using warmth from accent glows (#5E6AD2 at varying opacities) to create inviting depth. It should feel like looking through frosted glass into a high-end application running at night. Dark, but not oppressive. Technical, but not sterile. Precise, but not rigid.

**Differentiation:** The signature of this style is **layered ambient lighting and interactive depth**. Unlike flat dark modes or simple gradient overlays, this creates genuine atmospheric presence through:

1. **Multi-layer background system:** Four stacked gradients + noise texture + grid overlay create depth without any single dominant element
2. **Animated gradient blobs:** Large (900-1400px), heavily blurred shapes float slowly across the canvas, simulating cinematic lighting pools
3. **Mouse-tracking spotlights:** Interactive surfaces respond to cursor position with radial gradient glows (300px diameter, 15% opacity)
4. **Scroll-linked parallax:** Hero content fades, scales, and translates based on scroll position for cinematic depth
5. **Multi-layer shadows:** Every elevated surface uses 3-4 shadow layers: border highlight + soft diffuse + ambient darkness + optional accent glow
6. **Precision micro-interactions:** All animations are 200-300ms with expo-out easing. Movements are tiny (4-8px max). Scale changes are subtle (0.98-1.02). Nothing bounces or overshoots.

**The "Software Feel":** This design should feel like using a desktop application, not a website. Interactions are instant and precise. Hover states are immediate. Focus rings are prominent. Everything responds to the cursor. The aesthetic borrows from native macOS/Windows design systems—subtle transparency, soft glows, refined typography, obsessive attention to 1px details.

---

## Design Token System (The DNA)

### Color Strategy: Deep Space with Ambient Light

The palette is built on near-black bases with a single saturated indigo accent. Depth comes from layered translucency and soft light sources, not harsh shadows.

| Token | Value | Usage |
|:------|:------|:------|
| \`background-deep\` | \`#020203\` | Absolute darkest — footer, deepest layers |
| \`background-base\` | \`#050506\` | Primary page canvas |
| \`background-elevated\` | \`#0a0a0c\` | Elevated surfaces, mock interfaces |
| \`surface\` | \`rgba(255,255,255,0.05)\` | Card backgrounds, containers |
| \`surface-hover\` | \`rgba(255,255,255,0.08)\` | Hovered card state |
| \`foreground\` | \`#EDEDEF\` | Primary text — bright but not pure white |
| \`foreground-muted\` | \`#8A8F98\` | Body text, descriptions, metadata |
| \`foreground-subtle\` | \`rgba(255,255,255,0.60)\` | Tertiary text, placeholders |
| \`accent\` | \`#5E6AD2\` | Primary interactive color — buttons, links, glows |
| \`accent-bright\` | \`#6872D9\` | Hover state for accent |
| \`accent-glow\` | \`rgba(94,106,210,0.3)\` | Glow effects, ambient lighting |
| \`border-default\` | \`rgba(255,255,255,0.06)\` | Subtle hairline borders |
| \`border-hover\` | \`rgba(255,255,255,0.10)\` | Border on hover |
| \`border-accent\` | \`rgba(94,106,210,0.30)\` | Accent-tinted borders for emphasis |

### Background System: Layered Ambient Lighting

The background is never flat. It's a composition of multiple layers:

**Layer 1 — Base Gradient:**
\`\`\`
bg-[radial-gradient(ellipse_at_top,#0a0a0f_0%,#050506_50%,#020203_100%)]
\`\`\`
A radial gradient emanating from top-center creates vertical depth.

**Layer 2 — Noise Texture:**
A subtle SVG noise pattern at \`opacity: 0.015\` adds tactile quality and prevents banding.

**Layer 3 — Animated Gradient Blobs:**
Multiple large, heavily blurred shapes create ambient "light pools":
- Primary blob: Top-center, \`blur-[150px]\`, 900×1400px, accent color at 25% opacity
- Secondary blob: Left side, \`blur-[120px]\`, 600×800px, purple/pink mix at 15% opacity
- Tertiary blob: Right side, \`blur-[100px]\`, 500×700px, indigo/blue mix at 12% opacity
- Bottom accent: Lower area, pulsing animation, accent at 10% opacity

**Blob Animation:** Blobs float slowly using keyframe animations:
\`\`\`css
@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(1deg); }
}
/* Duration: 8-10s, ease-in-out, infinite */
\`\`\`

**Layer 4 — Grid Overlay:**
A subtle 64px grid pattern at \`opacity: 0.02\` adds technical precision.

---

### Typography System

**Font Stack:** \`"Inter", "Geist Sans", system-ui, sans-serif\`

**Type Scale & Weights:**

| Level | Size | Weight | Tracking | Usage |
|:------|:-----|:-------|:---------|:------|
| Display | \`text-7xl\` to \`text-8xl\` | \`font-semibold\` | \`tracking-[-0.03em]\` | Hero headlines |
| H1 | \`text-5xl\` to \`text-6xl\` | \`font-semibold\` | \`tracking-tight\` | Section headers |
| H2 | \`text-3xl\` to \`text-4xl\` | \`font-semibold\` | \`tracking-tight\` | Subsection headers |
| H3 | \`text-xl\` to \`text-2xl\` | \`font-semibold\` | \`tracking-tight\` | Card titles |
| Body Large | \`text-lg\` to \`text-xl\` | \`font-normal\` | default | Lead paragraphs |
| Body | \`text-sm\` to \`text-base\` | \`font-normal\` | default | Standard content |
| Label | \`text-xs\` | \`font-mono\` | \`tracking-widest\` | Section tags, metadata |

**Gradient Text Treatment:**
Headlines use gradient fills for dimensionality:
\`\`\`
bg-gradient-to-b from-white via-white/95 to-white/70 bg-clip-text text-transparent
\`\`\`

For accent emphasis, use animated gradient:
\`\`\`
bg-gradient-to-r from-[#5E6AD2] via-indigo-400 to-[#5E6AD2] bg-clip-text text-transparent
/* With background-size: 200% and animation for shimmer effect */
\`\`\`

**Line Heights:**
- Headlines: \`leading-tight\` or \`leading-none\`
- Body text: \`leading-relaxed\`

---

### Radius & Border System

| Element | Radius | Border |
|:--------|:-------|:-------|
| Large containers | \`rounded-2xl\` (16px) | \`border border-white/[0.06]\` |
| Cards | \`rounded-2xl\` (16px) | \`border border-white/[0.06]\` |
| Buttons | \`rounded-lg\` (8px) | Inset shadow instead of border |
| Inputs | \`rounded-lg\` (8px) | \`border border-white/10\` |
| Badges/Pills | \`rounded-full\` | \`border border-accent/30\` |
| Icons containers | \`rounded-xl\` (12px) | \`border border-white/10\` |

**Border Gradients on Hover:**
Cards can have animated gradient borders that fade in on hover:
\`\`\`css
background: linear-gradient(to bottom, rgba(94,106,210,0.3), transparent);
mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
mask-composite: exclude;
padding: 1px;
\`\`\`

---

### Shadow & Glow System

**Multi-Layer Shadow Formula:**
Shadows combine multiple layers for realistic depth:

\`\`\`
/* Card default */
shadow-[0_0_0_1px_rgba(255,255,255,0.06),0_2px_20px_rgba(0,0,0,0.4),0_0_40px_rgba(0,0,0,0.2)]

/* Card hover */
shadow-[0_0_0_1px_rgba(255,255,255,0.1),0_8px_40px_rgba(0,0,0,0.5),0_0_80px_rgba(94,106,210,0.1)]
\`\`\`

**Accent Glow for CTAs:**
\`\`\`
shadow-[0_0_0_1px_rgba(94,106,210,0.5),0_4px_12px_rgba(94,106,210,0.3),inset_0_1px_0_0_rgba(255,255,255,0.2)]
\`\`\`

**Inner Highlight:**
Buttons and elevated surfaces get a subtle top edge highlight:
\`\`\`
shadow-[inset_0_1px_0_0_rgba(255,255,255,0.1)]
\`\`\`

---

## Component Styling Principles

### Buttons

**Primary Button:**
- Background: Solid accent color (\`bg-[#5E6AD2]\`)
- Text: White
- Shadow: Multi-layer with accent glow
- Hover: Slightly brighter (\`bg-[#6872D9]\`), increased glow
- Active: \`scale-[0.98]\`, reduced shadow
- Shine effect: Pseudo-element gradient sweep on hover

**Secondary Button:**
- Background: \`bg-white/[0.05]\`
- Text: \`text-[#EDEDEF]\`
- Border: Inset shadow only
- Hover: \`bg-white/[0.08]\`, subtle outer glow

**Ghost Button:**
- Background: Transparent
- Text: Muted foreground
- Hover: \`bg-white/[0.05]\`, text brightens

### Cards & Containers

**Base Card:**
- Background: \`bg-gradient-to-b from-white/[0.08] to-white/[0.02]\`
- Border: 1px at 6% white opacity
- Radius: \`rounded-2xl\`
- Inner glow line: 1px gradient at top edge
- Mouse-tracking spotlight effect (optional)

**Spotlight Effect:**
Cards track mouse position and render a radial gradient that follows the cursor:
\`\`\`jsx
// Radial gradient, 300px diameter, accent color at 15% opacity
// Positioned at mouse coordinates relative to card
// Opacity transitions on hover
\`\`\`

**Card Variants:**
- \`default\`: Standard glass effect
- \`glass\`: More translucent with backdrop blur
- \`gradient\`: Subtle accent gradient overlay

### Form Inputs

- Background: \`bg-[#0F0F12]\`
- Border: \`border-white/10\`
- Focus: \`border-[#5E6AD2]\` with accent glow ring
- Text: \`text-gray-100\`
- Placeholder: \`text-gray-500\`

### Interactive States

**Hover Principles:**
- Movement is minimal: \`y: -4px\` to \`y: -8px\` maximum
- Duration: \`200-300ms\`
- Easing: \`[0.16, 1, 0.3, 1]\` (expo out)
- Changes: Border brightens, glow increases, subtle scale

**Focus States:**
- Ring: \`ring-2 ring-[#5E6AD2]/50 ring-offset-2 ring-offset-[#050506]\`

**Active States:**
- Scale: \`scale-[0.98]\`
- Shadow: Reduced depth

**Mobile Menu:**
- Toggle button appears on screens < 768px
- Animated dropdown with \`opacity\` and \`y\` transform (0.2s duration)
- Semi-transparent backdrop: \`bg-[#050506]/95\` with \`backdrop-blur-xl\`
- Vertical navigation links with hover states
- Full-width CTA button at bottom
- Menu icon transitions between hamburger (\`Menu\`) and close (\`X\`) icons

---

## Layout Principles

### Spacing Scale
Base unit: 4px. Use Tailwind's default scale consistently.

| Context | Spacing |
|:--------|:--------|
| Section padding | \`py-24\` to \`py-32\` |
| Container max-width | \`container\` with responsive padding |
| Card padding | \`p-6\` to \`p-8\` |
| Element gaps | \`gap-4\` to \`gap-8\` |
| Between sections | \`py-32\` (128px) |

### Grid Philosophy

**Asymmetric Bento Grids:**
Feature grids should NOT be uniform. Use varying spans:
- 6-column base grid on desktop
- Mix of \`col-span-2\`, \`col-span-3\`, \`col-span-4\`
- Variable row heights with \`auto-rows-[180px]\` as baseline
- One "hero" card spanning 4 columns and 2 rows

**Responsive Breakpoints:**
- Mobile (\`< 768px\`): Single column, stacked layout with reduced padding
- Tablet (\`md: 768px\`): 2-3 columns, intermediate grid layouts
- Desktop (\`lg: 1024px+\`): Full grid expression with asymmetric layouts

**Mobile-Specific Adjustments:**
- Section padding scales: \`py-16\` (mobile) → \`py-24\` (tablet) → \`py-32\` (desktop)
- Hero typography: \`text-4xl\` (mobile) → \`text-5xl\` (tablet) → \`text-7xl\`/\`text-8xl\` (desktop)
- Body text: \`text-base\` (mobile) → \`text-lg\` (tablet) → \`text-xl\` (desktop)
- Navigation: Hamburger menu with animated slide-down panel on mobile (\`Menu\`/\`X\` icons), inline links on desktop
- Cards: Full-width on mobile, grid on desktop
- Bento grids: Single column mobile, full asymmetric layout desktop

### Section Flow

- Sections separated by subtle \`border-t border-white/[0.06]\`
- Gradient line accents: \`bg-gradient-to-r from-transparent via-white/10 to-transparent\`
- Occasional overlapping sections using negative margins

---

## The "Bold Factor" (Signature Elements)

These elements MUST be present for authenticity:

1. **Animated Ambient Blobs:** Multiple layered, floating gradient shapes create cinematic lighting. Without these, the design becomes flat and generic.

2. **Mouse-Tracking Spotlights:** Interactive surfaces respond to cursor position with soft radial glow effects. This creates the "magical" interaction feel.

3. **Gradient Typography:** Headlines use vertical gradients (white to semi-transparent) and accent gradients with animation for key phrases.

4. **Multi-Layer Shadows:** Never single shadows. Always combine: border highlight + soft diffuse shadow + optional accent glow.

5. **Parallax/Scroll Effects:** Hero content fades and scales on scroll. Elements reveal with staggered animations. This adds cinematic depth.

6. **Precision Micro-Interactions:** All animations are quick (200-300ms), use expo-out easing, and movements are tiny (4-8px). Never bouncy or exaggerated.

---

## Anti-Patterns (What to Avoid)

1. **Flat backgrounds:** Never use a single solid color. Always layer gradients, noise, and ambient light.

2. **Pure black (\`#000000\`):** Use near-blacks like \`#050506\` or \`#020203\` for softer appearance.

3. **Pure white text:** Use \`#EDEDEF\` or similar off-white to reduce harshness.

4. **Large hover movements:** Keep transforms under 8px. This isn't playful—it's precise.

5. **Uniform grids:** Bento layouts should have variety in card sizes. Avoid same-size-everything.

6. **Harsh borders:** Borders should be nearly invisible (\`6-10%\` white opacity), not prominent.

7. **Colorful accent overuse:** The accent color is for highlights and interaction, not decoration. Most of the UI is monochromatic.

8. **Bouncy animations:** Use expo-out easing, not spring physics. Movements should be swift and decisive.

9. **Missing glow effects:** Accent buttons without glow look incomplete. The soft light emission is part of the language.

---

## Animation & Motion

**Timing:**
- Quick interactions: \`200ms\`
- Standard transitions: \`300ms\`
- Entrance animations: \`600ms\`
- Background blob float: \`8000-10000ms\`

**Easing:**
- Primary: \`[0.16, 1, 0.3, 1]\` (expo-out)
- Hover: \`ease-out\`

**Entrance Patterns:**
- Fade up: \`opacity: 0 → 1\`, \`y: 24px → 0\`
- Scale in: \`opacity: 0 → 1\`, \`scale: 0.95 → 1\`
- Stagger children: \`0.08s\` delay between items

**Scroll-Triggered:**
- Viewport threshold: \`15-20%\` visibility
- Once: true (don't re-animate on scroll back)

**Parallax (Hero):**
- Opacity: Fades from \`1 → 0\` over first 50% of scroll
- Scale: Shrinks from \`1 → 0.95\`
- Y position: Moves down \`0 → 100px\`

---

## Accessibility Considerations

**Contrast:**
- Primary text (\`#EDEDEF\` on \`#050506\`): ~15:1 ratio ✓
- Muted text (\`#8A8F98\` on \`#050506\`): ~6:1 ratio ✓
- Accent on dark: Ensure 4.5:1 minimum for interactive elements

**Focus States:**
- Always visible focus rings using accent color
- \`ring-offset\` matches background color

**Motion:**
- Respect \`prefers-reduced-motion\`
- Provide fallbacks for parallax and floating animations
- Essential interactions should work without animation

**Color Independence:**
- Don't rely solely on accent color for meaning
- Use icons, labels, and position to reinforce state`}
(total 33547 chars)

========== playful-geometric ==========
--- record 0 (len 105) ---
{id:"playful-geometric",name:"Playful Geometric",path:"/playful-geometric",mode:"light",accent:"#8B5CF6"}
(total 105 chars)
--- record 1 (len 32917) ---
{id:"playful-geometric",name:"Playful Geometric",mode:"light",fontType:"sans-serif",description:"A vibrant, high-energy aesthetic that combines a stable structural grid with whimsical geometric decorations. It relies on bright solid colors, simple primitive shapes (circles, triangles, squiggles), and tactile interactions to create a friendly, optimistic vibe reminiscent of modern Memphis design.",layoutIdeas:{hero:"Centralized or split layout where the main headline is framed by floating geometric primitives (3D-looking flat shapes). The CTA button sits on a 'blob' or irregular shape background. Background features a subtle dot pattern.",stats:"Row of colorful distinct shapes (circle, square, triangle, hexagon) acting as containers for the numbers. The containers vibrate or rotate slightly on hover.",productDetail:"Two-column layout. Image side has a 'collage' feel with offset colored rectangles behind the main product image. Text side uses substantial padding and colorful bullets.",features:"Bento-box style grid, but each cell has a different playful background color (very light tints) or border radius strategy (some fully round, some leaf-shaped). Icons are solid, colorful circles.",blog:"Masonry or grid where featured images are clipped into interesting shapes (arch, pill, circle). Titles use a chunky display font. Tags look like little stickers.",howItWorks:"Horizontal or vertical timeline connected by a literal dashed SVG line that loops and squiggles between steps. Step numbers are inside solid colored stars or bursts.",benefits:"Alternating layout. Each benefit text block is paired with a large, abstract geometric composition (e.g., a square balancing on a circle) representing the concept.",testimonials:"Cards styled like speech bubbles (with the little tail). They scattered slightly (random rotation +/- 2deg) to feel informal. Avatars pop out of the frame.",pricing:"Three distinct columns. The 'Recommended' tier pops out with a thick dashed border and a floating 'Best Value' badge that looks like a sticker. Prices are massive and colorful.",faq:"Accordion items separated by thick distinct borders. When opened, the background fills with a light pattern (dots or lines). The expand icon is a large playful arrow or plus sign.",finalCTA:"A contained box with a 'wavy' top edge or bottom edge. High contrast background (bright yellow or blue). Button shakes slightly to attract attention.",footer:"Background is a dark shape with a 'dripping' paint effect or wave at the top. Large footer links with fun hover underlines (squiggles)."},content:`# Playful Geometric Design System

## Design Philosophy

**Playful Geometric** is the antidote to sterile, corporate minimalism. It creates an emotional connection through **optimism, clarity, and tactile fun**.

The core concept is **"Stable Grid, Wild Decoration"**. The content itself (text, forms) lives in clean, readable areas, but the world around it is alive with movement and shape. It references the **Memphis Group** (80s) but cleans it up for modern digital screens—removing the chaos while keeping the energy.

### The Vibe
**Friendly. Tactile. Pop. Energetic.**
It feels like a playground or a well-organized sticker book. It invites clicking. It smiles at you.

### Visual Signatures
- **Primitive Shapes**: Circles, triangles, squares, pill shapes, and squiggles used as background elements, masks, or icons.
- **Hard Shadows**: Elements often have a hard, offset drop shadow (no blur) giving a sticker or cut-out paper feel.
- **Pattern Fills**: Polka dots, grid lines, and diagonal stripes used to fill shapes or backgrounds.
- **Varied Radii**: Mixing fully rounded corners with sharp ones to create "leaf" shapes or asymmetric blobs.

---

## Design Token System

### Colors (Light Mode)
A punchy, high-saturation palette anchored by strong neutrals.

\`\`\`
background:        #FFFDF5    // Warm Cream/Off-White (Paper feel)
foreground:        #1E293B    // Slate 800 (Softer than black)
muted:             #F1F5F9    // Slate 100
mutedForeground:   #64748B    // Slate 500
accent:            #8B5CF6    // Vivid Violet (Primary Brand)
accentForeground:  #FFFFFF    // White
secondary:         #F472B6    // Hot Pink (Playful pop)
tertiary:          #FBBF24    // Amber/Yellow (Optimism)
quaternary:        #34D399    // Emerald/Mint (Freshness)
border:            #E2E8F0    // Slate 200
input:             #FFFFFF    // White
card:              #FFFFFF    // White
ring:              #8B5CF6    // Violet Focus
\`\`\`

**Usage Rule**: Use \`accent\` for primary actions. Use \`secondary\`, \`tertiary\`, and \`quaternary\` rotationally for decorative shapes, icons, or emphasized words to create a "confetti" effect.

### Typography

**Headings**: \`"Outfit", system-ui, sans-serif\`
- A geometric sans with character. Rounded corners on letters make it friendly.
- **Weights**: Bold (700) or ExtraBold (800).

**Body**: \`"Plus Jakarta Sans", system-ui, sans-serif\`
- Highly legible, modern, geometric but humanist.
- **Weights**: Regular (400), Medium (500).

**Scale Ratio**: 1.25 (Major Third) - melodic and harmonious.

### Radius & Border

\`\`\`
radius-sm:   8px
radius-md:   16px
radius-lg:   24px
radius-full: 9999px
border-width: 2px     // Chunky borders by default
\`\`\`

**Special "Blob" Radius**: \`rounded-tl-2xl rounded-tr-2xl rounded-br-2xl rounded-bl-none\` (Speech bubble style) or \`rounded-t-full rounded-b-none\` (Arch).

### Shadows & Effects

**The "Pop" Shadow (Hard Shadow)**:
\`\`\`
box-shadow: 4px 4px 0px 0px #1E293B;  // Dark hard shadow
box-shadow-hover: 6px 6px 0px 0px #1E293B; // Lift effect
box-shadow-active: 2px 2px 0px 0px #1E293B; // Press effect
\`\`\`
No blur. Solid offset colors.

### Textures & Patterns
- **Dot Grid**: A background of small dots (\`bg-[url(...)]\`) in strict formation.
- **Squiggles**: SVG paths used as section dividers or underlining for headings.
- **Confetti**: Small SVG shapes (triangles, circles) absolutely positioned behind main content blocks.

---

## Component Stylings

### Buttons

**Primary Button ("The Candy Button")**:
\`\`\`
- Bg: accent (#8B5CF6)
- Text: white, font-weight: 700
- Radius: rounded-full (Pill)
- Border: 2px solid #1E293B (Dark border around color)
- Shadow: 4px 4px 0px #1E293B (Hard shadow)
- Hover: translate-x-[-2px] translate-y-[-2px], shadow extends to 6px 6px
- Active: translate-x-[2px] translate-y-[2px], shadow shrinks to 2px 2px
- Icon: ArrowRight, circular background (white) inside button
\`\`\`

**Secondary Button**:
\`\`\`
- Bg: transparent
- Text: foreground
- Border: 2px solid #1E293B
- Radius: rounded-full
- Shadow: none
- Hover: bg-tertiary (#FBBF24) - Fills with yellow on hover
\`\`\`

### Cards

**The "Sticker" Card**:
\`\`\`
- Bg: white
- Border: 2px solid #1E293B
- Radius: rounded-xl
- Shadow: 8px 8px 0px #E2E8F0 (Soft hard shadow) or #F472B6 (Pink shadow for featured)
- Hover: Rotate -1deg, Scale 1.02 (Wiggle effect)
- Title: Bold Outfit font
- Icon: Floating circle div with centered icon, sitting half-in/half-out of the top border.
\`\`\`

### Inputs

\`\`\`
- Bg: white
- Border: 2px solid #CBD5E1
- Radius: rounded-lg
- Text: foreground
- Shadow: 4px 4px 0px transparent (hidden initially)
- Focus: Border accent, Shadow 4px 4px 0px accent (Hard color shadow on focus)
- Label: Bold, uppercase, small tracking-wide.
\`\`\`

---

## Layout Strategy

### General
- **Container**: \`max-w-6xl\` (Generous width).
- **Spacing**: \`py-24\` (96px). Spacious but not empty; filled with patterns.
- **Grid**: 12-column logic, but grouped into big blocks (6/6 or 4/4/4).

### Unique Section Layouts
1.  **Hero**:
    - Text left, Image right.
    - **Decoration**: A massive yellow circle behind the text. A dotted pattern behind the image. The image itself has a "blob" mask (CSS clip-path or border-radius manipulation).
2.  **Features**:
    - Grid of 3.
    - **Decoration**: Each card is connected by a dashed SVG line drawn in the background.
    - Alternating colors for card headers (Violet, Pink, Yellow).
3.  **Pricing**:
    - The middle card is scaled up (1.1) and has a massive yellow star badge "MOST POPULAR" rotated 15deg.

---

## Effects & Animation

**Feel**: Bouncy, Elastic, Fun.

- **Hover**: \`transition-all duration-300 ease-[cubic-bezier(0.34,1.56,0.64,1)]\` (Overshoot/Bounciness).
- **Entrance**: Elements shouldn't just fade in; they should **pop** in (Scale 0->1 with bounce).
- **Marquee**: Use infinite scrolling text for client logos or keywords.
- **Wiggle**: Keyframe animation \`rotate: 0deg -> 3deg -> -3deg -> 0deg\` on hover for icons.

---

## Iconography

**Lucide React** settings:
- **Stroke Width**: \`2.5px\` (Bold/Chunky).
- **Style**: Round line caps, round line joins.
- **Color**: Often white inside a colored circle, or the dark foreground color.
- **Usage**: Enclosed in shapes. Never floating alone. A "Check" icon isn't just a check; it's a check inside a green circle.

---

## Responsive Strategy

- **Mobile**:
  - Stack everything.
  - Reduce "pop" shadows to 2px to save space.
  - Turn horizontal squiggle lines into vertical dividers.
  - Keep buttons big and tappable (min 48px height).
  - Hide complex background floating shapes that might overlap text.

---

## Accessibility & Best Practices

- **Contrast**: The text is slate-800 on off-white/white, which is AAA.
- **Color**: Never rely *only* on color. Use shapes and text labels.
- **Motion**: Respect \`prefers-reduced-motion\`. Disable the "bounce" and "wiggle" effects if preferred.
- **Focus**: The focus state is high-contrast (thick colored border + hard shadow).`},professional:{id:"professional",name:"Business Style",mode:"light",fontType:"serif",description:"An editorial-inspired minimalist design system centered on elegant serif typography. Warm ivory backgrounds with subtle paper texture, refined spacing, rule lines, and classical proportions create a timeless, literary aesthetic. Enhanced depth through layered gradients and multi-toned shadows. The design whispers sophistication through restraint and typographic excellence.",layoutIdeas:{hero:"Full-width centered layout with dramatic oversized serif headline (2.5rem mobile, 7xl desktop). Generous vertical breathing room (py-32 to py-44). Subtle decorative rule line below headline. Dual CTA buttons with refined hover states including subtle lift. Trust indicator in small caps with generous letter-spacing. Responsive text scaling maintains hierarchy on all devices.",stats:"Horizontal 4-column layout (2-column on mobile) with thin vertical rule dividers between stats. Dividers appear between columns on mobile and all stats on desktop. Large display serif numbers (4xl mobile, 5xl desktop). Labels in monospace small caps with wide tracking (0.15em). Clean card background with border lines top and bottom.",features:"3-column grid (stacks to 1 column mobile) with generous gaps (gap-8). Each card has 2px accent top border, rounded corners, and enhanced hover effect with background tint. Icon in muted circle background. Serif title with sans-serif description. Hover reveals subtle background shift and enhanced shadow.",howItWorks:"3-column layout with large circular step numbers in serif. Horizontal connecting line on desktop. Each step has generous padding and clean typography hierarchy. Background uses card color for contrast.",benefits:"Asymmetric two-column layout (1.3fr / 0.7fr ratio, stacks on mobile). Left column has title, subtitle, and bulleted list with elegant dash markers. Right column features enhanced abstract graphic with gradient backgrounds, layered circles, and hover-interactive elements. Refined typography hierarchy throughout.",pricing:"3-column grid (stacks vertically mobile) with center card elevated (-translate-y-4 on desktop). Thin rule borders with accent border on highlighted tier. Large serif price numbers. Feature lists with checkmarks colored by tier importance. Highlighted tier has warm accent background tint (accent-muted). Badge positioning uses absolute positioning.",testimonials:"3-column grid (stacks mobile) with large decorative opening quotation mark (100px, 20% opacity) in accent color. Italic serif quotes with generous line-height. Author info with circular avatar (48x48px) and refined typography. Subtle card borders and shadows.",faq:"Clean accordion with serif question titles (text-xl). Circular button with plus icon that rotates 45deg to form X when open. Thin border separators between items. Generous padding (py-6). Sans-serif answer text with relaxed leading (1.75). Smooth height and opacity animations.",blog:"3-column grid (stacks mobile) with images in 16:10 aspect ratio. Date in monospace small caps. Serif titles with hover color shift to accent. Images have subtle border and shadow enhancement on hover. 'Read more' link with arrow icon and translate animation.",footer:"5-column grid (2 columns for company, 1 each for nav groups, stacks to 2-col on mobile). Logo in serif. Social icons in circular borders with hover state showing accent color. Bottom copyright bar with thin top border and flex layout for alignment. Links have accent hover states."},content:`# Design Style: Serif

## Design Philosophy

### Core Principle

**Typographic elegance through classical restraint.** This design system draws inspiration from the finest editorial publications, literary magazines, and luxury brand identities. It believes that the highest form of design is one that elevates content through refined typography, considered spacing, and deliberate simplicity.

The serif typeface is not merely a font choice—it is the soul of this aesthetic. Every curve of the letterform, every carefully weighted stroke, speaks to centuries of typographic tradition. This design honors that heritage while executing with modern precision.

### The Visual Vibe

**Editorial. Timeless. Warm. Refined.**

Imagine opening a beautifully designed hardcover book or a premium architecture magazine. The pages breathe. The typography has room to speak. Nothing screams for attention because everything has been placed with intention. This is the feeling we create.

**Emotional Keywords:**
- *Timeless* — This design would feel appropriate today, a decade ago, or a decade from now. It transcends trends.
- *Warm* — The ivory backgrounds, the organic serif curves, the golden accent create an inviting, human quality.
- *Sophisticated* — Small caps, refined rules, generous margins all whisper quality and attention to detail.
- *Literary* — This feels like it belongs in the world of ideas, of considered communication, of meaningful content.
- *Confident* — True elegance comes from restraint, not embellishment. This design is secure enough to be quiet.

**What This Design Is NOT:**
- Not cold or stark (despite being minimal)
- Not trendy or ephemeral (the serif anchors it in timelessness)
- Not decorative or ornate (restraint is key)
- Not corporate or generic (the typography gives it soul)
- Not loud or aggressive (it draws you in rather than demanding attention)

### The DNA of This Style

#### 1. The Signature Serif

The **Playfair Display** typeface is the cornerstone. Its high contrast between thick and thin strokes, its elegant ball terminals, and its classical proportions immediately establish editorial gravitas. This font has presence—it commands attention without raising its voice.

**Where it appears:**
- All major headlines (h1, h2, h3)
- Large display numbers (pricing, stats)
- Pull quotes in testimonials
- Logo wordmark

**Why it works:** Serif typefaces carry associations with tradition, trustworthiness, and intellectual depth. Playfair Display specifically feels both classical and contemporary—it's not stuffy or old-fashioned but brings warmth and character.

#### 2. The Warm Palette

Color in this system is used with extreme restraint. The palette is essentially monochromatic with a single warm accent:

- **Ivory (#FAFAF8)** — A cream-tinted white that feels warmer than pure white
- **Rich Black (#1A1A1A)** — Deep but not harsh, for primary text
- **Warm Gray (#6B6B6B)** — For secondary text, with slight warmth
- **Burnished Gold (#B8860B)** — The single accent color, used sparingly for emphasis

The gold accent is inspired by gold leaf in illuminated manuscripts, the gilded edges of fine books, the brass details in luxury interiors. It adds just enough warmth and distinction without overwhelming the monochrome foundation.

#### 3. The Rule Line System

Thin horizontal rules (1px lines) are a defining element:
- Section dividers
- Card borders (top accent lines)
- Underline effects on key elements
- Table separators

These rules are inspired by editorial layouts where fine lines create structure and rhythm without visual weight. They're always in the border color (#E8E4DF), slightly warmer than pure gray.

#### 4. Small Caps & Tracking

**Small caps** are used extensively for:
- Section labels
- Meta information (dates, categories)
- Supporting text
- Navigation items

Combined with **generous letter-spacing (0.1em - 0.15em)**, small caps create a refined, sophisticated look that's distinctly editorial. This is not a cheap trick—it's a typography fundamental that separates thoughtful design from generic output.

#### 5. Generous Whitespace

This design breathes. Margins are large. Padding is substantial. Line heights are relaxed.

- Section padding: \`py-32\` to \`py-44\`
- Content max-width: \`max-w-5xl\` (narrower for reading comfort)
- Line height for body: \`1.75\` (very relaxed)
- Letter spacing for body: slight positive tracking for readability

The whitespace isn't empty—it's an active design element that gives the typography room to perform.

#### 6. Asymmetric Balance

While the overall aesthetic is classical, the layouts embrace asymmetric compositions:
- Hero: Centered but with offset decorative elements
- Benefits: Uneven column splits (1.3fr / 0.7fr)
- Cards: Thin top border creates visual weight at top

This prevents the design from feeling static or predictable while maintaining elegance.

### Differentiation: Minimalism With Soul

Many minimalist designs strip away so much that they become characterless—white backgrounds, gray text, system fonts. This design proves that minimalism and personality are not mutually exclusive.

**The serif typeface is the key differentiator.** It brings:
- Visual interest without decoration
- Warmth without color
- Character without complexity
- Timelessness without being dated

This is minimalism with a point of view. It has something to say.

### Sensory Description

If this design were a physical space, it would be:
- A private library with floor-to-ceiling bookshelves
- Natural light filtering through tall windows
- A worn leather chair and a mahogany writing desk
- The smell of aged paper and fresh coffee
- Silence that invites contemplation

If it were music, it would be:
- Solo piano, perhaps Satie or Debussy
- Lots of space between notes
- Warm, resonant tones
- Something you'd hear in a boutique hotel lobby
- Understated but unmistakably refined

---

## Design Token System (The DNA)

### Color Strategy

**Monochrome With Warmth:** An intentionally limited palette that gains sophistication through restraint. The single gold accent provides just enough distinction.

| Token | Value | Usage & Context |
|:------|:------|:----------------|
| \`background\` | \`#FAFAF8\` | Primary canvas. Warm ivory that feels more refined than pure white. |
| \`foreground\` | \`#1A1A1A\` | Primary text. Rich black, not pure black. |
| \`muted\` | \`#F5F3F0\` | Secondary surfaces, card backgrounds. Slightly warmer than background. |
| \`muted-foreground\` | \`#6B6B6B\` | Secondary text. Warm gray with softness. |
| \`accent\` | \`#B8860B\` | Burnished gold. Links, highlights, key interactive elements. |
| \`accent-secondary\` | \`#D4A84B\` | Lighter gold for gradients and hover states. |
| \`accent-foreground\` | \`#FFFFFF\` | Text on accent backgrounds. |
| \`border\` | \`#E8E4DF\` | Warm gray for rules, dividers, card borders. |
| \`card\` | \`#FFFFFF\` | Card surfaces. Pure white for maximum lift from ivory background. |
| \`ring\` | \`#B8860B\` | Focus rings. Matches accent gold. |

---

### Typography System

**Font Pairing (Editorial System):**
- **Display/Headlines:** \`"Playfair Display", Georgia, serif\` — Elegant high-contrast serif for all headings. The signature of this design.
- **Body/UI:** \`"Source Sans 3", system-ui, sans-serif\` — Clean, highly readable sans-serif that complements without competing.
- **Monospace:** \`"IBM Plex Mono", monospace\` — For labels and small caps treatments.

**Type Scale & Usage:**

| Element | Size | Font | Weight | Tracking | Notes |
|:--------|:-----|:-----|:-------|:---------|:------|
| Hero Headline | \`7xl\` → \`4.5rem\` | Playfair Display | Normal | \`-0.02em\` | Tight leading (1.1). Center-aligned. |
| Section Headlines | \`4xl\` → \`2.5rem\` | Playfair Display | Normal | \`-0.01em\` | Leading 1.2. |
| Card Titles | \`xl\` → \`1.25rem\` | Playfair Display | Semibold | Normal | Leading 1.3. |
| Body Text | \`base\` → \`lg\` | Source Sans 3 | Normal | \`0.01em\` | Relaxed line-height (1.75). |
| Section Labels | \`xs\` (12px) | IBM Plex Mono | Medium | \`0.15em\` | UPPERCASE small caps style. |
| Navigation | \`sm\` | Source Sans 3 | Medium | \`0.05em\` | Slightly tracked. |

**Small Caps Pattern:**
\`\`\`css
.small-caps {
  font-family: "IBM Plex Mono", monospace;
  font-size: 0.75rem;
  font-weight: 500;
  letter-spacing: 0.15em;
  text-transform: uppercase;
}
\`\`\`

---

### Spacing & Layout

**Core Principle:** Luxurious breathing room. This design is not afraid of empty space.

- **Section Spacing:** Large vertical padding (\`py-32\` to \`py-44\`) creates paced, contemplative scrolling.
- **Container Width:** \`max-w-5xl\` (64rem) for narrower, more readable content columns.
- **Component Density:** Generous internal padding (p-8 to p-10) on cards.
- **Grid Gaps:** \`gap-8\` to \`gap-12\` between grid items.

**Layout Patterns:**
- Hero: Centered, narrow container, stacked elements
- Features: 3-column grid with generous gaps
- Benefits: Asymmetric 2-column (\`grid-cols-[1.3fr_0.7fr]\`)
- Use thin rule lines to create visual structure

---

### Borders, Surfaces & Shadows

**Surfaces:**
- Cards use pure white (\`#FFFFFF\`) for lift from ivory background
- Very subtle shadows—this isn't about depth, it's about refinement
- Thin borders (1px) in warm gray

**Border System:**
| Token | Value | Usage |
|:------|:------|:------|
| \`border-thin\` | \`1px solid #E8E4DF\` | Primary borders, rules |
| \`border-accent\` | \`1px solid #B8860B\` | Accent borders, highlighted cards |

**Shadow System:**
| Token | Value | Usage |
|:------|:------|:------|
| \`shadow-sm\` | \`0 1px 2px rgba(26,26,26,0.04)\` | Subtle lift |
| \`shadow-md\` | \`0 4px 12px rgba(26,26,26,0.06)\` | Cards, hover states |
| \`shadow-lg\` | \`0 8px 24px rgba(26,26,26,0.08)\` | Elevated elements |

**Rule Lines (Critical for Style Identity):**
- Thin horizontal rules as section dividers
- Top border accent on cards (1px accent color)
- Decorative rule under headlines

---

## Component Styling & Interactions

### Buttons

**Primary Button:**
- Background: \`accent\` gold
- Text: White, medium weight, slightly tracked
- Border-radius: \`rounded-md\` (6px) — not too round, not too sharp
- Shadow: Very subtle, accent-tinted (\`shadow-sm\`)
- Hover: Color shifts to \`accent-secondary\`, shadow enhances to \`shadow-accent\`, subtle lift (-translate-y-0.5)
- Active: Returns to base position (translate-y-0)
- Touch: \`touch-manipulation\` class for better mobile interaction
- Minimum height: 44px on mobile (accessibility requirement)

**Secondary/Outline Button:**
- Background: Transparent
- Border: \`1px\` in \`foreground\` color (strong contrast)
- Text: \`foreground\`
- Hover: Fill with \`muted\` background, border and text shift to \`accent\` color
- Smooth color transitions on all properties

**Ghost Button:**
- No background or border
- Text: \`muted-foreground\` → \`foreground\` on hover
- Underline appears on hover with \`accent\` color decoration
- Underline offset: 4px for breathing room

**Animation:** Refined transitions (\`200ms\`). Subtle lift on primary buttons adds tactile feedback while maintaining elegance.

---

### Cards

**Standard Card:**
- Background: \`card\` (white)
- Border: \`1px\` in \`border\` color
- Border-radius: \`rounded-lg\` (8px)
- Shadow: \`shadow-sm\` — very subtle
- Top accent: Optional \`2px\` accent border on top edge (when \`accentTop\` prop used)

**Hover Effects (when \`hoverEffect\` prop used):**
- Shadow increases to \`shadow-md\`
- Border color shifts to \`border-hover\`
- Background subtle tint to \`muted/30\` (30% opacity)
- No translate/lift — maintains elegant restraint
- Smooth \`200ms\` transition on all properties

**Elevated Card:**
- Uses \`shadow-md\` by default (when \`elevated\` prop used)
- Provides more depth for important content like highlighted pricing tiers

**Featured Card:**
- Background tint of accent color at 6% (\`accent-muted\`)
- Accent top border at 2px thickness
- Often combined with elevated shadow for maximum prominence

---

### Inputs

- Height: \`h-12\` (44px minimum for accessibility)
- Border: \`1px\` in \`input\` color (matches \`border\`)
- Border-radius: \`rounded-md\` (6px)
- Background: Transparent
- Hover: Border shifts to \`border-hover\` color
- Focus:
  - \`ring-2 ring-accent ring-offset-2\`
  - Border shifts to \`accent\` color for clear visual feedback
  - Smooth \`150ms\` transition
- Placeholder: \`text-muted-foreground/60\` (60% opacity for subtle hierarchy)
- Typography: Sans-serif body font, base size
- Transitions: All properties animate smoothly with \`ease-out\` easing

---

### Section Labels

A consistent label pattern appears at the start of each section:
\`\`\`jsx
<div className="mb-6 flex items-center gap-4">
  <span className="h-px flex-1 bg-[var(--border)]" />
  <span className="font-mono text-xs font-medium uppercase tracking-[0.15em] text-[var(--accent)]">
    Section Name
  </span>
  <span className="h-px flex-1 bg-[var(--border)]" />
</div>
\`\`\`

---

## The "Bold Factor" (Signature Elements)

These elements prevent generic output and define this style:

1. **Dramatic Serif Headlines:** Oversized serif typography (7xl in hero) that commands attention through scale and beauty, not decoration.

2. **Rule Line System:** Thin horizontal rules throughout create rhythm and structure—a distinctly editorial element.

3. **Small Caps Labels:** All section labels and meta info use tracked uppercase monospace, creating refined visual rhythm.

4. **Burnished Gold Accent:** The single warm accent color adds just enough distinction to prevent sterility.

5. **Generous Whitespace:** Sections breathe with \`py-32\` to \`py-44\` padding. This is premium, not cramped.

6. **Large Display Numbers:** Stats and pricing use serif display numbers at dramatic sizes (5xl+).

7. **Decorative Quote Marks:** Testimonials feature large opening quote marks in accent gold.

8. **Asymmetric Layouts:** Strategic use of uneven columns prevents static feeling while maintaining elegance.

9. **Layered Depth in Abstracts:** Product detail and benefits sections feature enhanced abstract graphics with:
   - Gradient backgrounds (\`from-[color] via-[color] to-[color]\`)
   - Decorative ring/circle elements with low opacity
   - Multi-layered card elements with borders and shadows
   - Hover-interactive elements that respond to user interaction
   - Subtle accent color tints for visual interest

10. **Paper Texture Overlay:** Subtle noise texture overlay at 30% opacity across entire page creates tactile, print-like quality.

11. **Ambient Glow:** Large blurred circle with 2% opacity accent color creates warm atmospheric depth.

12. **Enhanced Micro-interactions:**
    - Button subtle lift on hover with return animation
    - Card background tinting on hover
    - Border color shifts throughout interface
    - Smooth 200ms transitions on all interactive elements

---

## Effects & Animation

**Motion Philosophy:** Restrained and refined. Nothing bounces, nothing overshoots. Every animation should feel inevitable, not surprising.

**Transition Defaults:**
- Standard: \`transition-all duration-200 ease-out\`
- Subtle: \`duration-150\`

**Interaction States:**
- Hover brightness change: 5-10%, no dramatic shifts
- Shadow enhancement on hover
- Underlines appearing/growing
- NO translate/lift effects — too trendy for this timeless aesthetic

**Entrance Animations (Optional, Subtle):**
\`\`\`js
const fadeIn = {
  hidden: { opacity: 0 },
  visible: { opacity: 1, transition: { duration: 0.6, ease: "easeOut" } }
};
\`\`\`

---

## Responsive Strategy

**Breakpoint Philosophy:** Mobile layouts maintain the editorial feel through typography and spacing, even when structure simplifies. All interactive elements meet accessibility requirements for touch targets.

### Mobile Adaptations (< 768px)

- **Hero:**
  - Single column with centered text
  - Headline size: \`text-[2.5rem]\` (40px) maintains presence
  - CTAs stack vertically with full width on small screens
  - Maintains generous vertical padding

- **Stats:**
  - 2-column grid on mobile (4-column on desktop)
  - Vertical dividers between columns only (not all items)
  - Numbers scale to \`text-4xl\` (still prominent)
  - Horizontal gap added (\`gap-x-6\`) to prevent crowding

- **Features/Testimonials/Blog:**
  - Stack to single column
  - Generous gaps maintained (\`gap-8\` minimum)
  - Card styling remains consistent
  - Hover effects work as tap effects on mobile

- **Pricing:**
  - Stack vertically
  - Highlighted tier loses elevation (no -translate-y-4) but keeps visual distinction through background tint
  - All cards equal width for consistency

- **Navigation:**
  - Logo scales down slightly (\`text-lg\` → \`text-xl\`)
  - Desktop nav hidden on mobile/tablet
  - Primary CTA always visible
  - Mobile menu would be hamburger pattern (if implemented)

### Touch Optimization

- **All buttons:** Minimum 44px height (\`min-h-[44px]\`) on mobile
- **FAQ accordions:** 44px minimum height with \`touch-manipulation\`
- **All interactive elements:** Use \`touch-manipulation\` CSS for better tap response
- **Links:** Adequate padding and spacing for fat-finger friendly tapping

**Key Adaptations:**
- Section padding reduces gracefully but maintains premium feel
- Typography scales down but hierarchy crystal clear
- Serif font impact preserved—soul of design intact on all devices
- Rule lines and gold accents remain consistent
- No horizontal overflow—tested with various content widths
- Touch targets meet WCAG AAA standards (minimum 44x44px)

---

## Accessibility & Best Practices

**Color Contrast:**
- All text meets WCAG AA standards minimum
- Rich black (#1A1A1A) on ivory (#FAFAF8) provides excellent readability
- Gold accent (#B8860B) passes contrast requirements on white backgrounds
- Muted foreground (#6B6B6B) maintains sufficient contrast for secondary text

**Focus States:**
- Visible focus rings on all interactive elements: \`ring-2 ring-accent ring-offset-2\`
- Focus states use accent gold color for consistency
- Offset creates clear visual separation from element
- Input borders shift to accent color on focus for additional feedback
- All focus states tested with keyboard navigation

**Touch & Interaction:**
- All buttons meet minimum 44x44px touch target (WCAG AAA)
- \`touch-manipulation\` CSS prevents double-tap zoom on mobile
- FAQ accordion buttons have adequate size and spacing
- All clickable areas have sufficient padding
- No touch targets overlap or create confusion

**Typography:**
- Body text uses relaxed line-height (1.75) for comfortable reading
- Slight positive tracking improves readability on screens
- Base font size: 16px (never smaller for body text)
- Heading hierarchy clearly defined with size and font variation
- Line length controlled with max-width (max-w-5xl) for optimal reading

**Motion:**
- All animations are subtle and respectful (200ms standard)
- No rapid movements or flashing
- Transforms limited to subtle shifts (translate-y-0.5)
- \`prefers-reduced-motion\` should be respected in production
- Easing curves use gentle \`ease-out\` for natural feel

**Semantic HTML:**
- Proper heading hierarchy (h1 → h2 → h3)
- Button elements for interactive actions (not divs)
- Semantic sections with appropriate ARIA when needed
- Images include meaningful alt text (width/height prevent CLS)
- Form inputs properly labeled

**Performance:**
- CSS variables reduce specificity and improve maintainability
- Transitions use transform and opacity (GPU-accelerated)
- Images specify dimensions to prevent layout shift
- Font loading optimized with proper font-display values`}
(total 32917 chars)

========== cyberpunk ==========
--- record 0 (len 80) ---
{id:"cyberpunk",name:"Cyberpunk",path:"/cyberpunk",mode:"dark",accent:"#00ff88"}
(total 80 chars)
--- record 1 (len 45329) ---
{id:"cyberpunk",name:"Cyberpunk",mode:"dark",fontType:"mono",description:"High contrast neon on black, glitch animations, terminal/monospace fonts, tech-oriented decorations. A dystopian digital aesthetic inspired by 80s sci-fi and hacker culture.",layoutIdeas:{hero:"Full-bleed dark canvas with massive glitched headline (text-5xl to text-8xl) featuring chromatic aberration and neon glow shadows. Asymmetric 60/40 split with terminal-style subheadline with typing cursor on left, holographic HUD display with animated panels on right. Grid background with radial gradient mask. Scanline overlay across entire page.",stats:"Horizontal 2x2 grid on mobile, 4-column on desktop. Each stat in bordered section with monospace labels, large display numbers, and upward trend indicators. Subtle background glow. Border separators between stats.",productDetails:"Centered holographic card with circuit grid background. Terminal-style label, large heading, and paragraphs prefixed with >> symbols. Authenticated session indicator at bottom with pulsing dot.",features:"Three-column grid (stacks on mobile) with chamfered corner cards. Icon in bordered square that transitions to accent background on hover. Card titles change color on hover. Radial gradient background accent. Section header with overline label and gradient accent bars.",blog:"Three-column grid of terminal-style cards with VHS scanline overlay on images. Stream ID badges on images. ISO date format, author name, and access link with arrow. Entire card lifts on hover with border glow.",howItWorks:"Vertical timeline with center line. Diamond-shaped step markers (rotated squares) with neon glow. Steps alternate left/right on desktop, stack left on mobile. Terminal-style step numbers (STEP_01, etc).",benefits:"Two-column split - left has list of benefits with checkboxes that fill on hover, right has full syntax-highlighted code editor mockup with terminal window chrome (traffic lights), line numbers, and blinking cursor.",testimonials:"2x2 grid of cards with terminal headers showing avatar (with tech pattern), author info, and VERIFIED badge. Quote with decorative quotation marks. Transmission complete footer with pulsing indicator.",pricing:"Three-column grid with center card scaled and highlighted with thicker accent border and neon glow. Cards show tier name, price in large monospace, feature list with checkmarks, and CTA button. Recommended badge on highlighted tier.",faq:"Vertical stack of chamfered accordion items. Questions prefixed with $ symbol. Collapsible answers with dashed border separator, prefixed with >. Animated expand/collapse with rotating arrow.",footer:"Four-column grid (stacks on mobile). Company info, navigation links with underline hover, social icons, copyright. Links styled as terminal commands. Monospace font throughout."},content:`# Cyberpunk / Glitch Design System

## 1. Design Philosophy

**Core Principles**: "High-Tech, Low-Life." The aesthetic is a digital dystopia colliding with a high-tech noir reality. It captures the tension between advanced technology and societal decay—a world of underground hackers, neon-drenched megacities, and corrupted data streams. This isn't a clean, utopian future; it's gritty, imperfect, and palpably dangerous. Every pixel should feel like it's being rendered on a malfunctioning CRT monitor in a rain-soaked Tokyo alley or a rogue terminal in a subterranean bunker.

**The Vibe**: Dangerous, electric, rebellious, and aggressively futuristic-retro. It draws heavily from the visual language of 80s sci-fi (Blade Runner, Akira) and hacker culture (The Matrix, Ghost in the Shell). The interface should feel *alive* and volatile—buzzing with digital energy, glitching with data corruption, and pulsing with raw power. It’s not just a website; it’s a hacked feed, a forbidden interface, a window into the sprawl.

**The Tactile Experience**:
- **Imperfect Technology**: Embrace the artifacts of analog-to-digital conversion. Scanlines, chromatic aberration (RGB splitting), and signal noise are not bugs; they are features. The UI should feel like it's struggling to contain the data it displays.
- **The Void vs. The Light**: The background isn't just dark; it's a void. Against this absolute blackness, neon light (cyan, magenta, acid green) doesn't just color elements—it *illuminates* them. Light sources should feel physical, casting glows and shadows that define the hierarchy.
- **Industrial Brutalism**: Shapes are hard, angular, and utilitarian. Chamfered corners (45-degree cuts) replace friendly rounded rectangles. Borders are technical and precise, resembling blueprints or HUD (Heads-Up Display) schematics rather than decorative frames.

**Visual Signatures That Make This Unforgettable**:
- **Chromatic Aberration**: RGB color splitting on text and elements (red/cyan offset shadows) to simulate lens distortion or signal interference.
- **Scanlines**: Subtle horizontal line overlays mimicking the refresh rate of old CRT monitors, adding texture and unifying the composition.
- **Glitch Effects**: Intentional "corruption" via clip-path animations, skewed transforms, and flickering text that suggests a unstable connection or a hacked system.
- **Neon Glow**: Text and borders that literally glow with intense, multi-layered box-shadow/text-shadow stacking, creating a "light saber" or "neon sign" effect against the dark background.
- **Corner Cuts**: Chamfered/clipped corners on cards and buttons creating a militaristic, tech-panel aesthetic.
- **Circuit Patterns**: Decorative SVG backgrounds resembling PCB traces or data highways, suggesting the underlying hardware.

---

## 2. Design Token System (The DNA)

### Colors (Dark Mode - Mandatory)

\`\`\`
background:          #0a0a0f      // Deep void black with slight blue undertone
foreground:          #e0e0e0      // Primary text, not pure white (less harsh)
card:                #12121a      // Card background, deep purple-black
muted:               #1c1c2e      // UI chrome/elevated backgrounds
mutedForeground:     #6b7280      // Secondary text, reduced contrast
accent:              #00ff88      // PRIMARY NEON - Electric green (Matrix-inspired)
accentSecondary:     #ff00ff      // SECONDARY NEON - Hot magenta/pink
accentTertiary:      #00d4ff      // TERTIARY NEON - Cyan/electric blue
border:              #2a2a3a      // Subtle borders
input:               #12121a      // Deep input background
ring:                #00ff88      // Focus ring matches accent
destructive:         #ff3366      // Error/danger red-pink
\`\`\`

### Typography

**Font Stack**:
- **Headings**: \`"Orbitron", "Share Tech Mono", monospace\` — Geometric, futuristic, robotic
- **Body**: \`"JetBrains Mono", "Fira Code", "Consolas", monospace\` — Clean monospace for that terminal feel
- **Accent/Labels**: \`"Share Tech Mono", monospace\` — For UI labels, timestamps, badges

**Scale & Styling**:
- H1: \`text-6xl\` to \`text-8xl\`, \`font-black\`, \`uppercase\`, \`tracking-widest\`
- H2: \`text-4xl\` to \`text-5xl\`, \`font-bold\`, \`uppercase\`, \`tracking-wide\`
- H3: \`text-xl\` to \`text-2xl\`, \`font-semibold\`, \`uppercase\`
- Body: \`text-base\`, \`font-normal\`, \`tracking-wide\`, \`leading-relaxed\`
- Code/Labels: \`text-sm\`, \`font-mono\`, \`uppercase\`, \`tracking-[0.2em]\`

### Radius & Border

\`\`\`
radius.none:     0px        // Sharp cuts are the default
radius.sm:       2px        // Minimal softening
radius.base:     4px        // Rare, only for inputs
radius.chamfer:  Use clip-path for corner cuts instead of border-radius
\`\`\`

**Border Width**: \`1px\` default, \`2px\` for emphasis, borders often use gradient or glow effects

**Chamfered Corner Pattern** (apply via clip-path):
\`\`\`css
clip-path: polygon(
  0 10px, 10px 0,           /* top-left cut */
  calc(100% - 10px) 0, 100% 10px,  /* top-right cut */
  100% calc(100% - 10px), calc(100% - 10px) 100%,  /* bottom-right cut */
  10px 100%, 0 calc(100% - 10px)   /* bottom-left cut */
);
\`\`\`

### Shadows & Effects

**Neon Glow (CSS Variable Tokens)**:
\`\`\`css
/* Main neon glow - used on hover states, focus rings, highlighted elements */
--box-shadow-neon: 0 0 5px #00ff88, 0 0 10px #00ff8840;

/* Small neon glow - subtle accents */
--box-shadow-neon-sm: 0 0 3px #00ff88, 0 0 6px #00ff8830;

/* Large neon glow - emphasized states, hero elements */
--box-shadow-neon-lg: 0 0 10px #00ff88, 0 0 20px #00ff8860, 0 0 40px #00ff8830;

/* Secondary neon (magenta) */
--box-shadow-neon-secondary: 0 0 5px #ff00ff, 0 0 20px #ff00ff60;

/* Tertiary neon (cyan) */
--box-shadow-neon-tertiary: 0 0 5px #00d4ff, 0 0 20px #00d4ff60;
\`\`\`

**Text Shadows for Depth**:
\`\`\`css
/* Glitch effect text shadow (used on hero headline) */
drop-shadow: 0 0 10px rgba(0, 255, 136, 0.5);

/* Gradient text glow */
drop-shadow: 0 0 20px rgba(0, 255, 136, 0.3);
\`\`\`

**Chromatic Aberration (via CSS animation on .cyber-glitch)**:
Implemented via ::before and ::after pseudo-elements with:
- text-shadow: -1px 0 #ff00ff (magenta left)
- text-shadow: -1px 0 #00d4ff (cyan right)
- clip-path animations for glitch effect

### Textures & Patterns (CRITICAL FOR DEPTH)

1. **Scanlines Overlay** (CSS pseudo-element):
\`\`\`css
background: repeating-linear-gradient(
  0deg,
  transparent,
  transparent 2px,
  rgba(0, 0, 0, 0.3) 2px,
  rgba(0, 0, 0, 0.3) 4px
);
pointer-events: none;
\`\`\`

2. **Grid/Circuit Pattern** (subtle background):
\`\`\`css
background-image:
  linear-gradient(rgba(0, 255, 136, 0.03) 1px, transparent 1px),
  linear-gradient(90deg, rgba(0, 255, 136, 0.03) 1px, transparent 1px);
background-size: 50px 50px;
\`\`\`

3. **Noise Texture**: Apply subtle CSS noise filter or SVG noise overlay at 5-10% opacity

4. **Gradient Mesh**: Radial gradients of accent colors at very low opacity in corners

---

## 3. Component Stylings

### Buttons

All buttons use:
- Font: monospace
- Text transform: uppercase
- Letter spacing: wider
- Transition: all for smooth effects
- Focus ring: 2px accent color

**Default Variant**:
\`\`\`
- Background: transparent
- Border: 2px solid accent (#00ff88)
- Text: accent color
- Clip-path: .cyber-chamfer-sm (smaller chamfer)
- Hover: background fills with accent, text becomes background color, neon glow shadow
\`\`\`

**Secondary Variant**:
\`\`\`
- Border: 2px solid accentSecondary (#ff00ff)
- Text: accentSecondary
- Hover: fills with magenta, neon-secondary glow
\`\`\`

**Outline Variant**:
\`\`\`
- Border: 1px solid border (#2a2a3a)
- Background: transparent
- Hover: border becomes accent, text becomes accent, neon glow appears
\`\`\`

**Ghost Variant**:
\`\`\`
- No border
- Hover: background accent/10 opacity, text becomes accent
\`\`\`

**Glitch Variant** (CTAs):
\`\`\`
- Background: solid accent (#00ff88)
- Text: background color (high contrast)
- Uses .cyber-glitch class for chromatic aberration effect
- Hover: brightness increases (filter: brightness(1.1))
\`\`\`

### Cards/Containers

**Default Card Variant**:
\`\`\`
- Background: card (#12121a)
- Border: 1px solid border (#2a2a3a)
- Clip-path: chamfered corners via .cyber-chamfer class
- Transition: all 300ms for smooth interactions
- Hover: translateY(-1px), border becomes accent, neon glow appears (if hoverEffect prop)
\`\`\`

**Terminal Variant** (variant="terminal"):
\`\`\`
- Background: background (#0a0a0f) instead of card
- Border: 1px solid border
- Automatic decorative header bar with traffic light dots (red/yellow/green)
- Content padding-top to accommodate header
- Clip-path: chamfered corners
- Used for: Blog cards, FAQ items, some pricing tiers
\`\`\`

**Holographic Variant** (variant="holographic"):
\`\`\`
- Background: muted (#1c1c2e) at 30% opacity
- Border: 1px solid accent at 30% opacity
- Box-shadow: neon glow
- Backdrop-filter: blur for glassmorphic effect
- Corner accents: 4 small border corners at card edges using absolute positioning
- Used for: Product details card, hero HUD panels
\`\`\`

### Inputs

\`\`\`
- Wrapper: relative positioning for prefix icon
- Prefix: ">" symbol in accent color, absolute positioned left
- Background: input (#12121a)
- Border: 1px solid border (#2a2a3a)
- Clip-path: .cyber-chamfer-sm
- Text: monospace, accent color
- Padding-left: 8 (to accommodate prefix)
- Placeholder: mutedForeground, styled as terminal prompt
- Focus: border becomes accent, neon glow shadow, outline removed
- Transition: all 200ms
\`\`\`

---

## 4. Layout Strategy

**Max-Width**: \`max-w-7xl\` for main content, full-bleed sections with contained inner content

**Grid Patterns**:
- Features: \`grid-cols-1 md:grid-cols-2 lg:grid-cols-3\` with \`-skew-y-1\` on container
- Pricing: \`grid-cols-1 md:grid-cols-3\` with middle card scaled up
- Stats: Horizontal flex with \`divide-x divide-border\`

**Spacing**: 8px base grid. Generous padding (\`py-24\` to \`py-32\` for sections). Dense internal component spacing.

**Asymmetry Requirements**:
- Hero: 60/40 split minimum
- At least one section with overlapping elements (negative margins)
- Use \`rotate-1\` or \`skew-y-1\` transforms on section containers
- Stagger card heights in grid where content allows

---

## 5. Non-Genericness (THE BOLD FACTOR)

**MANDATORY BOLD CHOICES**:

1. **Glitched Headlines**: Hero h1 MUST have chromatic aberration text-shadow AND a CSS animation that occasionally "glitches" (random skew/translate flicker)

2. **Scanline Overlay**: The entire page has a subtle scanline overlay (via ::after on body or main)

3. **Terminal Aesthetic**: At least one section must feel like a terminal (monospace, > prefixes, blinking cursor animations)

4. **Neon Borders That Actually Glow**: Not just colored borders - stacked box-shadows creating real glow effect

5. **Corner Cuts**: Cards use clip-path for chamfered/cut corners, not rounded corners

6. **Animated Elements**:
   - Blinking cursors (animation: blink 1s step-end infinite)
   - Subtle hover glitch effects
   - Gradient border animations (hue rotation)

7. **Circuit/Grid Background**: Visible tech-pattern in at least one section background

8. **Typing/Typewriter Effect**: Consider on subtitle or at least style as if mid-type (trailing cursor)

---

## 6. Effects & Animation

**Motion Feel**: Sharp, digital, slightly mechanical. Quick snaps rather than smooth eases.

**Transitions**:
\`\`\`css
transition: all 150ms cubic-bezier(0.4, 0, 0.2, 1);
/* Or for more digital feel: */
transition: all 100ms steps(4);
\`\`\`

**Keyframe Animations**:

\`\`\`css
/* Blink cursor */
@keyframes blink {
  50% { opacity: 0; }
}

/* Glitch effect */
@keyframes glitch {
  0%, 100% { transform: translate(0); }
  20% { transform: translate(-2px, 2px); }
  40% { transform: translate(2px, -2px); }
  60% { transform: translate(-1px, -1px); }
  80% { transform: translate(1px, 1px); }
}

/* Scanline scroll */
@keyframes scanline {
  0% { transform: translateY(-100%); }
  100% { transform: translateY(100vh); }
}

/* RGB shift/chromatic pulse */
@keyframes rgbShift {
  0%, 100% { text-shadow: -2px 0 #ff00ff, 2px 0 #00d4ff; }
  50% { text-shadow: 2px 0 #ff00ff, -2px 0 #00d4ff; }
}
\`\`\`

---

## 7. Iconography

**Lucide Icons Configuration**:
- Stroke width: \`1.5px\` (thin, technical feel)
- Size: Generally \`h-5 w-5\` or \`h-6 w-6\`
- Color: Inherit from text (usually accent or foreground)
- Style: Add subtle glow on hover via filter: \`drop-shadow(0 0 4px currentColor)\`

**Icon Containers**: Place icons inside bordered squares/hexagons with glow effect

---

## 8. Responsive Strategy

**Mobile Adaptations** (Mobile-first approach):

**Typography Scaling**:
- Hero h1: text-5xl (mobile) → text-7xl (md) → text-8xl (lg)
- Subheadline: text-base → text-lg → text-xl
- Section headings: text-4xl → text-5xl
- Maintain uppercase and tracking at all sizes

**Layout Changes**:
- Navigation: Hide nav links on < lg, show abbreviated CTA text on < sm
- Stats: 2x2 grid with borders only on top 2 items (mobile) → 4-column with vertical borders (desktop)
- All feature/blog/testimonial grids: Single column → 2-column (md) → 3-column (lg)
- Pricing: Stack vertically → 3-column grid, highlighted card scale only on md+
- Hero HUD: Hidden on mobile (lg:block)
- Footer: Stack to single column → 4-column grid

**Maintained Elements**:
- Scanline overlay (full page)
- Chamfered corners on all cards
- Neon glow effects (may reduce intensity on mobile for performance)
- Grid/circuit backgrounds
- Monospace typography
- Terminal aesthetic (>, $, prefixes)
- Dark color scheme

**Touch Targets**:
- Minimum 44px height for all interactive elements
- Adequate spacing between tappable items
- FAQ accordions with full-width click area

---

## 9. Accessibility

**Contrast**: All text meets WCAG AA (accent green on dark bg = 7.5:1 ratio - excellent)

**Focus States**:
\`\`\`css
focus-visible:outline-none
focus-visible:ring-2
focus-visible:ring-accent
focus-visible:ring-offset-2
focus-visible:ring-offset-background
\`\`\`
Plus add glow effect matching the neon aesthetic.

**Reduced Motion**: Respect \`prefers-reduced-motion\` - disable glitch animations, keep static chromatic aberration

---

## 10. Implementation Notes

- Use Tailwind arbitrary values \`[...]\` extensively for custom shadows and clip-paths
- CSS variables for colors enable easy theming
- Scanlines implemented via CSS, not images
- Glitch animations should be subtle and infrequent (not distracting)
- Test glow effects on different screens (can look washed out on low contrast displays)
- Consider GPU performance with multiple box-shadows - use \`will-change: transform\` sparingly`},enterprise:{id:"enterprise",name:"Corporate Trust",mode:"light",fontType:"sans-serif",description:"Modern SaaS aesthetic balancing professionalism with approachability. Vibrant indigo/violet gradients, soft colored shadows, isometric depth, and clean geometric sans-serif typography.",layoutIdeas:{hero:"Split layout with 60/40 composition. Left: Gradient headline split, dual-CTA buttons, trust indicator. Right: Isometric floating card with subtle 3D transforms and decorative elements.",stats:"Clean horizontal strip with large bold numbers, subtle text. Bordered top/bottom to create visual break.",productDetail:"Two-column layout with text-left, visual-right. Abstract UI mockup inside gradient container with offset shadow element.",features:"Zig-zag alternating layout. Icon badges with soft backgrounds, feature cards with isometric perspective transforms, decorative gradient blobs.",blog:"Three-column card grid. Image-first design with gradient overlays on hover, metadata above headline.",howItWorks:"Horizontal step timeline with connecting gradient line. Numbered badges with glow effects on dark background.",benefits:"Two-column split: checklist items on left, isometric 3D card visualization on right with gradient background.",pricing:"Three-column grid with center card elevated and highlighted. Relative positioning badge for 'Most Popular'.",testimonials:"Three-column card grid with star ratings, quotes, and user avatars with ring styling.",faq:"Accordion with details/summary HTML. Chevron rotation on expand, subtle background wash on open state.",footer:"Four-column grid on desktop, stacked on mobile. Dark slate background with lighter link hover states."},content:`# Design Style: Corporate Trust

## 1. Design Philosophy
This style embodies the **modern enterprise SaaS aesthetic** — professional yet approachable, sophisticated yet friendly. It draws inspiration from tech unicorns and high-growth startups that have successfully humanized the corporate experience. The design rejects the cold, sterile formality of traditional corporate websites in favor of a warm, confident, and inviting presence.

**Core Principles:**
- **Trustworthy Yet Vibrant**: Establishes credibility through clean structure and professional typography while maintaining visual energy through vibrant gradients and colorful accents
- **Dimensional Depth**: Uses isometric perspectives, soft colored shadows, and subtle 3D transforms to create visual interest and break free from flat design
- **Refined Elegance**: Every element is polished with attention to micro-interactions, smooth transitions, and sophisticated hover states
- **Purposeful Gradients**: Indigo-to-violet gradients serve as the visual signature, used strategically in headlines, buttons, and decorative elements
- **Professional Polish**: Generous white space, consistent spacing rhythms, and crisp typography create a premium, enterprise-ready feel

**Keywords**: Trustworthy, Vibrant, Polished, Dimensional, Modern, Approachable, Enterprise-Ready, Elegant

**Visual DNA**: The unmistakable signature of this style comes from:
1. **Colored Shadows**: Soft shadows with blue/purple tints instead of neutral grays
2. **Isometric Elements**: Subtle 3D transforms (rotate-x, rotate-y) on decorative cards and visualizations
3. **Gradient Text**: Strategic use of gradient text for emphasis in headlines
4. **Soft Blobs**: Large, blurred gradient orbs in the background for atmospheric depth
5. **Elevated Cards**: White cards that lift on hover with enhanced shadows
6. **Dual-Tone Palette**: Indigo (primary) + Violet (secondary) creating a cohesive gradient spectrum

## 2. Design Token System

### Colors (Light Mode)
*   **Background**: \`#F8FAFC\` (Slate 50) - A very subtle cool grey/white base.
*   **Foreground (Surface)**: \`#FFFFFF\` (White) - For cards and raised elements.
*   **Primary**: \`#4F46E5\` (Indigo 600) - The core brand color. Vibrant blue-purple.
*   **Secondary**: \`#7C3AED\` (Violet 600) - For gradients and accents.
*   **Text Main**: \`#0F172A\` (Slate 900) - High contrast, sharp.
*   **Text Muted**: \`#64748B\` (Slate 500) - For supporting text.
*   **Accent/Success**: \`#10B981\` (Emerald 500) - For positive indicators.
*   **Border**: \`#E2E8F0\` (Slate 200) - Subtle separation.

### Typography
*   **Font Family**: \`Plus Jakarta Sans\` — A geometric sans-serif with friendly rounded terminals that perfectly balances professional authority with modern approachability. Its clean letterforms ensure excellent readability while maintaining visual warmth.
*   **Scaling**: Major Third (1.250) scale provides substantial hierarchy without overwhelming the layout
*   **Font Weights**:
    *   **Display/Headings**: ExtraBold (800) for hero headlines, Bold (700) for section headings
    *   **Subheadings**: SemiBold (600) for card titles and emphasis
    *   **Body Text**: Regular (400) for paragraphs, Medium (500) for navigation and labels
*   **Line Heights**:
    *   Headlines: 1.1 (tight tracking for impact)
    *   Body Text: 1.6-1.7 (relaxed for readability)
*   **Letter Spacing**: Tight tracking (-0.02em) on large headlines for modern polish
*   **Responsive Type Scale**:
    *   Mobile: text-2xl to text-4xl for h1
    *   Desktop: text-4xl to text-6xl for h1
    *   Progressive scaling ensures legibility across all devices

### Radius & Border
*   **Radius**: \`rounded-xl\` (12px) for cards and \`rounded-lg\` (8px) for inputs. Buttons are \`rounded-full\` or \`rounded-lg\`.
*   **Borders**: Thin, 1px borders using the \`Border\` token.

### Shadows & Effects
This is where the design truly shines. **Colored shadows** replace neutral grays to reinforce the brand palette:

*   **Default Card Shadow**: \`0 4px 20px -2px rgba(79, 70, 229, 0.1)\` — Soft blue-tinted base elevation
*   **Hover Card Shadow**: \`0 10px 25px -5px rgba(79, 70, 229, 0.15), 0 8px 10px -6px rgba(79, 70, 229, 0.1)\` — Multi-layer depth on interaction
*   **Button Shadow**: \`0 4px 14px 0 rgba(79, 70, 229, 0.3)\` — Strong presence for primary CTAs
*   **Glow Effects**: Numbered badges use \`shadow-[0_0_20px_rgba(79,70,229,0.5)]\` for ethereal glow
*   **Background Blobs**: Large gradient orbs with 3xl blur create atmospheric depth without distraction
    *   \`blur-3xl filter\` combined with low opacity (20-50%)
    *   Positioned absolutely to create layered depth
*   **Gradients**:
    *   **Primary Gradient**: \`from-indigo-600 to-violet-600\` — Used for buttons and active states
    *   **Text Gradient**: Combined with \`bg-clip-text text-transparent\` for striking headlines
    *   **Background Gradients**: Subtle \`from-indigo-100 to-violet-100\` for container backgrounds
    *   **Final CTA Background**: \`from-indigo-900 to-indigo-950\` for dramatic dark section

## 3. Component Stylings

### Buttons
*   **Primary**: Gradient background (Indigo to Violet). \`rounded-full\` or \`rounded-lg\`. White text. Slight shadow. Transition: Lift (\`-translate-y-0.5\`) and increase shadow on hover.
*   **Secondary**: White background, Border \`E2E8F0\`, Text \`Slate 700\`. Hover: \`bg-slate-50\` and darker border.

### Cards
*   **Base**: White background, \`rounded-xl\`, \`border border-slate-100\`, \`shadow-soft\`.
*   **Behavior**: On hover, slight lift and increased shadow intensity.
*   **Feature Cards**: May feature an icon in a soft-colored circle (bg-indigo-50 text-indigo-600).

### Inputs
*   **Style**: \`bg-white\`, \`border-slate-200\`, \`rounded-lg\`.
*   **Focus**: \`ring-2 ring-indigo-500 ring-offset-1\` and \`border-indigo-500\`.
*   **Label**: \`text-sm font-semibold text-slate-700\`.

## 4. Non-Generic Bold Choices

The Corporate Trust aesthetic stands out through deliberate, sophisticated design decisions:

### Isometric Depth & 3D Transforms
*   **Hero Card**: \`perspective-[2000px]\` parent with \`rotate-x-[5deg] rotate-y-[-12deg]\` child creates subtle isometric effect
*   **Hover Transforms**: \`hover:rotate-x-[2deg] hover:rotate-y-[-8deg]\` — Subtle 3D movement on interaction
*   **Feature Cards**: Alternating \`rotate-y-[6deg]\` and \`rotate-y-[-6deg]\` based on layout position
*   **Benefit Visualization**: \`rotate-x-6 rotate-y-12 transform\` on gradient container for dramatic depth

### Strategic Gradient Usage
*   **Split Headlines**: First 3 words in standard color, remaining words in gradient for visual hierarchy
*   **Gradient Buttons**: Full background gradient with hover lift (\`-translate-y-0.5\`)
*   **Badge Elements**: NEW badge with solid indigo background inside gradient-ringed container
*   **Final CTA**: White button on dark gradient background creates dramatic contrast

### Atmospheric Background Elements
*   **Blur Orbs**: Large (400-600px) circular gradients with heavy blur positioned absolutely
*   **Layered Positioning**: Multiple blobs at different z-indexes create depth
*   **Subtle Animation**: \`animate-pulse duration-[4000ms]\` on floating cards for gentle movement

### Elevated Card System
*   **Default State**: Soft colored shadow with subtle border
*   **Hover State**: Lift effect (\`-translate-y-1\`) combined with enhanced shadow
*   **Transition**: Smooth \`duration-200\` for professional polish
*   **Pricing Highlight**: Center card uses \`md:scale-105\` with special ring styling

### Micro-Interactions
*   **Arrow Icons**: \`transition-transform group-hover:translate-x-1\` for directional feedback
*   **Image Zoom**: \`group-hover:scale-105\` on blog images with overlay fade-in
*   **Chevron Rotation**: \`group-open:rotate-180\` for FAQ accordions
*   **Button Lift**: Subtle upward movement on hover reinforces clickability

## 5. Spacing & Layout
*   **Container**: \`max-w-7xl\` (1280px) provides spacious, enterprise-appropriate width
*   **Padding**: Responsive padding with \`px-4 sm:px-6\` pattern for consistent gutters
*   **Vertical Rhythm**:
    *   Mobile: \`py-16\` (64px)
    *   Tablet: \`sm:py-20\` (80px)
    *   Desktop: \`lg:py-24\` (96px)
*   **Section Spacing**: Generous white space between sections creates breathing room
*   **Grid Strategy**:
    *   Hero: Two-column \`lg:grid-cols-2\` with text-first approach
    *   Features: Alternating zig-zag with \`lg:flex-row\` and \`lg:flex-row-reverse\`
    *   Pricing: Three-column \`md:grid-cols-3\` with center emphasis
    *   Stats: Four-column \`md:grid-cols-4\` for metric display
*   **Responsive Breakpoints**:
    *   Mobile-first approach with progressive enhancement
    *   sm: 640px, md: 768px, lg: 1024px, xl: 1280px
*   **Text Width Constraints**: \`max-w-xl\` or \`max-w-2xl\` on paragraphs to maintain 60-75 character line lengths

## 6. Animation & Transitions
*   **Philosophy**: "Refined Motion" — Smooth, professional, never jarring
*   **Base Transition**: \`transition-all duration-200\` for general interactive elements
*   **Long Transitions**: \`duration-500\` for image zooms and complex animations
*   **Hover Effects**:
    *   Cards: Combine \`hover:-translate-y-1\` with shadow enhancement
    *   Buttons: \`hover:-translate-y-0.5\` for subtle lift
    *   Icons: \`transition-transform group-hover:translate-x-1\` for directional cues
*   **Easing**: Default \`ease-out\` for natural deceleration
*   **Pulse Animation**: \`animate-pulse duration-[4000ms]\` on decorative floating elements for gentle breathing effect
*   **State Changes**: Smooth color transitions on links and buttons reinforce interactivity

## 7. Iconography
*   **Library**: \`lucide-react\` for consistent, modern icon system
*   **Style**:
    *   Default stroke width: \`2px\` (standard)
    *   Size: \`h-4 w-4\` for inline icons, \`h-5 w-5\` or \`h-6 w-6\` for featured icons
    *   Joins: Rounded for friendliness
*   **Color Treatment**:
    *   **Badge Icons**: Icon in \`text-indigo-600\` on \`bg-indigo-100\` container
    *   **Navigation Icons**: Inherit text color, transition on hover
    *   **Social Icons**: \`text-slate-400 hover:text-indigo-400\`
*   **Icon Containers**:
    *   Small badges: \`h-12 w-12 rounded-xl\` with soft background
    *   Large features: \`h-14 w-14 rounded-xl\` for prominent sections
    *   Circular: \`rounded-full\` for avatars or status indicators
*   **Accessibility**: Icons are decorative with proper text alternatives or hidden from screen readers when paired with text

## 8. Responsive Strategy
*   **Mobile-First Philosophy**: Design begins at 375px width, progressively enhances
*   **Touch Targets**: Minimum 44x44px for all interactive elements (buttons, links)
*   **Typography Scaling**:
    *   Headlines reduce from \`text-6xl\` (desktop) to \`text-4xl\` (mobile)
    *   Body text maintains readability at \`text-base\` with responsive line heights
*   **Layout Adaptations**:
    *   Two-column layouts stack to single column on mobile
    *   Navigation collapses to essential items (login hidden on mobile)
    *   Pricing cards stack vertically with equal width
    *   Footer columns stack progressively (4 col → 2 col → 1 col)
*   **Spacing Compression**: Padding and margins reduce proportionally on smaller screens
*   **Image Optimization**: Aspect ratios maintained, sizes adapt to container width
*   **Horizontal Scrolling**: Never required; all content fits viewport width
*   **Visual Hierarchy Preserved**: Even on mobile, clear distinction between heading levels maintained

## 9. Accessibility & Best Practices
*   **Color Contrast**: All text meets WCAG AA standards
    *   Slate 900 on Slate 50 background: AAA compliant
    *   White text on Indigo 900 background: AAA compliant
    *   Link colors tested for 4.5:1 minimum ratio
*   **Focus States**:
    *   Visible ring on all interactive elements: \`focus-visible:ring-2 focus-visible:ring-indigo-500\`
    *   Ring offset for clarity: \`focus-visible:ring-offset-2\`
    *   Never remove focus indicators
*   **Semantic HTML**:
    *   Proper heading hierarchy (h1 → h2 → h3)
    *   Native \`<button>\` elements for interactive actions
    *   \`<nav>\` for navigation, \`<footer>\` for footer
    *   Details/summary for FAQ accordions
*   **Image Alt Text**: Descriptive alternatives for all images
*   **Interactive States**:
    *   Hover: Visual feedback on all clickable elements
    *   Active: Subtle state change on click
    *   Disabled: Reduced opacity with \`pointer-events-none\`
*   **Motion Preferences**: Consider \`prefers-reduced-motion\` for users sensitive to animation
*   **Screen Reader Support**: Proper ARIA labels where semantic HTML insufficient`},"flat-design":{id:"flat-design",name:"Flat Design",mode:"light",fontType:"sans-serif",description:"A design philosophy centered on removing depth cues (shadows, bevels, gradients) in favor of pure color, typography, and layout. Crisp, two-dimensional, and geometric with bold color blocking.",layoutIdeas:{hero:"Full-width bold color block background (Primary Blue). Large decorative geometric shapes as background elements. Left-aligned text with massive headline (4xl to 8xl responsive). High-contrast CTA buttons with strong hover states. Right side features abstract geometric composition with overlapping shapes.",stats:"Clean 4-column grid with gradient background accent. Large colorful numbers (5xl-6xl) in varied accent colors. Uppercase labels. Hover scale effects on individual stats.",features:"3-column grid with section title. Each feature card has distinct soft background color (blue-50, green-50, amber-50, etc.) with white icon circles. Strong hover states with scale and color intensification.",howItWorks:"Dark background (gray-900) for contrast. Horizontal step circles connected by background line. Large numbered circles in primary blue with border. Clean white text on dark.",benefits:"50/50 split screen layout. Left side emerald green solid with white text and bullet points. Right side white with abstract geometric overlapping shapes in mix-blend-multiply mode.",pricing:"3-column grid. Popular tier is scaled and uses primary blue block. Other tiers use light gray blocks. 'Most Popular' badge on featured tier. All cards have strong hover scale effects.",testimonials:"Masonry columns layout. White cards on light gray background. Large decorative quote mark. Avatar circles with bold typography.",faq:"Centered accordion with thick (2px) borders. Plus/Minus icons with bold stroke weight. Clean expansion with no background change.",blog:"3-column grid on light gray background. White cards with image top (rounded corners). Strong hover state with image scale. Bold date, title, and 'Read Article' CTA.",footer:"Dark gray-900 background. Logo with colored square. Multiple column layout with primary blue section titles. Circular social icons."},content:`# Design Philosophy
**Flat Design** removes all artifice. It rejects the illusion of three-dimensionality—no drop shadows, no bevels, no realistic gradients, no textures. It relies entirely on **hierarchy through size, color, and typography**. This is not minimalism for the sake of being minimal; it's **confident reduction** that creates visual interest through pure form.

The aesthetic is **digital-native but print-inspired**: crisp edges, solid blocks of color, and a strict reliance on the grid. It communicates clarity, efficiency, and modernity. It is not "boring" or "plain"; it is **boldly reductive and graphic**. Every element exists because it is necessary. Visual interest comes from the strategic interplay of solid shapes, vibrant (but controlled) color palettes, and dynamic scale.

**Core Principles:**
1.  **Zero Artificial Depth**: The Z-axis does not exist. Everything is on the same plane. However, visual hierarchy is created through scale, color contrast, and strategic layering of flat shapes.
2.  **Color as Structure**: Bold background colors define sections and grouping, not lines or shadows. Color transitions are sharp, never blurred or gradual.
3.  **Typography as Interface**: Text size and weight bear the load of hierarchy. Typography is geometric, bold, and demands attention.
4.  **Geometric Purity**: Rectangles, circles, and squares dominate. Rounded corners are consistent and moderate. No organic blobs or complex shapes.
5.  **Interactive Feedback**: Hover states are pronounced through color shifts, scale transformations, and instant transitions—never through shadow depth.
6.  **Strategic Decoration**: Large, subtle geometric shapes in background create visual interest without breaking the flat aesthetic—think poster design.

# Design Token System

## Colors (Single Palette: Light Mode)
A vibrant, confident palette that avoids muddy tones. High contrast is essential.

-   **Background**: \`#FFFFFF\` (Pure White) - The canvas.
-   **Foreground**: \`#111827\` (Gray 900) - Sharp, high-contrast text.
-   **Primary**: \`#3B82F6\` (Blue 500) - The "Action" color. Bright, standard digital blue.
-   **Secondary**: \`#10B981\` (Emerald 500) - Supporting accent.
-   **Accent**: \`#F59E0B\` (Amber 500) - For highlights/badges.
-   **Muted**: \`#F3F4F6\` (Gray 100) - Used for secondary backgrounds/blocks.
-   **Border**: \`#E5E7EB\` (Gray 200) - Used sparingly.

## Typography
**Font Family**: **'Outfit', sans-serif**.
A geometric sans-serif that mirrors the shapes of the UI.
-   **Headings**: Bold (700) or Extra Bold (800). Tight letter-spacing (\`-0.02em\`).
-   **Body**: Regular (400). Readable, standard spacing.
-   **Labels/Buttons**: Medium (500) or SemiBold (600). Uppercase often used for labels (\`tracking-wider\`).

## Radius & Shapes
-   **Radius**: \`rounded-md\` (6px) or \`rounded-lg\` (8px). Consistent throughout. Not fully rounded (pill) unless it's a tag.
-   **Borders**: generally \`0px\`. We use background colors to define edges. If a border is needed (e.g., inputs), \`border-2\` solid color.

## Shadows & Effects
-   **Shadows**: \`shadow-none\`. **ABSOLUTELY NO BOX SHADOWS ON ELEMENTS.**
-   **Gradients**: Only subtle directional gradients for background decoration (e.g., \`from-[#F3F4F6] to-transparent\`). Never on buttons or cards. Never colorful or vibrant gradients.
-   **Blur**: None on elements. No backdrop-blur effects.
-   **Background Decoration**: Large geometric shapes with low opacity (\`bg-white/5\`) positioned absolutely for visual interest.

# Component Stylings

## Buttons
-   **Primary**: Solid Primary color background. White text. \`rounded-md\`. Height \`h-14\` to \`h-16\` for good touch targets. \`transition-all duration-200 hover:scale-105\` (scale transformation for feedback). Color shift on hover (e.g., \`hover:bg-blue-600\`). No shadow.
-   **Secondary**: Solid Muted background (Gray 100). Dark text. \`hover:bg-gray-200\` with scale effect.
-   **Outline**: \`border-4\` solid color (not border-2 for more boldness). Text matches border color. Transparent bg. \`hover:bg-[color] hover:text-white\` (fill effect on hover).

## Cards
-   **Style**: "Color Block".
-   **Appearance**: Solid background color (White on Gray page, or soft color tints like \`bg-blue-50\`, \`bg-green-50\` for features). No shadow. No border. Padding is generous (\`p-6\` or \`p-8\`). Rounded corners \`rounded-lg\`.
-   **Interaction**: \`group cursor-pointer transition-all duration-200 hover:scale-[1.02]\` (subtle scale). For colored backgrounds, add \`hover:bg-[color]-100\` for intensification. Icons within cards can have \`group-hover:scale-110\`.

## Inputs
-   **Normal**: Gray 100 background (\`bg-gray-100\`). No border. Text Gray 900. \`rounded-md\`.
-   **Focus**: White background. \`border-2\` solid Primary. No focus ring glow, just the hard border.

## Section Stylings
-   **Alternating Backgrounds**: Use White vs. Gray 100 (\`#F3F4F6\`) vs. Bold accent colors (Primary Blue, Emerald, Amber) to distinguish page sections. Sharp color transitions between sections.
-   **Dividers**: No thin line dividers between sections. Use whitespace or color blocks. Exception: FAQ uses thick \`border-2\` between items for structure.
-   **Background Decoration**: Use \`absolute\` positioned geometric shapes with low opacity or subtle gradients for visual interest. Examples: large circles (\`rounded-full\`), rotated squares, gradient overlays (\`from-[color] to-transparent\`).

# Iconography
-   **Library**: \`lucide-react\`.
-   **Style**: Standard to bold stroke (2px to 2.5px for emphasis).
-   **Treatment**: Often placed inside a solid colored circle (white circle with colored icon like \`bg-white text-blue-600\`). Circle size \`h-14 w-14\` or \`h-16 w-16\`.
-   **Animation**: \`transition-transform duration-200 group-hover:scale-110\` for icons within cards. Simple color intensity shifts on hover.

# Layout & Spacing
-   **Container**: \`max-w-7xl\`.
-   **Grid**: Rigid. 12-column base. Elements align perfectly.
-   **Spacing**: Comfortable but structured. Multiples of 4 (Tailwind default).
-   **Density**: Medium. Not too airy, not too dense. "Functional".

# Motion
-   **Vibe**: "Digital", "Snappy", "Direct".
-   **Transitions**: \`transition-all duration-200\` for most interactions. \`duration-300\` for larger transformations.
-   **Hover**: Immediate visual feedback through:
     - Scale transformations (\`hover:scale-105\` for buttons, \`hover:scale-[1.02]\` for cards)
     - Color shifts (darkening or lightening)
     - Color fills (outline buttons filling with color)
     - Icon scaling within cards (\`group-hover:scale-110\`)

# Accessibility
-   **Focus Rings**: Since we have no shadows, focus states must use high-contrast \`ring-2 ring-offset-2 ring-blue-500\` or similar solid outlines.
-   **Contrast**: Text on colored backgrounds must pass WCAG AA (e.g., White text on Blue 500 is okay, but check carefully with lighter accents).

# Non-Genericness / "The Bold Factor"
-   **Avoid**: "Material Design" floating cards, generic Bootstrap layouts, subtle pastels everywhere.
-   **Emphasize**: The "Poster" look. Treat every section like a flat graphic poster with bold color blocking.
-   **Bold Choices Implemented**:
     - **Large decorative geometric shapes** in hero background (circles, rotated squares with low opacity)
     - **Vibrant full-section color blocks** (Blue hero, Emerald benefits, Amber CTA, Dark gray How It Works & Footer)
     - **Dramatic scale effects** on pricing cards (popular tier starts larger and scales more)
     - **Multi-color stat numbers** (each stat uses a different accent color)
     - **Abstract geometric compositions** (overlapping shapes in hero illustration and benefits section)
     - **Pronounced hover states** (scale, color intensification, fills)
     - **Bold typography** with tight leading and strong weight contrast
     - **Thick borders** (border-4 on outline buttons, border-2 on FAQ items)
-   **Visual Interest Without Depth**: Achieved through color contrast, geometric layering, and scale—never shadows or gradients.`},glassmorphism:{id:"glassmorphism",name:"Glassmorphism",mode:"dark",fontType:"sans-serif",description:"Apple-inspired aesthetic with rich mesh gradients, premium blur, and constrained layouts.",layoutIdeas:{},content:'**Design Philosophy**\n- **Core Principles**: Inspired by Apple\'s VisionOS and macOS. Premium, ethereal, and content-forward. The glass should feel like a high-quality physical material.\n- **Vibe**: Exclusive, focused, and fluid. Less "sci-fi", more "luxury tech".\n\n**Design Token System (The DNA)**\n- **Colors (Apple Dark Mode)**\n  - `background`: `#000000` (Pure Black) - The canvas.\n  - `foreground`: `#F5F5F7` (Apple Off-White).\n  - `muted`: `rgba(255, 255, 255, 0.08)` - Secondary text/elements.\n  - `accent`: `#2997FF` (Apple Blue) or `#BF5AF2` (Purple) - Used sparingly in gradients.\n  - `border`: `rgba(255, 255, 255, 0.1)` - Subtle separation.\n- **Typography**\n  - **Font**: Use **"Inter"** (closest free proxy to SF Pro). \n  - **Headings**: `font-semibold`, `tracking-tight`. Clean and legible.\n- **Radius**: `32px` for outer containers, `20px` for inner cards. Smooth, continuous curves.\n- **Shadows**: Large, diffuse colored glows behind elements, but crisp drop shadows for floating elements.\n- **Textures**: \n  - **Background**: A rich, animated **Mesh Gradient** using Apple-style tones (Blue, Purple, Pink, Orange) against a black void.\n  - **Glass Material**: `backdrop-filter: blur(50px) saturate(180%)`. `bg-white/[0.08]`.\n\n**Component Stylings**\n- **Buttons**:\n  - **Primary**: White text on a glass layer that gets brighter on hover. Or a soft gradient background.\n  - **Secondary**: Darker glass.\n- **Cards**:\n  - "Platters". High blur, subtle white border (`border-white/10`), distinct separation from background.\n- **Inputs**:\n  - Deep, dark glass. `bg-white/5` rounded-full.\n\n**Non-Genericness (The "Bold" Factor)**\n- **Constrained Layout**: Use a **tighter max-width** (`max-w-5xl` or `max-w-4xl`) to make the content feel precious and focused.\n- **Dynamic Mesh**: The background should be the main source of color, bleeding through the glass.\n- **Bento Grid**: Use a strict, rounded bento grid for feature layouts.\n\n**Completeness & Content**\n- **MANDATORY**: Implement ALL sections from `data.json`: Hero, Product Detail, Stats, Blog, Features, How It Works, Benefits, Testimonials, Pricing, **FAQ**, Final CTA, Footer.\n- **FAQ**: Use glass cards for the FAQ items.\n\n**Effects & Animation**\n- **Mesh Animation**: Create a `mesh-blob` CSS class with infinite rotation. **CRITICAL**: Define `animation-delay` utility classes (`.animation-delay-2000`, `.animation-delay-4000`) in the CSS to ensure blobs move asynchronously.\n- **Transitions**: Smooth, slow transitions (`duration-500`).\n\n**Implementation Notes**\n- Ensure sufficient contrast for text on glass backgrounds.\n- Use `lucide-react` for icons.'}
(total 45329 chars)

========== kinetic ==========
--- record 0 (len 74) ---
{id:"kinetic",name:"Kinetic",path:"/kinetic",mode:"dark",accent:"#F97316"}
(total 74 chars)
--- record 1 (len 51200) ---
{id:"kinetic",name:"Kinetic",mode:"dark",fontType:"sans-serif",description:"Motion-first design where typography is the primary visual medium. Features infinite marquees, viewport-scaled text, scroll-triggered animations, and aggressive uppercase styling. High contrast, brutalist energy with rhythmic movement.",layoutIdeas:{hero:"Full viewport height (90vh) with massive text using clamp() for responsive scaling (clamp(3rem,12vw,14rem)). Split headlines across lines with contrasting accent color. Add scroll-triggered scale (1.0→1.2) and opacity (1.0→0) transforms via Framer Motion. Center content with max-w-[95vw].",stats:"Infinite horizontal marquee on full-width accent background (py-8). Display huge numbers (6xl-8xl) paired with uppercase labels and decorative symbols (✦). Use react-fast-marquee with speed 80, no gradients—raw, continuous motion with border-y dividers.",productDetail:"Two-column grid on desktop with massive heading (5xl-8xl uppercase). Each column has left border-l-4 with massive background numbers (6rem-8rem) positioned absolutely. Paragraphs in muted color with generous line-height. Numbers change color on hover.",features:"Sticky scroll cards (top-24/top-32) that stack vertically as user scrolls. Display massive index numbers (6xl-8xl) in muted tones. Feature titles in accent color at 3xl-6xl uppercase. Sharp 2px borders that highlight on hover. Cards use p-8/p-12 with responsive flex layout.",blog:"2-3 column grid (md:grid-cols-2 lg:grid-cols-3) with gap-px hairline dividers. Each card shows massive background number (3rem-4rem), uppercase title with translate-x-4 hover effect. Author and date in footer with border-top. Hover transitions to muted background.",howItWorks:"Three-column grid with gap-px hairline dividers creating connected cards. Massive step numbers (8rem-12rem) at top, content at bottom. Full card color inversion on hover (background to accent, text to black). Min-height 500-600px for dramatic scale.",benefits:"Full-width list with border-b dividers. Massive titles (4xl-7xl) that translate horizontally on hover (translate-x-4/translate-x-8). Descriptions fade in on hover (opacity-0→100) on desktop, always visible on mobile. Text-right alignment for descriptions on desktop.",pricing:"2-3 column grid (md:grid-cols-2 lg:grid-cols-3). Border-based cards with 2px borders. Prices at 6xl-7xl. Full card hover transitions (border and background to accent, text to black). Features use colored square bullets (h-2 w-2). Highlighted tier has muted background.",testimonials:"Horizontal scrolling marquee (slower speed 40). Large quotes (4xl bold uppercase) with accent border-left (4px). Author details with square placeholders. Wide spacing (mx-12) between cards for breathing room. No gradients on edges.",faq:"Accordion with large questions (xl-4xl uppercase). Touch-friendly expand/collapse icons in 40x40px containers. Answers in muted color (lg-2xl) with generous line-height. Framer Motion height animations (duration 300ms, easeInOut).",footer:"Full-height section (min-h-screen) on accent background with black text. Massive headline using clamp(2.5rem,8vw,10rem). Huge input with border-bottom styling. 2-4 column footer nav grid. Bold 2px border-t divider for copyright section."},content:`# Design Style: Kinetic Typography

## Design Philosophy

**Core Principle**: Typography is not decoration—it is the entire visual structure. Text becomes image, headline becomes hero, motion becomes rhythm. This style rejects static layouts completely. Every element should feel alive through constant motion (marquees), reactive motion (hover states), or scroll-triggered motion (parallax, scale transforms). The page pulses with kinetic energy—nothing is ever truly still.

**Aesthetic Vibe**: High-energy brutalism meets kinetic poster design. Confidence through scale. Urgency through motion. Clarity through contrast. The design screams rather than whispers—everything is uppercase, oversized, and in-your-face. It's a poster come to life, with the raw energy of street art and the precision of Swiss typography, but animated and interactive. Think music festival posters, protest graphics, and underground zines translated to the web.

**Visual DNA**: This style is instantly recognizable by its relentless motion and aggressive scale. Marquees scroll endlessly. Numbers tower at 8-12rem. Headlines use viewport units (clamp-based for control). Every hover state is dramatic—cards flood with color, text translates across the screen, borders glow with accent hues. The aesthetic is deliberately excessive: if traditional web design uses 2x scale difference between headline and body, this uses 10x. Where others add subtle shadows, this style stays brutally flat with sharp borders and hard edges.

**Signature Elements**:
- Infinite marquees that never stop moving (react-fast-marquee, no gradients)
- Viewport-responsive typography using clamp() for fluid scaling (clamp(3rem,12vw,14rem))
- Aggressive uppercase treatment on ALL display text (headings, buttons, labels)
- Massive numerical elements (6rem-12rem) used as decorative graphic shapes
- Hard color inversions on hover (background to accent yellow, text to black, instant transitions)
- Scroll-triggered scale and opacity transforms (Framer Motion useScroll hook)
- Sharp 2px borders with 0px border-radius (brutalist geometry)
- Hairline gap-px grid dividers creating connected card systems

## Design Token System (The DNA)

### Color Architecture

**Foundation Colors**:
- \`background\`: \`#09090B\` (Rich black, not pure black—softer on eyes)
- \`foreground\`: \`#FAFAFA\` (Off-white, not pure white—less harsh)
- \`muted\`: \`#27272A\` (Dark gray for secondary surfaces)
- \`muted-foreground\`: \`#A1A1AA\` (Zinc 400 for body text and descriptions)

**Accent Strategy**:
- \`accent\`: \`#DFE104\` (Acid yellow/lime—high energy, highly visible)
- \`accent-foreground\`: \`#000000\` (Pure black for contrast on accent)
- \`border\`: \`#3F3F46\` (Zinc 700—subtle structural lines)

**Color Usage Patterns**:
- Use acid yellow sparingly but boldly (hero text highlights, hover states, focus rings, marquee backgrounds)
- Muted foreground (Zinc 400) for all secondary text—never use plain gray
- Border color for ALL structural lines—never use foreground color for borders
- Background numbers and inactive elements in \`muted\` (#27272A) to create depth layers
- Selection highlight: Yellow background with black text

**Contrast Requirements**:
- Primary text to background: Minimum 15:1 ratio (off-white on rich black)
- Accent to background: Must be vibrant and eye-catching
- Never use mid-range grays—stay at the contrast extremes

### Typography System

**Font Selection**:
- Primary: "Space Grotesk" (preferred—strong geometric shapes, excellent at large sizes)
- Fallback: "Inter" (if Space Grotesk unavailable)
- Both should support variable font weights if possible (300-700 range)

**Scale Hierarchy** (using Tailwind classes with responsive scaling):
- **Hero/Display**: \`text-[clamp(3rem,12vw,14rem)]\` (fluid viewport-based scaling with safe minimums)
- **Section Headings**: \`text-5xl md:text-7xl lg:text-8xl\` or \`text-[clamp(2.5rem,8vw,6rem)]\` for ultra-massive headings
- **Card Titles**: \`text-2xl md:text-3xl lg:text-6xl\` (responsive scaling from mobile to desktop)
- **Body/Descriptions**: \`text-lg md:text-xl lg:text-2xl\` (18-24px—larger than typical web, responsive)
- **Small Labels**: \`text-xs md:text-sm lg:text-lg\` (12-18px, responsive)
- **Massive Numbers** (decorative): \`text-[6rem] md:text-[8rem]\` to \`text-[8rem] md:text-[12rem]\` (responsive massive scale)
- **Navigation/Micro**: \`text-sm md:text-base\` (14-16px)

**Type Treatment Rules**:
- ALL display text (headings, buttons, labels) must be uppercase
- Body text and descriptions stay in normal case for readability
- Tracking: Use \`tracking-tighter\` on large display text, \`tracking-tight\` on body, \`tracking-wide\` or \`tracking-widest\` on small labels
- Leading: \`leading-[0.8]\` or \`leading-none\` for display headlines to create tight, graphic lockups
- Leading: \`leading-tight\` for large body text (xl-2xl)
- Font weight: Bold (700) for all headings and buttons, Medium (500) for body, Regular (400) for secondary text

**Font Size Relationships**:
- Headlines are 3-5x larger than body text (not 1.5-2x like traditional web)
- Numbers as graphics are 4-8x larger than accompanying labels
- Decorative background text is 2-3x larger than foreground text in same context

### Spacing & Layout

**Base Unit**: 4px (Tailwind's default spacing scale)

**Vertical Rhythm**:
- Section padding: \`py-32\` (128px top/bottom) for major sections
- Card/Container padding: \`p-8\` to \`p-12\` (32-48px)
- Element gaps within containers: \`gap-8\` (32px)
- Tight element groups: \`gap-4\` (16px)
- Between large display elements: \`mb-4\` to \`mb-8\` (16-32px)

**Horizontal Containment**:
- Maximum width: \`max-w-[95vw]\` or \`max-w-[90vw]\`—push to the edges
- Never use standard \`max-w-7xl\` or similar—too conservative for this style
- Specific content widths: \`max-w-2xl\` (672px) for long-form text blocks
- Full bleed for marquees and dramatic sections

**Padding Relationships**:
- Cards: Equal padding all sides (p-8 or p-12) OR asymmetric with more top/bottom than left/right
- Buttons: Horizontal padding 2-3x vertical (e.g., px-8 py-4)
- Inputs: Minimal horizontal padding (px-0 or px-2), more vertical for touch targets

**Grid Patterns**:
- Three-column grids for step processes (md:grid-cols-3)
- Single column on mobile, maintain drama with large text
- Use \`gap-px\` with colored backgrounds to create hairline grid dividers
- Pricing typically uses three equal columns (lg:grid-cols-3)

### Shape Language

**Border Radius**:
- Default: \`0px\` (completely sharp corners)
- Exception: Rare use of \`rounded-sm\` (2px) for subtle softening on small elements
- Never use rounded-lg or higher—destroys the brutalist aesthetic

**Border Styling**:
- Width: \`border-2\` (2px) for structural emphasis, \`border\` (1px) for subtle dividers
- Style: Always solid, never dashed or dotted
- Color: Use \`border-[#3F3F46]\` consistently
- Border-only elements: Use \`border-b-2\` for input underlines, \`border-l-4\` for quote accents

**Shadows & Depth**:
- **NO drop shadows**—this style is completely flat
- Depth created through color layering (muted background elements behind foreground)
- Use massive background numbers in muted tones to create visual depth
- Overlapping elements instead of shadow for hierarchy

**Visual Dividers**:
- Prefer borders over shadows
- Use full-width border-top/border-bottom at section breaks
- Grid gap patterns: \`gap-px\` with colored container creates hairline dividers

### Texture & Overlay

**Noise Texture**:
- SVG-based feTurbulence filter (baseFrequency 0.8, numOctaves 4)
- Fixed position, full viewport coverage
- Opacity: \`opacity-[0.03]\` (barely visible)
- Blend mode: \`mix-blend-overlay\`
- Purpose: Adds subtle print/poster texture without affecting readability

**Background Treatments**:
- Solid colors only—no gradients
- Accent color used for full-section backgrounds (stats marquee, footer)
- Muted color for card hover backgrounds before accent flip

**Blend Modes**:
- Use \`mix-blend-difference\` or \`mix-blend-exclusion\` sparingly for text over images
- Apply to custom cursors or special text treatments
- Not part of the core style in current implementation but suggested for advanced implementations

## Component Styling Principles

### Buttons

**Base Styling**:
- Always uppercase text with tight tracking (\`uppercase tracking-tighter\`)
- Font weight: Bold (700)
- Sharp corners (rounded-none)
- Height: Default 56px (h-14), Small 40px (h-10), Large 80px (h-20)
- Horizontal padding 2x height: Default px-8, Small px-4, Large px-12

**Variant Patterns**:

**Primary (Accent)**:
- Background: Acid yellow (#DFE104)
- Text: Black
- Hover: Scale up 1.05 (\`hover:scale-105\`)
- Active: Scale down 0.95 (\`active:scale-95\`)
- Transition: \`transition-all\` for smooth scale

**Outline**:
- Border: 2px solid zinc-700 (#3F3F46)
- Background: Transparent
- Text: Off-white
- Hover: Full fill with off-white background, text inverts to black
- Hard transition (instant color flip)

**Ghost**:
- No border, no background
- Text: Off-white
- Hover: Text color changes to accent yellow
- Minimal, subtle variant

**Advanced Interactions** (not implemented but suggested):
- Marquee effect: Text inside button scrolls horizontally on hover
- Character-by-character color fill on hover (left to right)

### Cards & Containers

**Base Structure**:
- Border: 2px solid zinc-700 (\`border-2 border-[#3F3F46]\`)
- Background: Rich black (#09090B)
- Padding: Large and even (p-8 or p-12)
- No border-radius (sharp corners)

**Hover Behavior**:
- Background floods with accent color (#DFE104)
- Border color changes to accent
- All text inverts to black
- Transition: \`duration-300\` for smooth but noticeable shift
- Use group classes to coordinate text color changes

**Content Hierarchy Within Cards**:
- Large title at top (text-3xl) in foreground color → black on hover
- Description text in muted-foreground → black with reduced opacity on hover
- Decorative numbers or icons in muted tone → black on hover

**Sticky Card Pattern** (Features Section):
- Each card uses \`sticky top-32\` positioning
- Cards stack and overlap as user scrolls
- Later cards appear to slide over earlier ones
- Maintains visual rhythm through repetition

### Inputs & Forms

**Base Styling**:
- Height: Extra tall (h-24 / 96px) for dramatic scale
- Border: Bottom border only (\`border-b-2\`)
- Border color: Zinc-700 default, accent on focus
- Background: Transparent
- Text: Extra large (text-4xl), bold, uppercase, tight tracking
- Padding: Minimal horizontal (px-0), standard vertical for alignment

**Focus States**:
- Border-bottom changes to accent yellow
- No outline ring—border serves as focus indicator
- Instant color change (no transition needed)

**Placeholder Styling**:
- Muted color (#27272A)—very subtle
- Same size and style as input text
- Uppercase to match input
- Low contrast ensures actual input stands out

**Form Layout**:
- Full width inputs (w-full)
- Generous vertical spacing between fields (space-y-8)
- Labels (if used) should be small, uppercase, tracked-wide, above input

### Interactive States

**Hover Transformations**:
- Scale: Buttons scale to 1.05, cards stay at scale 1.0
- Translation: Benefit titles translate horizontally (\`translate-x-8\`)
- Color Floods: Cards completely invert color scheme
- Opacity Reveals: Hidden descriptions fade in (opacity-0 to opacity-100)
- All transitions use \`duration-300\` for consistent feel

**Focus States**:
- Inputs: Border color change to accent
- Buttons: Same as hover (scale) plus visible focus ring in accent color
- Links: Underline in accent color or text color change

**Active States**:
- Buttons: Scale down to 0.95 (\`active:scale-95\`) for tactile feedback
- Links: Slight opacity reduction

**Disabled States**:
- Opacity: 50% (\`disabled:opacity-50\`)
- Pointer events: None (\`disabled:pointer-events-none\`)
- Maintain all other styling—just reduce visibility

## Animation & Motion System

### Marquee Motion

**Implementation**: Use \`react-fast-marquee\` library for smooth, GPU-accelerated marquees

**Stats Marquee** (High Energy):
- Speed: 80 (fast)
- Direction: Left to right
- Gradient: false (no edge fade)
- AutoFill: true (repeats content infinitely)
- Content: Large numbers paired with labels and decorative symbols

**Testimonials Marquee** (Slower Rhythm):
- Speed: 40 (medium)
- Direction: Left to right
- Gradient: false
- Content: Wide cards with quotes, generous spacing between items

**Timing Rules**:
- Never use gradients—raw edge is part of aesthetic
- Fast marquees (speed 60-100) for stats and high-energy content
- Slower marquees (speed 30-50) for reading content like testimonials
- All marquees use linear easing (no acceleration/deceleration)

### Scroll-Triggered Animations

**Hero Parallax** (Framer Motion):
- Track scroll progress: \`useScroll()\` hook
- Scale transform: 1.0 → 1.2 as user scrolls (0-20% of page)
- Opacity: 1.0 → 0 as user scrolls out
- Creates dramatic zoom-out effect as user enters content

**Sticky Scroll Cards**:
- Position: \`sticky top-32\`
- No transform animations—physical stacking creates effect
- Cards remain in place as subsequent cards slide over them

**Entrance Animations** (Suggested, not in current implementation):
- Elements scale from 0.8 to 1.0 as they enter viewport
- Text can "unmask" by animating from clipped to full visibility
- Use intersection observer or Framer Motion \`whileInView\`

### Micro-Interactions

**Button Interactions**:
- Hover: Scale 1.05 with all easing
- Active: Scale 0.95
- Transition timing: 200-300ms
- Easing: Default ease-in-out

**Card Hover**:
- Color transition: 300ms
- Hard flip, not gradual (suits the brutalist aesthetic)
- All child text coordinates color change via group classes

**Accordion Expansion** (FAQ):
- Height: Animate from 0 to auto
- Opacity: Fade in content (0 to 1)
- Timing: Smooth with slight bounce (framer motion spring)
- Initial: false (doesn't animate on mount)

**Text Reveals**:
- Benefit descriptions: Opacity 0 to 1, duration 300ms
- Benefit titles: Horizontal translate + duration 300ms
- Both triggered simultaneously on hover

### Easing & Timing

**Default Durations**:
- Micro-interactions (hovers, focus): 200-300ms
- Section animations: 500-800ms
- Marquees: Continuous linear (no easing)

**Easing Functions**:
- Buttons and scale effects: \`ease-in-out\` (default)
- Marquees: \`linear\` (constant speed)
- Accordion: Spring physics from Framer Motion
- Parallax: Linear mapping from scroll position

**Performance Notes**:
- Prefer transforms (scale, translate) over position changes
- Use opacity instead of visibility for reveals
- Marquees should use transform: translateX for GPU acceleration
- Keep animations at 60fps—avoid complex calculations in scroll handlers

## Layout Principles

### Grid Philosophy

**Break the Grid**: This style embraces asymmetry and overlap. Elements can:
- Extend beyond their containers
- Overlap previous elements (sticky scroll)
- Use uneven column widths
- Break alignment for dramatic effect

**Standard Patterns**:
- Single column mobile (always)
- Two column for benefits/features on tablet (md)
- Three column for pricing/steps on desktop (lg)
- Four column for footer navigation

**Grid Gaps**:
- Standard: \`gap-8\` (32px) between major elements
- Hairline: \`gap-px\` with colored container background for connected cards
- Wide: \`gap-12\` to \`gap-24\` for breathing room in dense sections

### Section Flow

**Vertical Rhythm**:
- Major sections: \`py-32\` (128px) top and bottom
- Subsections: \`py-20\` (80px)
- Dense content areas: \`py-12\` (48px)

**Section Dividers**:
- Full-width border-top or border-bottom in zinc-700
- Accent color background flips (black section → yellow section)
- Contrast creates natural breaks without needing extra space

**Content Width Strategy**:
- Hero: Max-w-[95vw]—push to edges
- Body content: Max-w-5xl or max-w-6xl
- Long-form text: Max-w-2xl or max-w-xl for readability
- Marquees: Full bleed (w-full, no max-width)

### Responsive Approach

**Mobile-First Strategy**:
- **Maintain drama**: Keep large text using clamp() values for safe scaling (e.g., \`clamp(3rem,12vw,14rem)\`)
- **Stack everything vertically**: Single column layouts with \`flex-col\` and \`md:flex-row\` patterns
- **Reduce padding progressively**: \`p-8 md:p-12\`, \`py-20 md:py-32\`, \`px-4 md:px-8\`
- **Marquees persist**: Essential to the style—keep them at all breakpoints
- **Touch targets**: Minimum 44x44px (h-10 w-10 for icon containers, h-14 for buttons)
- **Adapt hover effects**: Show descriptions always on mobile (opacity-100), hide on desktop (md:opacity-0) then reveal on hover
- **Sticky positioning**: Adjust top values (\`top-24 md:top-32\`) to account for nav height
- **Grid simplification**: 1 column → \`md:grid-cols-2\` → \`lg:grid-cols-3\`

**Breakpoints** (Tailwind defaults):
- **Mobile**: Base styles (320px-767px) - Single column, reduced text sizes, full-width elements
- **Tablet (md)**: 768px+ - Two-column layouts, medium text scaling, increased padding
- **Desktop (lg)**: 1024px+ - Three-column layouts, full dramatic scale, all hover effects active

**Text Scaling Best Practices**:
- **Use clamp()** for hero and massive headings: \`text-[clamp(3rem,12vw,14rem)]\`
- **Use responsive utilities** for section headings: \`text-5xl md:text-7xl lg:text-8xl\`
- **Use responsive utilities** for body text: \`text-lg md:text-xl lg:text-2xl\`
- **Use responsive utilities** for massive numbers: \`text-[6rem] md:text-[8rem]\` or \`text-[8rem] md:text-[12rem]\`
- Always test at 320px, 768px, 1024px, and 1440px+ widths

## The "Bold Factor" (Non-Generic Signatures)

These elements MUST be present to achieve the Kinetic Typography aesthetic:

1. **Viewport-Width Typography**: At least one headline must use viewport-width units (10vw+). This creates immediate scale and drama.

2. **Active Marquees**: At least two sections should use infinite scrolling marquees. One fast (stats), one slower (testimonials). No gradient edges.

3. **Massive Background Numbers**: Use oversized numbers (8rem-12rem) in muted tones as decorative background elements. They become graphic shapes, not just text.

4. **Hard Color Inversions**: Cards or sections that completely flip color scheme on hover (black → yellow background, white → black text). The transition should be clean, not gradual.

5. **Uppercase Display Treatment**: All headings, buttons, and labels in uppercase with tight tracking. This creates the poster-like, bold aesthetic.

6. **Aggressive Scale Hierarchy**: The difference between largest and smallest text should be 8-10x, not the typical 2-3x. Body text at 20-24px, headlines at 160-200px+.

7. **Minimal Border Styling**: Sharp corners (0px radius) and 2px borders in subtle zinc tones. Flat, no shadows. Brutalist structure.

**What Makes it Instantly Recognizable**:
- The constant motion (marquees never stop)
- The screaming scale (text fills the screen)
- The high contrast (near-black and off-white with acid yellow)
- The uppercase lockup (everything yells)

If these elements are removed or softened, the design becomes generic modern dark mode.

## Anti-Patterns (What to Avoid)

**Color Mistakes**:
- Never use pure black (#000000) or pure white (#FFFFFF)—too harsh
- Don't use soft pastels or mid-tone colors—breaks the high-contrast system
- Avoid gradients on backgrounds—this style is flat
- Don't use multiple accent colors—acid yellow only

**Typography Errors**:
- Don't use serif fonts or script fonts—kills the brutalist vibe
- Never use small text for headings (<text-3xl)—loses the bold factor
- Avoid mixed case in display text—uppercase is mandatory
- Don't use normal or wide tracking on large text—always tighter

**Layout Mistakes**:
- Don't center-align body text—left-align for readability
- Avoid small max-widths (max-w-4xl)—content should feel wide
- Don't use standard section padding (py-16)—go bigger (py-32)
- Never nest containers with conflicting max-widths

**Animation Mistakes**:
- Don't add drop shadow animations—stay flat
- Avoid slow, gentle transitions (800ms+)—this style is snappy
- Never stop the marquees or add pause-on-hover—motion is constant
- Don't use bounce or elastic easing on everything—reserve for specific elements

**Shape & Style Errors**:
- Never add border-radius above 2px—sharp corners are essential
- Don't use subtle borders (<1px)—go for 2px or border-bottom only
- Avoid soft shadows—this style has no depth effects
- Don't use opacity for hierarchy—use color contrast

**Component Mistakes**:
- Don't make buttons small and subtle—they should be bold and large
- Avoid input fields that look traditional—oversized is key
- Don't use cards with heavy padding and rounded corners—minimal, sharp
- Never use subtle hover states—changes should be dramatic

**Accessibility Violations**:
- Don't ignore motion preferences—respect prefers-reduced-motion
- Avoid color as the only indicator—ensure sufficient contrast
- Don't make click targets too small—maintain 44px minimum
- Never sacrifice readability for style—body text should be large and clear

## Accessibility Considerations

**Color Contrast**:
- Off-white (#FAFAFA) on rich black (#09090B): ~15:1 ratio (exceeds WCAG AAA)
- Accent yellow (#DFE104) on rich black: ~12:1 ratio (exceeds WCAG AAA)
- Muted foreground (#A1A1AA) on rich black: ~6:1 ratio (meets WCAG AA for large text)
- Accent with black text: ~14:1 ratio (exceeds WCAG AAA)

**Motion Preferences**:
- Wrap all marquees in \`@media (prefers-reduced-motion: no-preference)\`
- Provide static fallback: show content without scrolling
- Disable scroll-triggered animations for users who prefer reduced motion
- Maintain layout and hierarchy without motion

**Focus Indicators**:
- Accent-colored border or ring on focus
- Minimum 2px visible indicator
- Never remove focus styles—make them obvious
- Scale changes on buttons provide additional tactile feedback

**Keyboard Navigation**:
- All interactive elements must be focusable
- Accordion items should expand/collapse with Enter or Space
- Marquee content should be navigable via keyboard if interactive
- Skip links to main content if navigation is complex

**Screen Reader Considerations**:
- Noise texture SVG includes \`<title>\` element
- Decorative background numbers should have \`aria-hidden="true"\`
- Marquees need \`aria-live\` attributes if content updates
- Accordion state (expanded/collapsed) should be announced

**Touch Targets**:
- Minimum 44x44px for all interactive elements
- Buttons exceed this (default 56px height)
- Adequate spacing between clickable items (16px+)
- Large input fields (96px height) easy to tap

**Readability**:
- Body text larger than standard web (20-24px vs 16px)
- High contrast throughout
- Left-aligned paragraphs for easier reading
- Generous line-height (leading-tight = 1.25) for large text

**Testing Checklist**:
- Test with screen reader (NVDA, JAWS, VoiceOver)
- Verify keyboard-only navigation
- Check with prefers-reduced-motion enabled
- Validate color contrast with tools (Stark, axe DevTools)
- Test at 200% zoom level
- Verify touch targets on mobile devices`},luxury:{id:"luxury",name:"Luxury",mode:"light",fontType:"serif",description:"Elegant serif typography with monochromatic palette and gold accents. Ultra-slow animations, generous white space, and architectural precision. High-end fashion magazine editorial aesthetic with depth through subtle shadows and layering.",layoutIdeas:{hero:"Asymmetric 12-column grid with text content in left 7 columns (bottom-aligned) and hero image in right 5 columns. Decorative horizontal line and 'Est. 2024' label. Massive type scale (text-5xl to text-9xl). Vertical writing mode label on image. Hero image has shadow and inner border.",stats:"Horizontal strip with 2-4 column grid. Vertical left border on each stat. Large italic Playfair numerals with tiny uppercase labels. Responsive: 2 cols mobile, 4 cols desktop.",productDetail:"Two-column asymmetric layout (5/6 split with offset). Headline on left with gold italic accent. Body text on right with drop cap on first paragraph.",features:"Alternating image-text layout with offset columns. Images 3:4 aspect ratio with shadow, grayscale default. Text in 4 columns offset from edges. Numbered labels (01, 02) in gold. 'Read More' link buttons.",howItWorks:"Dark section with inverted palette. Grid of cards with 1px gap simulated borders. Each card has numbered step label, title, and description. Hover effect darkens background.",benefits:"Dark section with horizontal line dividers above each benefit (hover turns gold). 3-column grid. Section header split across columns.",pricing:"Minimalist cards with top border only. Featured tier has 4px gold top border and 'Most Popular' badge. Subtle shadows that deepen on hover. Check mark list with gold icons.",testimonials:"Two-column layout (content/testimonials). Each testimonial has left border (turns gold on hover), 5 gold stars, large italic serif quote, small grayscale avatar (color on hover), author name (gold on hover).",faq:"Left column: section title. Right column: accordion with dividers. Question in italic serif. Plus icon in bordered square rotates to minus when open. Gold accent on open state.",blog:"3-column grid. Images 4:5 aspect, grayscale with shadow (deepens on hover). Metadata in tiny uppercase with decorative horizontal divider. Title turns gold on hover.",footer:"Dark background. Large CTA headline (gold italic accent) on left, email signup on right. Full footer navigation in 2x4 grid. Bottom bar with company name, copyright, social links. All links hover to gold."},content:`# Design Style: Luxury / Editorial

## Design Philosophy

**Core Principles**: Elegance through restraint, precision, and depth. This style emulates high-end fashion magazines (Vogue, Harper's Bazaar, Kinfolk) and luxury brand websites (Chanel, Hermès, Aesop). Success depends on **exquisite typography hierarchy**, **generous negative space**, **slow cinematic motion**, **intentional asymmetry**, and **layered depth through subtle shadows**. The design creates visual tension through grid-breaking layouts while maintaining perfect architectural balance.

**Vibe**: Sophisticated, Timeless, Expensive, Serene, Curated, Deliberate, Editorial, Tactile.

**The Secret**: Luxury isn't about adding decoration—it's about removing everything unnecessary and perfecting what remains. Every element must feel intentional and considered. Slow down all motion to cinematic speeds (1500-2000ms for images). Add more space than feels comfortable. Use asymmetry to create visual interest. Layer depth through subtle shadows (never harsh drops) and inner borders. The design should feel like expensive paper that you want to touch.

## Design Token System (The DNA)

### Colors (Sophisticated Monochrome)

**Primary Palette:**
- **Background**: \`#F9F8F6\` (Warm Alabaster) — Not pure white (#FFFFFF). This off-white feels like expensive paper or linen. The warm undertone is critical.
- **Foreground**: \`#1A1A1A\` (Rich Charcoal) — Not pure black (#000000). Softer, more sophisticated. Used for primary text and sharp borders.
- **Muted Background**: \`#EBE5DE\` (Pale Taupe) — For subtle surface elevation, disabled states, or alternate backgrounds.
- **Muted Foreground**: \`#6C6863\` (Warm Grey) — For secondary text, captions, metadata. Maintains warmth of the palette.
- **Accent**: \`#D4AF37\` (Metallic Gold) — Use sparingly. For hover states, underlines, focus indicators, small decorative elements. Never use gold for large areas.
- **Accent Foreground**: \`#FFFFFF\` (Pure White) — Only used on top of dark backgrounds or gold elements.

**Layering Strategy:**
- Use opacity for borders and dividers: \`#1A1A1A\` at 10-20% opacity creates subtle separation
- Dark sections use inverted palette: \`#1A1A1A\` background with \`#F9F8F6\` text and \`#EBE5DE\` muted text at 60-80% opacity
- Never use pure black or pure white for text—always use the charcoal and alabaster values

### Typography (The Most Critical Element)

**Font Pairing:**
- **Heading Font**: "Playfair Display" (High-contrast serif) — Elegant, editorial, with distinctive high-contrast strokes. Use for headlines, large quotes, and emphasis.
- **Body Font**: "Inter" (Humanist sans-serif) — Clean, modern, highly legible. Use for body text, labels, UI elements.

**Type Scale & Hierarchy:**
- **Hero Headlines**: \`text-6xl\` to \`text-9xl\` (4rem to 8rem+) — Massive, dramatic. Use \`leading-[0.9]\` for tight, compressed vertical rhythm.
- **Section Headlines**: \`text-5xl\` to \`text-7xl\` (3rem to 4.5rem) — Still large, commanding attention.
- **Subsection Titles**: \`text-3xl\` to \`text-4xl\` (1.875rem to 2.25rem) — For card titles, feature headings.
- **Body Text**: \`text-base\` to \`text-lg\` (1rem to 1.125rem) — Comfortable reading size with \`leading-relaxed\` (1.625).
- **Overlines/Labels**: \`text-xs\` (0.75rem) — Always uppercase with wide tracking.
- **Micro-text**: \`text-[10px]\` — For metadata, copyright, tiny labels.

**Font Weight Distribution:**
- Playfair: Regular (400) for most headlines, Light (300) for specific contrast, Italic (400) for emphasis within headlines
- Inter: Medium (500) for buttons/links, Regular (400) for body, Light (300) sparingly

**Letter Spacing (Critical for Luxury Feel):**
- **Uppercase Labels**: \`tracking-[0.25em]\` to \`tracking-[0.3em]\` — Wide tracking creates elegance and readability
- **Buttons**: \`tracking-[0.2em]\` — Slightly less than labels but still generous
- **Headlines**: \`tracking-tight\` or default — Large serif headlines need tighter tracking
- **Body Text**: Default tracking — Never adjust body text spacing

**Line Height Strategy:**
- **Headlines**: \`leading-[0.9]\` to \`leading-tight\` (0.9 to 1.25) — Tight creates drama
- **Body Text**: \`leading-relaxed\` (1.625) — Generous for readability
- **Small Text**: \`leading-relaxed\` to default — Maintains breathing room

### Radius & Borders (Architectural Precision)

**Border Radius:**
- **Everything**: \`0px\` — Strictly rectangular. No rounded corners anywhere. This creates architectural precision and editorial sharpness.

**Border Treatment:**
- **Width**: Always \`1px\` — Thin, precise, deliberate
- **Color**: \`#1A1A1A\` at full opacity for strong borders, 10-20% opacity for subtle dividers
- **Style**: Single borders (top, bottom, left, right) rather than full boxes. Common pattern: \`border-t\` only
- **Dividers**: Use horizontal lines (\`h-px\`) or vertical lines (\`w-px\`) as decorative elements with background color

### Shadows & Effects (Subtle Layered Depth)

**Shadows:**
- **Philosophy**: Use extremely subtle, soft shadows to create depth and elevation—never harsh or prominent
- **Hero Image**: \`shadow-[0_8px_32px_rgba(0,0,0,0.12)]\` — Medium shadow for primary focal point
- **Feature Images**: \`shadow-[0_4px_24px_rgba(0,0,0,0.08)]\` — Light shadow with subtle inner border
- **Blog Images**: \`shadow-[0_4px_20px_rgba(0,0,0,0.06)]\` deepens to \`shadow-[0_8px_32px_rgba(0,0,0,0.12)]\` on hover
- **Cards**: \`shadow-[0_2px_8px_rgba(0,0,0,0.02)]\` deepens to \`shadow-[0_8px_24px_rgba(0,0,0,0.06)]\` on hover
- **Primary Buttons**: \`shadow-[0_4px_16px_rgba(0,0,0,0.15)]\` deepens to \`shadow-[0_8px_24px_rgba(0,0,0,0.25)]\` on hover
- **Inner Borders**: Use \`shadow-[inset_0_0_0_1px_rgba(0,0,0,0.04-0.08)]\` for subtle framing on images

**Texture & Grain:**
- **Paper Noise**: Subtle SVG noise texture overlay across entire page at 2% opacity to mimic expensive paper grain
- **Implementation**: Fixed position overlay with SVG fractal noise filter, pointer-events disabled, z-index 50
- **Purpose**: Adds tactile quality without being visible at first glance—creates "expensive paper" feel

**Image Treatment:**
- **Default State**: Grayscale filter (\`grayscale\`) — Creates monochromatic editorial look
- **Hover State**: Full color (\`grayscale-0\`) — Slow transition reveals color as reward
- **Transition**: \`duration-[1500ms]\` to \`duration-[2000ms]\` — Ultra-slow, cinematic reveal
- **Transform**: Subtle scale on hover (\`group-hover:scale-105\`) combined with color transition
- **Shadow Evolution**: Images gain deeper shadows on hover to enhance lift effect
- **Group Context**: Use \`group\` utility on parent for coordinated hover effects

### Grid & Vertical Lines (Structural Framework)

**Visible Grid System:**
- **4 Vertical Gridlines**: Fixed position lines spanning full viewport height, positioned at column boundaries
- **Implementation**: \`w-px\` divs with \`bg-[#1A1A1A]/20\`, fixed position, pointer-events disabled
- **Purpose**: Creates visible editorial grid structure, adds architectural quality
- **Spacing**: Aligned with 12-column layout breakpoints, typically at container edges and middle thirds

**Layout Grid:**
- **Columns**: 12-column grid system
- **Max Width**: 1600px for content container
- **Padding**: \`px-8\` mobile, \`px-16\` desktop — Generous horizontal breathing room
- **Asymmetry**: Use offset column starts (\`col-start-2\`, \`col-start-6\`) to create visual interest

## Component Styling Principles

### Buttons (Minimalist with Luxury Details)

**Visual Structure:**
- **Shape**: Rectangular, 0px border-radius, precise edges
- **Height**: \`h-12\` default (48px), \`h-14\` large (56px), \`h-10\` small (40px)
- **Padding**: Generous horizontal (\`px-8\` to \`px-10\`)
- **Typography**: Uppercase, \`text-xs\`, \`tracking-[0.2em]\`, medium weight

**Primary Button:**
- **Default**: Dark background (\`bg-[#1A1A1A]\`), white text
- **Hover Animation**: Gold layer (\`bg-[#D4AF37]\`) slides in from left using transform
  - Initial state: \`translate-x-[-100%]\` (off-screen left)
  - Hover state: \`translate-x-0\` (covers button)
  - Duration: \`duration-500\` with custom easing \`cubic-bezier(0.25, 0.46, 0.45, 0.94)\`
  - Text stays white and appears above gold layer using z-index
- **Structure**: Requires internal \`<span>\` for gold overlay and another for content (z-10)

**Secondary Button:**
- **Default**: Transparent background, thin border (\`border border-[#1A1A1A]\`), dark text
- **Hover**: Background fills to dark (\`bg-[#1A1A1A]\`), text inverts to white
- **Transition**: Smooth \`duration-500\` for elegant fill

**Link Button:**
- **Style**: Text with underline on hover, no background or border
- **Color**: Dark text, gold on hover optional

### Cards & Containers (Defined by Lines)

**Visual Approach:**
- **Background**: Transparent or subtle (\`bg-transparent\`)
- **Definition**: Single top border (\`border-t\`) rather than full box
- **Border**: \`border-[#1A1A1A]\` at 1px width
- **Padding**: Generous \`p-8\` mobile, \`p-12\` desktop
- **Hover**: Subtle background color shift (\`hover:bg-[#F9F8F6]/50\`) — barely visible

**Featured Cards:**
- Use thicker top border (\`border-t-4\`) with gold color (\`border-t-[#D4AF37]\`) to indicate importance
- Pricing tier highlighting, special features

**Image Cards:**
- Image in grayscale with slow color reveal on hover
- Use specific aspect ratios: \`aspect-[3/4]\` for features, \`aspect-[4/5]\` for blog posts
- Combine image scale with parent card hover state using \`group\` utility

### Inputs (Underline Only)

**Visual Style:**
- **Border**: Bottom border only (\`border-b\`), no other borders
- **Background**: Transparent (\`bg-transparent\`)
- **Border Color**: \`#1A1A1A\` default, \`#D4AF37\` on focus
- **Height**: \`h-12\` for consistency with buttons
- **Padding**: Minimal horizontal (\`px-0\`), vertical (\`py-2\`)

**Typography:**
- **Input Text**: Inter font, \`text-sm\`, dark color
- **Placeholder**: Playfair Display font, italic, warm grey color (\`text-[#6C6863]\`)
- **Reasoning**: Italic serif placeholder creates elegant, editorial feel

**Focus State:**
- Border changes to gold (\`focus-visible:border-[#D4AF37]\`)
- No ring or glow effects — keep it minimal

### Interactive States (Slow & Deliberate)

**Hover Effects:**
- **Duration**: \`duration-500\` to \`duration-700\` for most interactions (text, backgrounds, borders)
- **Duration (Images)**: \`duration-[1500ms]\` to \`duration-[2000ms]\` for image transitions
- **Easing**: \`ease-out\` or custom \`cubic-bezier(0.25, 0.46, 0.45, 0.94)\` for smooth luxury feel
- **Color**: Gold accent (\`#D4AF37\`) appears subtly on hover (text, borders, underlines)
- **Transform**: Subtle scale (\`scale-105\`) or translate — never abrupt
- **Shadow Evolution**: Shadows deepen on hover for lift effect
- **Testimonials**: Left border changes to gold, padding increases, avatar gains color
- **FAQ**: Question text turns gold, icon square rotates 90° and border turns gold

**Focus States:**
- Minimal focus rings: \`focus-visible:ring-1 focus-visible:ring-[#1A1A1A]\`
- Prefer border color change over visible rings
- Gold accent for focused inputs (\`focus-visible:border-[#D4AF37]\`)

**Disabled States:**
- Reduced opacity (\`opacity-50\`)
- Pointer events disabled
- No special color changes — muted appearance

**Micro-interactions:**
- **FAQ Accordion**: Icon rotates 90°, border turns gold on open, content fades in with translateY animation
- **Testimonial Stars**: Scale up slightly on card hover (\`group-hover:scale-110\`)
- **Blog Cards**: Shadow deepens, image scales and gains color
- **Navigation Links**: Gold color on hover with 500ms transition
- **Button Animations**: Gold overlay slides from left on primary buttons, shadow deepens

## Layout Principles (Breaking Symmetry)

**Asymmetric Composition:**
- **Avoid 50/50 splits**: Use 7/5, 4/4/4, or 4 offset by 2 column starts instead
- **Bottom-left alignment**: Position primary content at bottom of container, aligned left
- **Offset grids**: Start content at column 2 or 6 instead of 1, leaving deliberate empty space

**Vertical Spacing (Generous Air):**
- **Section Padding**: \`py-24\` to \`py-32\` (6rem to 8rem) — Massive vertical space between sections
- **Component Padding**: \`p-8\` to \`p-12\` for cards and containers
- **Element Spacing**: Use \`gap-12\` or \`gap-16\` for component groups, not tight spacing
- **Breathing Room**: If it feels like too much space, it's probably correct for luxury design

**Section Alternation:**
- Alternate light (\`bg-[#F9F8F6]\`) and dark (\`bg-[#1A1A1A]\`) sections for rhythm
- Use top borders (\`border-t\`) to separate sections without color changes
- Dark sections use inverted color palette with muted text at 60-80% opacity

**Content Width:**
- Maximum container: \`max-w-[1600px]\`
- Centered with \`mx-auto\`
- Text columns: \`max-w-md\` to \`max-w-xl\` for comfortable reading

## The "Bold Factor" (Non-Genericness)

These signature elements make Luxury/Editorial instantly recognizable and must be present:

1. **Vertical Text Labels**: Use CSS \`writing-mode: vertical-rl\` for decorative side labels (e.g., "Editorial / Vol. 01"). Position absolutely on images, typically on left or right edges. Uppercase with wide tracking. Hidden on mobile, visible on desktop.

2. **Drop Caps**: Large initial letter for introductory paragraphs using \`float-left\`, Playfair Display font, 7xl size, tight line-height (0.8), with right margin (mr-3). Applied to first paragraph of Product Detail and Features intro. Creates classic editorial feel.

3. **Mixed Italic Headlines**: Within large headlines, alternate between regular and italic styling for specific words to create "spoken" cadence. Use gold color on italic words. Examples: "Curated *Excellence*", "The *Details*", "The *Process*". Headline splits across lines with specific words emphasized.

4. **Grayscale Image Transitions**: All images default to grayscale filter with ultra-slow (1500-2000ms) transition to full color on hover. Combines with subtle scale transform (\`group-hover:scale-105\`) and shadow deepening. Applied consistently to hero, features, blog, and testimonial avatars.

5. **Visible Grid Lines**: Fixed vertical lines spanning viewport height, aligned with 12-column grid boundaries, at low opacity (20%). Four lines total (edges and middle thirds). Creates architectural editorial magazine feel. Pointer-events disabled.

6. **Gold Sliding Animation**: Primary button hover reveals gold background (\`#D4AF37\`) sliding from left using \`translate-x\` transform. Requires layered span structure with z-index. Combined with shadow deepening from \`shadow-[0_4px_16px]\` to \`shadow-[0_8px_24px]\`.

7. **Decorative Horizontal Lines**: Short horizontal lines (\`h-px w-8 md:w-12\`) used as decorative elements before labels (hero) or between metadata (blog dates). Deliberate, architectural spacing elements.

8. **Extreme Type Scale**: Massive headlines (\`text-5xl\` mobile to \`text-9xl\` desktop) combined with tiny uppercase labels (\`text-[10px]\` to \`text-xs\`) creates dramatic hierarchy essential to luxury feel. Responsive scaling maintains proportions.

9. **Layered Shadows**: Subtle shadows create depth without being obvious. Images have box shadows that deepen on hover. Inner borders (\`inset\` shadows) frame images. Cards lift with shadow evolution. Never harsh—always soft and refined.

10. **Testimonial Interactions**: Left border animation (changes to gold and increases padding on hover), grayscale avatar transitions to color, author name turns gold, stars scale up. Multi-layered coordinated effect.

## Anti-Patterns (What to Avoid)

These mistakes will break the luxury aesthetic:

1. **DO NOT use rounded corners** — Everything must be perfectly rectangular with 0px border-radius
2. **DO NOT use harsh shadows** — Only use extremely subtle shadows with low opacity rgba values. Depth comes from layering, not prominent drops.
3. **DO NOT use pure black (#000000) or pure white (#FFFFFF)** — Use charcoal (#1A1A1A) and alabaster (#F9F8F6)
4. **DO NOT use fast animations** — Minimum 500ms for interactions, 1500-2000ms for images. Luxury is deliberate and slow.
5. **DO NOT use vibrant colors** — Stick to monochromatic palette with gold (#D4AF37) as only accent
6. **DO NOT center everything** — Use asymmetry, offset columns, bottom-left alignment. Break the grid intentionally.
7. **DO NOT overcrowd spacing** — More space is better. If it feels too airy, you're on the right track. Mobile: py-20, Desktop: py-32.
8. **DO NOT use decorative fonts** — Only Playfair Display (serif) and Inter (sans-serif). No script or display fonts.
9. **DO NOT use icons prominently** — If needed, use lucide-react with thin strokes (1-2px), sparingly. Icons are functional, not decorative.
10. **DO NOT make gold dominant** — Gold is an accent for hover/focus states and specific emphasis, not a primary color
11. **DO NOT use small images** — Images should be large and prominent, portrait aspect ratios (3:4, 4:5) with shadows and inner borders
12. **DO NOT use tight tracking on body text** — Only uppercase labels get wide tracking (0.2-0.3em). Body text uses default tracking.
13. **DO NOT skip the grayscale filter** — All images must default to grayscale. Color is the reward on hover.
14. **DO NOT use generic mobile layouts** — Maintain the core aesthetic on mobile with proper scaling, not generic stacking

## Animation & Motion (Cinematic Timing)

**Philosophy:** All motion should feel deliberate, slow, and expensive. Nothing snaps or jumps. Think of camera movements in luxury fashion videos—smooth, gradual, cinematic.

**Timing:**
- **Button Interactions**: \`duration-500\` (500ms)
- **Color Transitions**: \`duration-700\` (700ms)
- **Image Effects**: \`duration-[1500ms]\` to \`duration-[2000ms]\` (1500-2000ms)
- **Background Transitions**: \`duration-700\` (700ms)

**Easing Functions:**
- **Default**: \`ease-out\` for most interactions
- **Custom**: \`cubic-bezier(0.25, 0.46, 0.45, 0.94)\` for smooth luxury feel (use in Tailwind with arbitrary values)
- **Never**: \`ease-in-out\` or \`ease-in\` — These feel too mechanical

**Transition Properties:**
- Combine multiple properties: \`transition-all\` or specific \`transition-[colors,transform]\`
- Image transforms: Combine \`scale\` (1 to 1.05) with \`grayscale\` (1 to 0) in same transition
- Button fills: Use transform on absolute positioned overlay rather than background color change

**Hover Effects:**
- Delay feels intentional — user must pause on element for effect to complete
- Multiple effects layer together (scale + color + grayscale) for richness
- Text color changes are instant or faster (300ms) while backgrounds are slower

## Accessibility Considerations

**Contrast:**
- Charcoal (#1A1A1A) on Alabaster (#F9F8F6): 12.6:1 — Excellent (AAA)
- Warm Grey (#6C6863) on Alabaster: 4.8:1 — Good for secondary text (AA)
- Gold (#D4AF37) on Charcoal: 5.2:1 — Sufficient for accents (AA)
- White on Charcoal: 14.5:1 — Excellent (AAA)

**Focus Indicators:**
- Use \`focus-visible:ring-1\` or \`focus-visible:border-[color]\` for keyboard navigation
- Gold accent on focus makes interactive elements clear
- Never remove focus indicators — just make them elegant

**Motion Preferences:**
- Respect \`prefers-reduced-motion\` for users with vestibular disorders
- Reduce animation durations to 0ms or use simpler transitions
- Keep color changes but remove transforms and scales

**Typography:**
- Large body text size (16-18px base) ensures readability
- High contrast ratio for primary text
- Generous line-height (1.625) improves readability
- Avoid justified text — use left alignment

**Interactive Areas:**
- Buttons have minimum 48px height (h-12) for touch targets
- Adequate padding creates larger clickable areas
- Spacing between interactive elements prevents mis-taps

## Implementation Notes

**Tech Stack:**
- Tailwind CSS v4 for all styling with custom color values
- Google Fonts for "Playfair Display" and "Inter"
- Lucide React for icons (if needed, use sparingly with thin stroke-width)
- Custom CSS for noise texture (SVG data URI) and vertical writing mode

**Responsive Strategy:**
- **Mobile (< 768px)**:
  - Stack all columns vertically
  - Reduce padding: \`px-8\`, \`py-20\` (instead of px-16, py-32)
  - Scale down typography: \`text-4xl\` headlines (instead of text-6xl), \`text-xl\` quotes (instead of text-3xl)
  - Reduce gaps: \`gap-8\`, \`gap-12\` (instead of gap-12, gap-24)
  - Stats: 2 columns, smaller text (text-3xl instead of text-5xl)
  - Hero: Smaller type scale \`text-5xl\` (instead of text-9xl), smaller line and decorative elements
  - Testimonials: Smaller left padding \`pl-6\` (instead of pl-8)
  - Footer CTA: Stack email input and button vertically with \`flex-col\` on small screens
  - Maintain core aesthetic: grayscale images, gold accents, slow animations

- **Tablet (768px - 1024px)**:
  - Begin introducing grid layouts (2-3 columns)
  - Medium padding: \`px-8 md:px-16\`, \`py-20 md:py-32\`
  - Typography scales up: \`text-5xl md:text-6xl\`
  - Complex layouts still stack (testimonials, FAQ)

- **Desktop (> 1024px)**:
  - Full 12-column asymmetric grid with offset columns
  - Maximum padding and spacing
  - Visible vertical gridlines (4 lines at column boundaries)
  - Vertical writing mode text visible
  - Full typographic scale (text-9xl for hero)

**Performance:**
- Use CSS transforms (translate, scale) for animations — GPU accelerated
- Grayscale filter is performant in modern browsers
- Fixed gridlines and noise overlay use minimal resources
- Shadows use rgba with low opacity for minimal render cost

**Code Organization:**
- Extract color values to config/constants for consistency
- Create button component with variant system (primary/secondary/ghost/link) and shadow on primary
- Create card component with border-top pattern and shadow evolution built in
- Create input component with underline-only styling and italic placeholder
- Add fadeIn keyframe animation for FAQ accordion content`}
(total 51200 chars)

========== art-deco ==========
--- record 0 (len 77) ---
{id:"art-deco",name:"Art Deco",path:"/art-deco",mode:"dark",accent:"#D4AF37"}
(total 77 chars)
--- record 1 (len 17386) ---
{id:"art-deco",name:"Art Deco",mode:"dark",fontType:"serif",description:"1920s Gatsby elegance, geometric precision, metallic gold accents, architectural symmetry, luxury heritage",layoutIdeas:{hero:"Centered symmetrical composition with massive uppercase serif headline. Radial sunburst gradient emanates from center. Vertical gold line divider adds architectural height. CTAs arranged horizontally with sharp borders and glow effects.",stats:"Four-column grid with bordered boxes featuring stepped corner decorations. Large gold numbers with uppercase labels. Subtle hover state intensifies gold borders.",productDetail:"Centered heading with two-column text layout below. Left-border accent on paragraphs. Contained in darker card background for depth separation.",features:"Three-column responsive grid. Cards feature rotated diamond icon containers, corner decorative elements, and lift-on-hover micro-interaction. Icons rotate back on hover for theatrical effect.",blog:"Three-column grid. Images with double-frame treatment (outer border + inner inset border). Grayscale images with gold overlay on hover. Film noir aesthetic with high contrast typography.",howItWorks:"Vertical timeline with central gold divider line. Diamond-shaped step markers with Roman numerals. Alternating left-right text layout creates visual rhythm. Steps use geometric precision.",benefits:"Two-column grid with large bordered cards. Corner flourishes (top-left, bottom-right). Rotated diamond checkmarks. Background darkens slightly on hover for depth.",testimonials:"Three-column grid. Giant quotation mark watermark in background. Rotated diamond avatar frames with counter-rotated images. Author details with role in gold.",pricing:"Three columns with center tier elevated and highlighted. Gold badge floats above popular plan. Feature lists with gold checkmarks. Sharp geometric borders throughout.",faq:"Clean accordion with full-width questions. Chevron indicators. Expanded answers show left gold border accent. Smooth height transitions.",footer:"Five-column grid (company spans wider on mobile). Large uppercase serif brand. Gold headings with muted link text. Border separator above social icons."},content:`# Design Style: Art Deco (The "Gatsby" Aesthetic)

## 1. Design Philosophy

Art Deco is the visual embodiment of the Roaring Twenties—an era of jazz, prosperity, and unbridled optimism. This design style captures **opulence, mathematical precision, and architectural grandeur**. It celebrates luxury through geometry rather than organic forms, creating a aesthetic that feels both **timeless and theatrical**.

### The DNA of Art Deco

This is not minimalism. Art Deco is **maximalist restraint**—every element is intentional, ornamental, yet precisely placed. The style rejects soft curves in favor of **hard edges, sharp angles, and geometric repetition**. It's the visual language of the machine age meeting high society, where **structure equals beauty**.

The vibe is "The Great Gatsby" meets Fritz Lang's "Metropolis"—champagne towers in skyscraper ballrooms, chrome elevator grilles, sunburst marquees, and zigzag moderne facades. It feels **expensive, confident, and timeless**.

### Core Principles

**Geometry as Decoration:**
Art Deco worships mathematical forms. Triangles, chevrons, trapezoids, stepped pyramids (ziggurat shapes), sunbursts, and fan motifs dominate. These aren't random—they create **visual rhythm through repetition**. Borders aren't just lines; they're multi-layered frames. Corners feature decorative cuts or stepped embellishments. Every surface is an opportunity for geometric ornamentation.

**Contrast as Drama:**
This style thrives on **extreme tonal contrast**. Deep, obsidian blacks set against radiant metallic golds create instant luxury. There's no muddy middle ground—elements are either in shadow or bathed in light. This high contrast extends to typography (massive display faces vs refined body text) and spatial hierarchy (dense ornamentation vs deliberate negative space).

**Symmetry and Balance:**
Art Deco layouts favor **central axes and bilateral symmetry**. Content radiates from centerlines. Column counts are even. Decorative elements mirror across vertical dividers. This symmetry isn't rigid—it's **ceremonial**, like the entrance to a grand hotel or the facade of a cinema palace.

**Verticality and Aspiration:**
Inspired by skyscrapers, Art Deco emphasizes **upward movement**. Vertical lines, tall narrow proportions, and stacked elements create a sense of height and ambition. Sections feel like floors of a building. Dividers act like architectural columns. The design **reaches skyward**.

**Material Luxury:**
Even in digital form, Art Deco evokes **tactile richness**—polished brass, etched glass, lacquered wood, terrazzo floors. Metallic sheens, subtle glows, and layered shadows simulate these premium materials. The style says "this is crafted, not mass-produced."

**Theatricality:**
Art Deco doesn't whisper—it **announces**. Transitions are dramatic. Hover states glow. Headings demand attention with all-caps, wide tracking, and imposing scale. Interactive elements feel like mechanical buttons on a vintage elevator panel—precise, satisfying, engineered.

### Emotional Resonance

When executed correctly, Art Deco should evoke:
- **Confidence** - Nothing tentative or apologetic
- **Heritage** - Rooted in a golden age of design
- **Exclusivity** - Premium, members-only, VIP access
- **Optimism** - The future was bright in 1925, and it still is
- **Sophistication** - Educated taste, cultural refinement

This isn't a style for soft SaaS startups or friendly consumer apps. It's for **luxury brands, premium services, cultural institutions, and products that want to feel like heirlooms**.

### Key Visual Signatures

1. **Stepped Corners** - Ziggurat-style cuts on cards and containers
2. **Rotated Diamonds** - 45-degree squares as frames and accents
3. **Sunburst Radials** - Emanating rays from focal points
4. **Metallic Gold (#D4AF37)** - Used sparingly but decisively on obsidian black
5. **Double Borders** - Frames within frames for depth
6. **Roman Numerals** - Classical sophistication in numbering
7. **All-Caps Typography** - Display text in uppercase with generous tracking
8. **Linear Patterns** - Repeating diagonal grids, chevrons, or fan motifs at low opacity
9. **Glow Effects** - Soft halos around gold elements, never harsh drop shadows
10. **Corner Embellishments** - Decorative L-brackets or lines at card corners

The goal is instant recognition: when someone sees this design, they should immediately think "Art Deco" without being told.

## 2. Design Token System

### Colors (Dark Luxury Palette)
*   **Background**: \`#0A0A0A\` (Obsidian Black) - The deep void.
*   **Foreground**: \`#F2F0E4\` (Champagne Cream) - For primary text, warm and readable.
*   **Card Background**: \`#141414\` (Rich Charcoal) - Slightly lighter than bg for depth.
*   **Primary Accent (Gold)**: \`#D4AF37\` (Metallic Gold) - The core luxury element.
*   **Secondary Accent**: \`#1E3D59\` (Midnight Blue) - For subtle depth or inactive states.
*   **Border**: \`#D4AF37\` (Gold) - Borders are celebrated, not hidden.
*   **Muted**: \`#888888\` (Pewter) - For secondary text.

### Typography
*   **Headings**: **"Marcellus"** (Google Font) or "Italiana". These have the classic Roman structures with Art Deco flair.
*   **Body**: **"Josefin Sans"** (Google Font). Geometric, vintage feel, but readable.
*   **Scaling**: High contrast. Headings should be imposing.
    *   H1: \`text-6xl\` or \`text-7xl\`, uppercase, generous letter-spacing (\`tracking-widest\`).
    *   Body: \`text-lg\`, comfortable \`leading-relaxed\`.

### Radius & Border
*   **Radius**: **Strictly \`0px\`** or very specific \`2px\` for softness. Art Deco is about sharp lines.
*   **Border Width**: Thin, precise lines (\`1px\`) or double lines (\`3px\` double style) are common.
*   **Stepped Corners**: Use CSS clip-paths or pseudo-elements to create "stepped" corners (ziggurat shape) on cards.

### Shadows & Effects
*   **Glow**: Instead of soft drop shadows, use "glows" or hard offsets.
    *   \`box-shadow: 0 0 15px rgba(212, 175, 55, 0.2)\` (Gold Glow).
*   **Gradients**: Use linear gradients that mimic metallic sheen on buttons or borders (e.g., Gold Light to Gold Dark).
*   **Textures**: A subtle "grain" or "noise" overlay on the background adds vintage film quality.

## 3. Component Stylings

### Buttons (Precision Instruments)
Buttons in Art Deco are **architectural elements**, not soft pills. They command attention and provide satisfying tactile feedback.

**Structure:**
- Sharp corners (\`rounded-none\`) or minimal softness (\`rounded-sm\` at 2px max)
- Minimum height of 48px (h-12) for touch accessibility
- All-caps text with wide tracking (\`tracking-widest\` or \`tracking-[0.2em]\`)
- 2px borders that glow on hover

**Variants:**
- **Default**: Transparent background, gold border (2px), gold text. Hover: gold background, black text, intensified glow (\`shadow-[0_0_20px_rgba(212,175,55,0.4)]\`)
- **Solid**: Gold background, black text. Hover: lighter gold (\`#F2E8C4\`) for brightness shift
- **Outline**: Thin gold border (1px), transparent background. Hover: midnight blue fill (\`#1E3D59\`)

**Interaction:**
- Transition duration: 300-500ms for theatrical effect
- Glow effect increases on hover (subtle shadow-based halo)
- No rounded corners—maintain geometric precision

### Cards (Geometric Containers)
Cards are **framed exhibits**, each one a miniature architectural facade.

**Structure:**
- Background: Rich charcoal (\`#141414\`) for depth against obsidian black page
- Border: Full 1px gold border at 30% opacity, increases to 100% on hover
- Corner decorations: Small L-shaped brackets at opposite corners (top-right + bottom-left OR top-left + bottom-right)
- Header separator: Bottom border on card header at 20% gold opacity

**Decorative Elements:**
- Stepped corners using pseudo-elements with 2px borders
- Corner embellishments positioned absolutely at 4-8px inset
- Optional: diagonal corner cut using \`clip-path\` for advanced cards

**Interaction:**
- Subtle lift on hover: \`-translate-y-2\` with 500ms duration
- Border opacity intensifies from 30% to 100%
- Corner decorations transition from 50% to 100% opacity

**Card Internal Hierarchy:**
- CardHeader: \`p-6\` with bottom border separator
- CardTitle: Display font, gold color (\`#D4AF37\`), 2xl, uppercase, wide tracking
- CardDescription: Body font, muted gray (\`#888888\`), normal case
- CardContent: \`p-6\` spacing

### Inputs (Underlined Elegance)
Inputs embrace **minimalism within maximalism**—no background boxes, just refined underlines.

**Structure:**
- Transparent background (\`bg-transparent\`)
- Bottom border only: 2px solid gold (\`#D4AF37\`)
- No side or top borders—emphasizes horizontal flow
- Height: \`h-12\` (48px) for touch accessibility
- Padding: \`px-3 py-2\` for comfortable text entry

**Typography:**
- Font: Body sans-serif (Josefin Sans)
- Text color: Champagne cream (\`#F2F0E4\`)
- Placeholder: Muted gray (\`#888888\`)

**Focus State:**
- Border color brightens to lighter gold (\`#F2E8C4\`)
- Bottom shadow appears: \`shadow-[0_4px_10px_rgba(212,175,55,0.2)]\`
- Smooth transition: \`transition-all\`
- No ring, only the enhanced underline

**Label Pattern:**
- Uppercase, small font size (xs or sm)
- Gold color for active state
- Positioned above input or floating label pattern

## 4. Non-Generic Bold Choices

These mandatory elements prevent the design from looking like default Tailwind or generic templates:

**1. Diagonal Crosshatch Background Pattern**
Apply a repeating diagonal grid pattern to the main background at 3-5% opacity. Use CSS \`repeating-linear-gradient\` at 45° and -45° angles with gold lines. This subtle texture adds vintage print quality.

**2. Rotated Diamond Containers**
Icons and avatars sit inside 45-degree rotated squares (\`rotate-45\`). The content inside counter-rotates (\`-rotate-45\`) to remain upright. This creates instant Art Deco recognition.

**3. Roman Numerals for Numbering**
Use I, II, III, IV instead of 1, 2, 3, 4 for steps, tiers, or lists. Display them in the serif display font for classical elegance.

**4. Stepped Corner Decorations**
Add small L-shaped border elements at opposite corners of cards and containers. Use absolute positioning with 2-4px borders on two sides only (e.g., \`border-t border-l\` for top-left corner).

**5. Double-Frame Images**
Never use plain images. Wrap in:
- Outer border container with gold border
- Inner inset div with thick dark border (creates frame-within-frame)
- Apply grayscale filter by default, remove or add gold overlay on hover

**6. Sunburst Radial Gradients**
Use \`radial-gradient\` with gold at 10-20% opacity emanating from key focal points (especially hero section). This creates the iconic Art Deco sunburst effect.

**7. Section Dividers with Decorative Lines**
Section headings include horizontal gold lines above and below the text (e.g., \`h-px w-24\` dividers). These are never full-width—they're measured, balanced accents.

**8. Vertical Divider Lines**
Use absolute-positioned vertical lines (\`w-px h-full\`) to create column separation or architectural height. These should be gold at low opacity.

**9. Glow Effects Over Drop Shadows**
Replace traditional drop shadows with box-shadow glows: \`0 0 15px rgba(212,175,55,0.2)\`. This simulates neon or backlit signage from the 1920s.

**10. All-Caps Display Typography with Extreme Tracking**
Headings must be uppercase with \`tracking-widest\` (0.2em). This isn't optional—it's fundamental to the style's voice.

## 5. Layout & Spacing

**Container Width:**
- Maximum content width: \`max-w-6xl\` for primary sections, \`max-w-7xl\` for wider grids (testimonials, blog)
- Hero and major sections: \`max-w-5xl\` for focused, centered content

**Spacing System:**
- Base unit: 8px (Tailwind's default)
- Section padding: \`py-32\` (128px) for generous breathing room
- Card padding: \`p-8\` (32px) for comfortable content spacing
- Grid gaps: \`gap-8\` (32px) between cards and columns

**Grid Philosophy:**
Art Deco is mathematically precise. Use even column counts:
- Features: 3 columns (lg), 2 columns (md), 1 column (base)
- Testimonials: 3 columns (lg), 2 columns (md), 1 column (base)
- Pricing: 3 columns, equal width
- Benefits: 2 columns (md), 1 column (base)
- Footer: 5 columns (lg) with company info spanning wider

**Alignment:**
- Centered axis for hero, headings, and CTAs
- Justified or centered text for formal sections
- Alternating left-right patterns in timeline layouts (How It Works)

**Negative Space:**
Space is intentional, not accidental. Large gaps between sections (32-40px) create visual separation. White space around centered headings provides "stage presence."

## 6. Animation & Interaction

**Philosophy:**
Animations should feel **theatrical and mechanical**—like Art Deco elevator doors opening or stage curtains rising. Nothing bouncy or organic.

**Transition Timing:**
- Standard: \`duration-300\` (300ms) for quick feedback
- Theatrical: \`duration-500\` (500ms) for dramatic reveals
- Easing: \`ease-out\` or \`ease-in-out\` for smooth mechanical motion

**Hover States:**
- Cards: Lift upward (\`-translate-y-2\`) + border glow intensifies
- Buttons: Background color flip + glow expansion
- Links: Color shift to gold + subtle underline expansion
- Images: Scale slightly (\`scale-105\`) + overlay appearance

**Page Load Animations (Optional):**
- Sections slide up with fade: \`translate-y-8 opacity-0\` → \`translate-y-0 opacity-100\`
- Stagger delays for sequential reveal (100ms between elements)
- Hero elements can have a sunburst expand effect

**Interactive Micro-details:**
- FAQ chevrons rotate 180° on open
- Icon containers rotate from 45° to 0° on hover (then back)
- Gold lines can animate width from 0 to full on section scroll-into-view
- Button glows pulse subtly on focus state

## 7. Accessibility & Contrast

**Color Contrast:**
- Gold text (\`#D4AF37\`) on black (\`#0A0A0A\`): **Passes WCAG AA** at ~7:1 ratio
- For body text or smaller sizes, use champagne cream (\`#F2F0E4\`) for better readability
- Gold should be used for accents, headings, and borders—not long-form body text
- Muted text (\`#888888\`) on black: ~4.5:1 ratio, acceptable for secondary content

**Focus States:**
- Buttons: 2px gold ring with 2px offset (\`ring-2 ring-[#D4AF37] ring-offset-2 ring-offset-black\`)
- Links: Gold underline appears or thickens
- Inputs: Bottom border glows brighter with subtle shadow
- Interactive cards: Border intensifies rather than adding a ring

**Touch Targets:**
- Minimum button height: 48px (\`h-12\`)
- Minimum clickable area: 44x44px for mobile
- FAQ accordion buttons: Full-width with generous padding (\`p-6\`)
- Adequate spacing between interactive elements (min 8px gap)

**Keyboard Navigation:**
- Clear focus indicators on all interactive elements
- Focus follows visual hierarchy (top to bottom, left to right)
- Skip-to-content link for keyboard users (if header is complex)

**Screen Reader Considerations:**
- Decorative elements (corner brackets, divider lines) use \`aria-hidden="true"\`
- Images have descriptive alt text
- Icon buttons include accessible labels
- Form inputs have associated labels`}
(total 17386 chars)

========== neo-brutalism ==========
--- record 0 (len 93) ---
{id:"neo-brutalism",name:"Neo Brutalism",path:"/neo-brutalism",mode:"light",accent:"#FACC15"}
(total 93 chars)
--- record 1 (len 26311) ---
{id:"neo-brutalism",name:"Neo-brutalism",mode:"light",fontType:"sans-serif",description:"A raw, high-contrast aesthetic that mimics print design and DIY punk culture. Characterized by cream backgrounds, thick black borders (4px), hard offset shadows with zero blur, clashing vibrant colors (Hot Red, Vivid Yellow, Soft Violet), and Space Grotesk typography at heavy weights. Embraces asymmetry, rotation, sticker-like layering, and organized visual chaos.",layoutIdeas:{hero:"Asymmetric split with massive rotated headline text blocks. Left side has border-boxed text with different colors and rotations. Right side features a 'visual chaos' container with overlapping shapes and badges. CTAs use brutalist shadows that translate on hover. Fully responsive with stacked layout on mobile.",stats:"4-column brutalist grid (2 columns on tablet, 1 on mobile) with thick white borders on black background. Hover inverts to accent color. Each stat has oversized numbers (text-7xl), uppercase labels, and decorative bars. No icons, just raw numerical data.",features:"3-column grid (1 on mobile) of cards with thick black borders and 8px offset shadows. Icons enclosed in bordered, colored accent boxes. Card headers have numbered badges and border separators. Hover lifts cards upward with deeper shadows.",howItWorks:"3 centered boxes (stacked on mobile) connected by dashed line on desktop. Each step has a large rotated number badge at top with accent background and thick border. Hover rotates the badge further. Process badge at top with pill shape.",benefits:"Split 2-column (stacked on mobile). Left: vibrant red accent with radial dot pattern overlay, massive white text with text shadow, rotated white card for subtitle. Right: clean cream background with bold list items using square bullets that change color on hover.",pricing:"3-column card grid (1 on mobile) with massive hard shadows (12-16px). Highlighted plan scales up slightly and uses black header with white text. Price numbers are huge (text-6xl). Features use custom checkbox bullets. Decorative pattern border at top.",testimonials:"Infinite horizontal marquee (react-fast-marquee) with gradient fade edges. Cards are white with thick borders and large shadows. 5-star ratings as large text. Author section has bordered avatar and separate background.",faq:"Stacked accordion with details/summary. Each item is a thick-bordered card with shadow. Open state rotates the +/X icon and reveals border separator. Questions in bold uppercase. Answers on different background (neo-muted).",blog:"3-column grid (1 on mobile). Cards with thick borders. Images are grayscale with date badge overlay. Hover restores color and scales image. Title underlines on hover. Author section has border separator at bottom.",footer:"Yellow background with thick top border. Logo is rotated text block. Navigation links are bold uppercase with hover state that inverts to black background. Social icons in bordered squares with shadows."},content:"# Design Style: Neo-brutalism\n\n## Design Philosophy\n\n**Neo-brutalism (or Neu-Brutalism)** is the digital punk rebellion against the \"Corporate Memphis\" and polished \"Clean SaaS\" aesthetics that dominated the 2010s. While traditional Brutalism (architecture/early web) was utilitarian and drab, **Neo-brutalism** is vibrant, performative, and intentionally distinct. It combines the raw, unrefined structural honesty of brutalism with the high-saturation energy of Pop Art, the \"sticker\" culture of the early internet, and the rebellious spirit of DIY zine design.\n\n**Core DNA & Fundamental Principles:**\n\n1.  **Unapologetic Visibility (The Anti-Subtle)**: Modern design often tries to be invisible—borderless cards floating on gradients, soft shadows that barely exist, blur effects that obscure structure. Neo-brutalism rejects this entirely. It demands to be seen. Structure is not implied; it is **enforced with thick, hard-edged black lines** (`border-4` everywhere). Shadows are not simulated light diffusion; they are **solid blocks of ink** offset at 45-degree angles (8px, 12px, 16px offsets with zero blur). Every element has **visual weight and presence**.\n\n2.  **Digital Tactility (The Sticker Effect)**: The screen is treated not as a fluid glass surface, but as a **collage board or bulletin board**. Elements feel like physical stickers, paper cutouts, or printed cards layered on top of each other. They have \"physicality\"—buttons **press down mechanically** (translate X and Y to cover their shadow), cards **lift up physically** (translate up while shadow grows), and text blocks are **rotated like stickers slapped on at angles** (`rotate-1`, `-rotate-2`). This creates a tangible, almost sculptural interface.\n\n3.  **Organized Chaos (Controlled Messiness)**: The design embraces a \"planned messiness\" that looks spontaneous but is carefully orchestrated. We use **slight rotations** (`-rotate-2`, `rotate-1`, `rotate-3`) on containers and text to break the monotony of the grid. Elements **overlap intentionally** (floating decorative shapes, badges positioned absolutely). **Asymmetry is encouraged**—headlines split across lines with different colors and rotations, layouts favor 60/40 splits over perfect 50/50. Yet the underlying structure remains **rigid and functional** to ensure usability. It is \"ugly-cool\"—ugly by traditional polished standards, cool by rebellious intention.\n\n4.  **Default & Raw (Web 1.0 Homage)**: The aesthetic celebrates the \"default\" look of the web before CSS3 smoothed everything out. It uses **pure black** (`#000000`) for all borders and text—no subtle grays. It uses **high-saturation primary colors** (Hot Red `#FF6B6B`, Vivid Yellow `#FFD93D`, Soft Violet `#C4B5FD`) that feel like unmixed paint or highlighter markers. Typography is **bold and heavy** (font weights 700 and 900 only). The **cream background** (`#FFFDF5`) mimics aged paper or newsprint, rejecting stark white.\n\n5.  **Maximalism as Statement**: While modern design trends toward minimalism, neo-brutalism is **deliberately maximal**. More borders. More shadows. More uppercase text. More visual noise (halftone patterns, grid overlays, noise textures). This isn't visual clutter—it's **visual density** used to create energy and urgency.\n\n6.  **Irony & Confidence**: The style exudes a sense of irony and self-awareness. It says, \"I know this looks unpolished, and that's exactly why it's good.\" It requires **confidence** to pull off; there is no room for timidity in Neo-brutalism. It's anti-corporate, anti-smooth, anti-boring.\n\n7.  **Mechanical Interactivity**: Interactions feel **mechanical and satisfying**, not smooth and ethereal. Buttons don't fade or glow—they **click down** like physical switches. Hovers don't soften—they **snap** into place. Transitions are **fast** (`duration-100`, `duration-200`) and **direct**, creating a snappy, arcade-game-like responsiveness.\n\n**The Vibe & Emotional Tone**:\n*   **Nostalgic & Retro-Modern**: Channelling Y2K energy, 90s punk zines, DIY flyers, rave posters, and early web forums.\n*   **Energetic & Loud**: It **screams** rather than whispers. It grabs attention aggressively.\n*   **Playful yet Functional**: It uses **gamified interactions** (bouncy hovers, hard clicks, rotating badges) to make utilitarian software feel like a toy or game.\n*   **Anti-Corporate Authenticity**: It rejects the polished veneer of corporate design systems, embracing rawness and imperfection as honesty.\n*   **Confident & Bold**: Every design choice is **deliberate and exaggerated**. Nothing is subtle.\n\n**Visual Signatures (What Makes It Instantly Recognizable)**:\n*   **Hard Black Strokes**: The unifying visual element. **If it doesn't have a border, it doesn't exist.** `border-4` is the default. All borders are solid black.\n*   **Offset Hard Shadows**: Shadows are **solid rectangles** with zero blur, offset at 45-degree angles (bottom-right). Small: `4px 4px 0px 0px #000`. Medium: `8px 8px 0px 0px #000`. Large: `12px 12px 0px 0px #000`. Massive: `16px 16px 0px 0px #000`.\n*   **The \"Pop\" Palette**: Cream background (`#FFFDF5`) serves as a neutral canvas for **intense bursts of highlighter colors** (Red, Yellow, Violet). Black is the structural color. White is used for contrast panels.\n*   **Typography as Texture**: Massive, heavy fonts (**Space Grotesk at 900 weight**) often treated with text outlines (`-webkit-text-stroke: 2px black` with transparent fill) or highlighted by placing text inside bordered, colored boxes. **All caps** for emphasis. Extreme tracking (`tracking-tighter` for headlines, `tracking-widest` for labels).\n*   **Sticker Layering**: Text blocks, badges, and containers are **rotated and layered** like stickers on a laptop. Elements cast hard shadows onto elements \"below\" them.\n*   **Texture & Patterns**: Backgrounds aren't flat. Use **halftone dots** (radial gradients), **grid patterns** (linear gradient lines), **noise textures** (SVG filters), and **geometric overlays** to add visual richness without traditional depth.\n*   **Asymmetric Composition**: Deliberately **break the grid**. Headlines split unevenly. Sections use 60/40 or 70/30 splits. Elements float off-axis.\n\n**What Neo-Brutalism Is NOT**:\n*   **Not Minimal**: It's maximal and dense.\n*   **Not Smooth**: It's jagged, sharp, and angular.\n*   **Not Subtle**: It's loud, high-contrast, and in-your-face.\n*   **Not Polished**: It celebrates roughness and rawness.\n*   **Not Corporate**: It's rebellious and anti-establishment in its aesthetic DNA.\n\n## Design Token System (The DNA)\n\n### Colors (High Saturation Light Mode Palette)\nNeo-brutalism uses a **single, definitive light mode palette**. All colors are high-saturation and unapologetic.\n\n*   **Background (Canvas)**: `#FFFDF5` (Cream/Off-White)\n    *   A warm, paper-like background that mimics aged newsprint or recycled paper. Softer than stark white, more authentic.\n    *   Use: Main page background, card interiors, contrast panels.\n\n*   **Foreground (Ink)**: `#000000` (Pure Black)\n    *   The structural color. Used for ALL text, ALL borders, ALL shadows. No grays, no variations.\n    *   Use: Text, borders (`border-black`), shadows, icons.\n\n*   **Accent (Hot Red)**: `#FF6B6B`\n    *   Primary action color. Vibrant, energetic, attention-grabbing.\n    *   Use: Primary buttons (`bg-neo-accent`), hover states, important badges, call-to-action backgrounds.\n\n*   **Secondary (Vivid Yellow)**: `#FFD93D`\n    *   Secondary highlight color. Bright, cheerful, high-energy.\n    *   Use: Secondary buttons, badges, logo backgrounds, footer background, alternate section backgrounds.\n\n*   **Muted (Soft Violet)**: `#C4B5FD`\n    *   Tertiary color for depth and variation without clashing.\n    *   Use: Subtle backgrounds (`bg-neo-muted`), card headers, FAQ answer backgrounds, decorative elements.\n\n*   **White**: `#FFFFFF`\n    *   Used for high-contrast text on dark backgrounds (e.g., black sections, accent buttons).\n    *   Use: Text on black backgrounds, inverted buttons, contrast panels.\n\n**Color Usage Rules:**\n- **Never use subtle grays.** It's black or a color, never #333 or #666.\n- **High contrast is mandatory.** All text must pass WCAG AA on its background.\n- **Color blocking:** Sections alternate between cream, secondary, muted, and black to create visual rhythm.\n\n### Typography\n*   **Family**: `Space Grotesk` (Google Font: `font-family: 'Space Grotesk', sans-serif`)\n    *   A geometric sans-serif with quirky personality. Modern but not clinical. Bold enough to carry heavy weights.\n    *   Load via Google Fonts: `https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700;900&display=block`\n\n*   **Weights**: **Only heavy weights allowed.**\n    *   **Black (900)**: For all headings (h1, h2, h3). `font-black`\n    *   **Bold (700)**: For all body text, labels, buttons. `font-bold`\n    *   **Medium (500)**: Sparingly, only for subtle emphasis. `font-medium`\n    *   **Regular (400)**: Generally avoided. Lightness is forbidden in neo-brutalism.\n\n*   **Scale**:\n    *   Display: `text-8xl` to `text-9xl` (96px to 128px) for hero headlines.\n    *   Heading 2: `text-6xl` to `text-8xl` (60px to 96px) for section titles.\n    *   Heading 3: `text-4xl` to `text-5xl` (36px to 48px) for subsections.\n    *   Body Large: `text-2xl` to `text-3xl` (24px to 30px) for emphasis.\n    *   Body: `text-lg` to `text-xl` (18px to 20px) for readable text.\n    *   Small: `text-sm` to `text-base` (14px to 16px) for labels and metadata.\n\n*   **Styling Techniques**:\n    *   **Text Stroke (Display)**: Use `-webkit-text-stroke: 2px black` with `color: transparent` for massive hollow outlined text.\n    *   **Case**: Heavy use of **UPPERCASE** (`uppercase`) for headings, labels, buttons, and emphasis. Lowercase is acceptable for body text.\n    *   **Tracking**:\n        *   Headlines: `tracking-tighter` or `tracking-tight` for density.\n        *   Labels: `tracking-widest` or `tracking-[0.2em]` for emphasis.\n    *   **Line Height**: Tight leading. `leading-none` or `leading-[0.85]` for display. `leading-snug` or `leading-relaxed` for body.\n\n### Radius & Borders\n*   **Radius**: **Default is `0px` (sharp, angular corners).**\n    *   Exception: `rounded-full` ONLY for pill badges, circular stickers, or decorative shape elements.\n    *   Never use `rounded-md` or `rounded-lg`. It's either sharp or fully round.\n\n*   **Borders**: **Mandatory on every visual element.**\n    *   Default: `border-4` (4px solid black). This is the signature thickness.\n    *   Thin: `border-2` (2px) only for subtle separators or ghost buttons.\n    *   Thick: `border-8` (8px) for major section dividers or hero elements.\n    *   All borders: `border-black` (solid black, no transparency).\n\n### Shadows & Effects\n*   **Hard Shadows (The Signature)**: Offset, solid black shadows with **zero blur** and **zero spread**. Always bottom-right direction.\n    *   **Small**: `shadow-[4px_4px_0px_0px_#000]` or `box-shadow: 4px 4px 0px 0px #000`\n    *   **Medium**: `shadow-[8px_8px_0px_0px_#000]` or `box-shadow: 8px 8px 0px 0px #000`\n    *   **Large**: `shadow-[12px_12px_0px_0px_#000]` or `box-shadow: 12px 12px 0px 0px #000`\n    *   **Massive**: `shadow-[16px_16px_0px_0px_#000]` or `shadow-[20px_20px_0px_0px_#fff]` (for elements on black backgrounds)\n\n*   **Text Shadows**: Use for text on colored backgrounds.\n    *   `text-shadow: 4px 4px 0px #000` or `text-shadow: 6px 6px 0px #000`\n\n*   **Background Patterns & Textures** (Critical for depth):\n    *   **Halftone Dots**:\n        ```css\n        background-image: radial-gradient(#000 1.5px, transparent 1.5px);\n        background-size: 20px 20px;\n        ```\n    *   **Grid Pattern** (graph paper):\n        ```css\n        background-size: 40px 40px;\n        background-image: linear-gradient(to right, rgba(0, 0, 0, 0.1) 1px, transparent 1px),\n                          linear-gradient(to bottom, rgba(0, 0, 0, 0.1) 1px, transparent 1px);\n        ```\n    *   **Noise Texture** (SVG filter):\n        ```css\n        background-image: url(\"data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'%2F%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)'/%3E%3C/svg%3E\");\n        ```\n    *   **Radial Dots** (for backgrounds):\n        ```css\n        background-image: radial-gradient(circle, #000 2px, transparent 2.5px);\n        background-size: 30px 30px;\n        ```\n\n## Component Styling Principles\n\n### Buttons\n*   **Shape**: Rectangular with sharp corners. Default height: `h-12` to `h-14`. No rounding.\n*   **Style**:\n    *   Primary: `bg-neo-accent` (red) with `border-4 border-black`.\n    *   Secondary: `bg-neo-secondary` (yellow) with `border-4 border-black`.\n    *   Outline: `bg-white` with `border-4 border-black`.\n    *   Ghost: `border-2 border-transparent` that becomes `border-black` on hover.\n*   **Typography**: `font-bold text-sm uppercase tracking-wide` (all caps, bold, spaced).\n*   **Shadow**: Hard shadow `shadow-[4px_4px_0px_0px_#000]` or `shadow-[6px_6px_0px_0px_#000]`.\n*   **Interaction (Critical)**: **\"Push\" effect.** On `:active`, translate the button to cover its shadow:\n    ```css\n    active:translate-x-[2px] active:translate-y-[2px] active:shadow-none\n    ```\n    This creates a mechanical \"click down\" feel, like a physical button.\n*   **Hover**: Slight background darkening or shadow intensification. Fast transition (`duration-100`).\n\n### Cards / Containers\n*   **Structure**: `bg-white` with `border-4 border-black` and sharp corners (`rounded-none`).\n*   **Shadow**: Deep hard shadows (`shadow-[8px_8px_0px_0px_#000]` to `shadow-[12px_12px_0px_0px_#000]`).\n*   **Hover (Lift Effect)**: Translate card **upward** and **increase shadow size**:\n    ```css\n    hover:-translate-y-1 hover:shadow-[10px_10px_0px_0px_#000]\n    ```\n    or\n    ```css\n    hover:-translate-y-2 hover:shadow-[16px_16px_0px_0px_#000]\n    ```\n    This makes the card feel like it's physically lifting off the page.\n*   **Headers**: Often have colored backgrounds (`bg-neo-muted/20` or `bg-neo-secondary`) with `border-b-4 border-black` separator.\n\n### Inputs\n*   **Style**: Thick black borders (`border-4 border-black`). Sharp corners. `bg-white` default.\n*   **Typography**: Large, bold text (`font-bold text-lg` or `text-xl`). Placeholder is `placeholder:text-black/40`.\n*   **Focus**: **Background color change** instead of ring:\n    ```css\n    focus-visible:bg-neo-secondary focus-visible:shadow-[4px_4px_0px_0px_#000] focus-visible:outline-none focus-visible:ring-0\n    ```\n    Input becomes yellow and gains a shadow when focused. No soft glow.\n*   **Height**: `h-14` to `h-20` for touch-friendly sizing.\n\n### Navigation\n*   **Logo**: Bordered box (`border-4 border-black`) with accent background. Uppercase, black font.\n*   **Links**: Bold, uppercase text. Hover state adds border and background:\n    ```css\n    hover:border-black hover:bg-neo-accent hover:px-2 hover:shadow-[4px_4px_0px_0px_#000]\n    ```\n*   **Mobile Menu**: Hamburger button as bordered square with shadow. Menu slides in with stacked bordered buttons.\n\n### Badges\n*   **Shape**: Pill (`rounded-full`) or square (`border-4`).\n*   **Style**: Colored background (`bg-neo-accent` or `bg-neo-secondary`) with thick border and shadow.\n*   **Typography**: `font-black text-sm uppercase tracking-widest`.\n*   **Usage**: Positioned absolutely over elements (`:absolute top-4 left-4`), rotated (`rotate-3`), or inline.\n\n## Layout Principles\n\n*   **Container Width**: Use `container mx-auto` with `max-w-7xl` or `max-w-6xl` for focused content width.\n*   **Spacing**: Dense 8px base grid. Sections have `py-16` to `py-32` vertical padding. Content spacing: `gap-8` to `gap-12`.\n*   **Rotation (Sticker Effect)**: Use slight rotations on containers and text blocks to break grid monotony:\n    *   `rotate-1` (1 degree), `-rotate-2` (-2 degrees), `rotate-3` (3 degrees).\n    *   Apply to headline spans, cards, badges, and CTAs.\n*   **Marquee**: Use horizontal scrolling marquees (e.g., `react-fast-marquee`) as:\n    *   Trust indicators at page top.\n    *   Testimonial carousels.\n    *   Section dividers with repeated text.\n*   **Overlapping**: Allow elements to overlap using absolute positioning:\n    *   Floating decorative shapes (`absolute top-20 left-0`).\n    *   Badges positioned on corners of cards (`-top-6 -right-6`).\n    *   Background text as texture (`absolute opacity-10 text-9xl`).\n*   **Visual Chaos Zones**: Intentionally create \"busy\" areas (like Hero right side) with:\n    *   Stacked geometric shapes.\n    *   Multiple rotated badges.\n    *   Large background numbers or text.\n*   **Asymmetry**: Avoid perfect symmetry. Use 60/40 splits, offset columns, and staggered grids.\n\n## The \"Bold Factor\" (Non-Genericness)\n\nThese techniques ensure the design is unmistakably neo-brutalist and never generic:\n\n1.  **Text Stroke for Display Typography**: Use `-webkit-text-stroke: 2px black` with `color: transparent` for massive hollow outlined headings. Overlay with solid version for depth effect.\n\n2.  **Sticker Layering**: Elements feel like physical stickers:\n    *   Rotated text blocks with borders and shadows.\n    *   Absolutely positioned badges that overlap content.\n    *   Multiple \"layers\" created with shadows.\n\n3.  **Interactive Physics**: Elements must physically move:\n    *   Buttons: **Push down** on click (`active:translate-x-[2px] active:translate-y-[2px]`).\n    *   Cards: **Lift up** on hover (`hover:-translate-y-2`).\n    *   Badges: **Rotate further** on hover (`hover:rotate-12`).\n\n4.  **Primitive Shape Motifs**: Heavy use of:\n    *   **Stars** (5-point, `<Star />` from lucide-react). Use as decorative elements, ratings, and dividers.\n    *   **Arrows** (`<ArrowRight />`) for directional cues.\n    *   **Basic Shapes**: Squares, circles, rectangles as decorative floaters.\n\n5.  **Thick Border Everywhere**: If an element doesn't have a visible border, it feels wrong. Even whitespace is bordered.\n\n6.  **Color Blocking**: Large sections with solid color backgrounds (red, yellow, violet, black) to create high-contrast rhythm.\n\n7.  **Texture Overlays**: Never leave backgrounds flat. Always add halftone, grid, or noise.\n\n## Anti-Patterns (What to Avoid)\n\nThese techniques would break the neo-brutalist aesthetic:\n\n*   **Blur Effects**: No `blur()`, no `backdrop-blur`, no soft `box-shadow` with blur radius. All shadows must be hard.\n*   **Opacity/Transparency**: Avoid alpha transparency on backgrounds (except for texture overlays at low opacity).\n*   **Smooth Gradients**: No `bg-gradient-to-r` fades. Use hard color stops or patterns instead.\n*   **Rounded Corners (Mid-Range)**: Avoid `rounded-md`, `rounded-lg`, `rounded-xl`. It's either `rounded-none` (sharp) or `rounded-full` (pill/circle).\n*   **Subtle Grays**: No `#333`, `#666`, `#999`. Use pure black or a color.\n*   **Soft Animations**: No `ease-in-out` or slow durations. Use `ease-linear` or `ease-out` with fast durations.\n*   **Minimalist Whitespace**: Don't leave large empty areas. Fill with texture, patterns, or decorative elements.\n\n## Animation & Motion\n\n*   **Feel**: Bouncy, playful, mechanical, arcade-like.\n*   **Transition Speed**: Fast and snappy.\n    *   Buttons: `duration-100` (100ms).\n    *   Cards/Hovers: `duration-200` or `duration-300` (200-300ms).\n*   **Easing**: `ease-linear` for mechanical feel, `ease-out` for natural deceleration. Avoid `ease-in-out`.\n*   **Hover Interactions**:\n    *   Buttons: Background darken, then press on click.\n    *   Cards: Translate upward (`-translate-y-2`) and shadow deepens.\n    *   Links: Add border and background, snap into place.\n*   **Looping Animations**:\n    *   Slow spins on decorative stars (`animate-spin-slow`, custom duration 10s).\n    *   Pulsing on call-to-action elements (`animate-pulse`).\n    *   Bouncing on attention-grabbing badges (`animate-bounce`).\n*   **Custom Animations** (via CSS):\n    ```css\n    @keyframes spin-slow {\n      from { transform: rotate(0deg); }\n      to { transform: rotate(360deg); }\n    }\n    .animate-spin-slow {\n      animation: spin-slow 10s linear infinite;\n    }\n    ```\n\n## Spacing, Layout & Iconography\n\n*   **Max-Width**: `max-w-7xl` or `max-w-6xl` for main content. Sections can be full-width with contained inner content.\n*   **Grid System**: Use Tailwind's grid (`grid-cols-1 md:grid-cols-2 lg:grid-cols-3`) with responsive breakpoints.\n*   **Spacing Scale**: Dense. `gap-6` to `gap-12` between elements. `py-16` to `py-32` for section padding.\n*   **Iconography**: Import from `lucide-react`.\n    *   Style: `stroke-[3px]` or `stroke-[4px]` for thick, bold strokes.\n    *   Size: `h-8 w-8` or larger (`h-12 w-12`) for emphasis.\n    *   Placement: Inside bordered boxes (`border-4 border-black bg-neo-accent p-4`).\n    *   Fill: Use `fill-black` or `fill-white` for solid icons.\n\n## Responsive Strategy\n\n*   **Mobile First**: Design starts with mobile (`base`) and scales up.\n*   **Breakpoints**:\n    *   `sm:` (640px) - Small tablets\n    *   `md:` (768px) - Tablets\n    *   `lg:` (1024px) - Desktops\n    *   `xl:` (1280px) - Large desktops\n*   **Mobile Adaptations**:\n    *   **Typography**: Scale down (e.g., `text-4xl sm:text-6xl md:text-8xl`).\n    *   **Spacing**: Reduce padding (e.g., `p-8 sm:p-12 md:p-16`).\n    *   **Grids**: Stack to single column (`grid-cols-1 md:grid-cols-2 lg:grid-cols-3`).\n    *   **Shadows**: Reduce size on mobile (e.g., `shadow-[6px_6px_0px_0px_#000] sm:shadow-[8px_8px_0px_0px_#000]`).\n    *   **Navigation**: Hamburger menu with bordered button. Full-screen or slide-in drawer.\n    *   **Buttons**: Full width on mobile (`w-full sm:w-auto`).\n    *   **Touch Targets**: Minimum `h-14` for tappable elements.\n*   **Core Aesthetic Maintained**: Even on mobile, keep thick borders, hard shadows, and bold typography. Don't default to \"generic mobile\" design.\n\n## Accessibility & Best Practices\n\n*   **Contrast**: High contrast is built-in (black on cream, white on black, black on yellow). Ensure all color combinations pass WCAG AA (4.5:1 for normal text, 3:1 for large text).\n*   **Focus States**: Use thick focus rings:\n    ```css\n    focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2\n    ```\n    or background color change (yellow) for inputs.\n*   **Motion**: Respect `prefers-reduced-motion`:\n    ```css\n    @media (prefers-reduced-motion: reduce) {\n      .animate-spin-slow, .animate-bounce, .animate-pulse {\n        animation: none;\n      }\n    }\n    ```\n*   **Keyboard Navigation**: Ensure all interactive elements are keyboard-accessible. Tab order should be logical.\n*   **Screen Readers**: Use semantic HTML (`<button>`, `<nav>`, `<header>`, `<main>`). Add `aria-label` to icon-only buttons.\n*   **Touch Targets**: Minimum 44x44px (roughly `h-12` or `h-14` in Tailwind) for all tappable elements on mobile."}
(total 26311 chars)
