# Changelog

All notable changes to UpworkBuddy are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Add changes under **[Unreleased]** as you merge them. When you cut a release
via the **Tag** workflow, that section is promoted to a dated version heading
automatically and used as the GitHub Release notes.

## [Unreleased]

## [1.0.11] - 2026-06-26

### Fixed

- Keep Today Activity rows tied to actual worked time so posted invoice
  transactions do not show as `0h` projects for the day.

## [1.0.10] - 2026-06-26

### Changed

- Fetch the selected dashboard period first, then warm the other period caches
  in the background.

### Fixed

- Preserve cached previous-period totals so cached tabs keep the change badge
  accurate.
- Trigger goal celebrations when today's completed goal is first observed.

## [1.0.9] - 2026-06-25

### Changed

- Changed the Year dashboard chart to show monthly totals instead of daily bars.
- Cached period report data using the configured refresh interval so tab
  switches can render immediately when data is fresh.

### Fixed

- Replaced stale chart carry-over with skeleton loading when a period has no
  cached data yet.
- Stabilized the dashboard hero, chart, and Activity layout when switching
  quickly between Today and longer periods.
- Fixed progress indicators and chart hover tooltips so they stay inside their
  tracks and popover bounds.

## [1.0.8] - 2026-06-24

### Changed

- Highlighted the selected dashboard period tab with an accent-tinted
  background, border, and shadow.

## [1.0.7] - 2026-06-24

### Changed

- Changed Week, Month, and Year dashboard charts to use calendar periods:
  Monday-Sunday, current month, and current year.
- Localized the new calendar-period chart titles across bundled languages.

### Fixed

- Fixed goal celebrations and progress notifications so switching tabs into an
  already-complete period does not trigger random confetti.
- Loosened the dashboard goal ring spacing when progress reaches the goal.

## [1.0.6] - 2026-06-23

### Fixed

- Kept `100%` Activity percentages on one line without stealing space from
  earnings and hours columns.

## [1.0.5] - 2026-06-23

### Fixed

- Fixed missing translations across bundled languages and localized the weekly
  chart payout badge.
- Aligned the Week, Month, and Year hero, chart, and Activity rows around the
  same rolling ranges.
- Increased the menu popover height so more of the dashboard is visible before
  scrolling.

## [1.0.4] - 2026-06-23

### Fixed

- Fixed the release appcast publisher so new versions are prepended to the feed
  and published with the DMG media type.
- Documented the macOS App Management denial that can block Sparkle's
  Autoupdate helper after download.

## [1.0.3] - 2026-06-23

### Added

- Added a Display setting to choose whether Activity rows and chart hover
  breakdowns use project/contract titles or client/team names.
- Added instant hover tooltips for truncated Activity project names.

### Changed

- Updated Activity rows to show each project's share of total earnings.
- Improved settings readability for update, refresh interval, and exercise
  interval controls.

### Fixed

- Kept goal confetti out of the dashboard popover so celebrations only render
  on the monitor overlay.
- Aligned chart hover project names with the Activity list naming mode.

## [1.0.2] - 2026-06-02

### Added

- Landing page at the GitHub Pages site root (`index.html`), so the project
  URL no longer 404s. Served alongside the Sparkle appcast.

### Changed

- Rewrote the README for a cleaner open-source first impression.

## [1.0.0] - 2026-06-01

### Added

- Initial public release of UpworkBuddy.

### Changed

### Fixed
