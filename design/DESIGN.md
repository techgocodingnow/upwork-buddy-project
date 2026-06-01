# UpworkBuddy Design System

Cloned from CodeBurn (AI Coding Cost Tracker) menu-bar app screenshot.

## Brand essence

Warm earth palette. Burnt orange accent on near-mono surface. Information-dense but breathable. No gradients on content, no glass. One subtle vertical bg gradient for depth.

## Color

| Token              | Hex / Value             | Use |
|--------------------|-------------------------|-----|
| `accent`           | `#C2611C`               | Primary CTA, active chip, brand mark, bar fills, dot bullets |
| `accent.deep`      | `#8B3A0F`               | Hero amount only |
| `accent.soft`      | `#D6986A`               | Soft illustrations, secondary fills |
| `accent.muted`     | `rgba(199,114,51,0.18)` | Hover wash, soft active |
| `bg.top`           | `#EDEAE6`               | Top of popover gradient |
| `bg.bottom`        | `#DCD8D4`               | Bottom of popover gradient |
| `surface`          | `#FAF8F4`               | White-ish chip / pill body |
| `chip.bg`          | `#D7D3CE`               | Inactive chip background |
| `track.bg`         | `#CCC7C0`               | Bar track for stats |
| `divider`          | `rgba(202,193,184,0.6)` | Hairlines |
| `text.primary`     | `#1C1C1C`               | Body, labels, values |
| `text.secondary`   | `#615B57`               | Subtitles, hours |
| `text.tertiary`    | `#8C857F`               | Footnotes, microcopy |

## Typography

System rounded body. Display weight 700 for hero amount. No custom font — keeps native feel on macOS.

| Role     | Size | Weight |
|----------|------|--------|
| Display  | 36   | 700    |
| Title    | 15   | 600    |
| Body     | 13   | 400/500 |
| Label    | 12   | 500    |
| Caption  | 11   | 400    |
| Micro    | 10   | 500 (uppercase, tracking) |

## Components

### Wordmark split
Brand name renders as two adjacent runs: neutral noun + accent suffix. `Upwork` (primary text) + `Buddy` (accent). Mirrors `Code` + `Burn`.

### Section dot
5pt accent circle before section labels. Replaces heavyweight headers — keeps rhythm calm.

### Pill chip group (period selector)
Inactive chip = neutral chip.bg. Active chip = white surface with subtle drop shadow. Active pill *does not* take accent fill — keeps focus on the data, not the chrome.

### Stat bar row
Horizontal capsule, 86×6pt. Track = `track.bg`. Fill = `accent`. Width proportional to row's value vs max in dataset.

### Bar chart
Rounded 1.5pt bars, `accent` at 0.85 opacity. Zero-height bars dimmed to 0.15. Single hairline midline at 50% height for visual reference. No axes, no labels — minimal.

### Icon button
24×24pt rounded chip background (`chip.bg` at 50%), 12pt SF Symbol in `text.secondary`. Used in header for hide/refresh/settings.

## Layout rhythm

Vertical stack with 14pt section gaps inside scroll content. 16pt horizontal padding. Header + footer hold 10pt vertical / 14pt horizontal padding with hairline dividers.

## What was deliberately *not* cloned

- "Star us on GitHub" footer banner — out of scope for this app.
- Multi-tab nav (Trend / Forecast / Pulse / Stats) — not enough data surfaces yet.
- Provider chips (`All / Claude / OpenCode`) — replaced by period selector.

## Tokens file

`design-tokens.json` — DTCG-flavored. Mapped 1:1 to Swift enum in [Theme.swift](Sources/UpworkBuddy/Util/Theme.swift).
