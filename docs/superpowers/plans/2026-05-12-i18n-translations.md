# i18n Translations Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add AI-generated translations for all 14 languages so every user-facing string resolves in the user's chosen language.

**Architecture:** Add `vietnamese` case to `AppLanguage`, then dispatch 14 parallel agents — each writes one `Resources/<code>.lproj/Localizable.strings` file translating all keys from `en.lproj`. No call-site changes needed; `Bundle.module` resolution picks up new `.lproj` folders automatically via `.process("Resources")`.

**Tech Stack:** Swift, SwiftPM, Foundation `NSLocalizedString`, `.lproj` string catalogs

---

## File Map

| Action | File |
|--------|------|
| Modify | `Sources/UpworkBuddy/Models/AppLanguage.swift` |
| Create | `Sources/UpworkBuddy/Resources/vi.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/es.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/fr.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/de.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/it.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/pt-PT.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/pt-BR.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/ja.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/ko.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/zh-Hans.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/zh-Hant.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/uk.lproj/Localizable.strings` |
| Create | `Sources/UpworkBuddy/Resources/tr.lproj/Localizable.strings` |

---

### Task 1: Add Vietnamese to AppLanguage

**Files:**
- Modify: `Sources/UpworkBuddy/Models/AppLanguage.swift`

- [ ] **Step 1: Add the enum case**

In `Sources/UpworkBuddy/Models/AppLanguage.swift`, add after `case turkish = "tr"`:

```swift
case vietnamese = "vi"
```

- [ ] **Step 2: Add nativeName**

In the `nativeName` switch, add after the `.turkish` case:

```swift
case .vietnamese:           return "Tiếng Việt"
```

- [ ] **Step 3: Add englishName**

In the `englishName` switch, add after the `.turkish` case:

```swift
case .vietnamese:           return "Vietnamese"
```

- [ ] **Step 4: Add flag**

In the `flag` switch, add after the `.turkish` case:

```swift
case .vietnamese:           return "🇻🇳"
```

- [ ] **Step 5: Add resolve() prefix match**

In the `resolve()` method, before the final `let prefix = ...` line, add:

```swift
if lower.hasPrefix("vi") { return .vietnamese }
```

- [ ] **Step 6: Verify build compiles**

```bash
swift build 2>&1 | tail -5
```

Expected: `Build complete!` with no errors. If you see "switch must be exhaustive", you missed a case above.

- [ ] **Step 7: Commit**

```bash
git add Sources/UpworkBuddy/Models/AppLanguage.swift
git commit -m "feat(i18n): add Vietnamese language to AppLanguage"
```

---

### Task 2: Create Vietnamese translation file

**Files:**
- Create: `Sources/UpworkBuddy/Resources/vi.lproj/Localizable.strings`

**Rules for all translation tasks:**
- Keep every key verbatim (left side of `=`) — keys are English fallback.
- Preserve all format specifiers exactly: `%@`, `%d`, `%1$@`, `%2$@`, `%%`, etc.
- Do NOT translate: `Upwork`, `Buddy`, `UpworkBuddy`, `MIT License`, `GitHub`, `OAuth`, `YouTube`, `Spotify`, `SoundCloud`, `Vimeo`, `Mixcloud`, `v2`, `20-20-20`.
- Brand-adjacent strings like `"Upwork" = "Upwork";` stay identical.

- [ ] **Step 1: Create directory and file**

```bash
mkdir -p Sources/UpworkBuddy/Resources/vi.lproj
```

Then create `Sources/UpworkBuddy/Resources/vi.lproj/Localizable.strings` with:

```
/*
  Localizable.strings — Vietnamese (vi)
  Translated by AI. Community corrections welcome.
*/

// MARK: - Brand
"Upwork" = "Upwork";
"Buddy" = "Buddy";
"UpworkBuddy" = "UpworkBuddy";

// MARK: - Common actions
"Cancel" = "Hủy";
"Reset" = "Đặt lại";
"Add" = "Thêm";
"Submit" = "Gửi";
"Connected" = "Đã kết nối";
"Disconnected" = "Đã ngắt kết nối";
"Never" = "Không bao giờ";
"Coming soon" = "Sắp ra mắt";
"Quit" = "Thoát";
"Quit UpworkBuddy" = "Thoát UpworkBuddy";
"Settings" = "Cài đặt";

// MARK: - Period
"Today" = "Hôm nay";
"Week" = "Tuần";
"Month" = "Tháng";
"Year" = "Năm";

// MARK: - Metrics
"Hours" = "Giờ";
"Earnings" = "Thu nhập";
"target" = "mục tiêu";
"Session Reset" = "Bắt đầu mới";
"Enable notifications" = "Kỷ niệm cột mốc";
"Receive alerts when approaching usage limits" = "Nhận thông báo khi gần đạt mục tiêu hàng ngày";
"Enable progress notifications" = "Bật thông báo cột mốc";
"Remove %d%%" = "Xóa %d%%";
"Add custom threshold" = "Thêm ngưỡng tùy chỉnh";
"Notification sound" = "Âm thanh thông báo";
"Light" = "Sáng";
"Dark" = "Tối";
"Auto" = "Tự động";
"App appearance" = "Giao diện ứng dụng";
"Earnings target" = "Mục tiêu thu nhập";
"Hours target" = "Mục tiêu giờ";
"Custom threshold percent" = "Phần trăm ngưỡng tùy chỉnh";
"Remove custom threshold" = "Xóa ngưỡng tùy chỉnh";
"Remove %d percent threshold" = "Xóa ngưỡng %d phần trăm";
"%@ at %d percent" = "%@ ở %d phần trăm";
"Warning" = "Sắp đến rồi";
"High Usage" = "Gần tới đích!";
"Critical" = "Cố thêm chút nữa";
"Milestone" = "Cột mốc";
"%@ theme" = "Chủ đề %@";
"Reset to default" = "Đặt lại mặc định";
"Code Burn" = "Code Burn";
"Emerald" = "Emerald";
"Error: %@" = "Lỗi: %@";
"Upwork Buddy" = "Upwork Buddy";
"Loading" = "Đang tải";
"Updated %@" = "Cập nhật %@";
"Last updated %@" = "Cập nhật lần cuối %@";
"Name" = "Tên";
"Email" = "Email";
"%@: %@" = "%1$@: %2$@";
"Opens donation page in browser" = "Mở trang quyên góp trong trình duyệt";
"Star on GitHub" = "Đánh sao trên GitHub";
"Opens GitHub repo" = "Mở kho lưu trữ GitHub";
"Last %d days" = "%d ngày qua";
"Trend chart, last %d days, total %@" = "Biểu đồ xu hướng, %1$d ngày qua, tổng %2$@";
"Goal progress %d percent" = "Tiến độ mục tiêu %d phần trăm";
"Clear shortcut" = "Xóa phím tắt";
"Time period" = "Khoảng thời gian";

// MARK: - Settings categories
"General" = "Tổng quan";
"Goals" = "Mục tiêu";
"Display" = "Hiển thị";
"Language" = "Ngôn ngữ";
"Shortcuts" = "Phím tắt";
"Account" = "Tài khoản";
"Software Updates" = "Cập nhật phần mềm";
"Support" = "Hỗ trợ";
"About" = "Giới thiệu";
"About UpworkBuddy" = "Giới thiệu về UpworkBuddy";

"Refresh cadence and login behavior" = "Tần suất làm mới và hành vi đăng nhập";
"Hours and earnings targets, with notifications" = "Mục tiêu giờ và thu nhập, kèm thông báo";
"Theme, menu bar, and dashboard" = "Chủ đề, thanh menu và bảng điều khiển";
"Choose your preferred language" = "Chọn ngôn ngữ ưa thích";
"Global keyboard shortcuts" = "Phím tắt bàn phím toàn cầu";
"Connected Upwork session" = "Phiên Upwork đã kết nối";
"Keep your app up to date" = "Giữ ứng dụng cập nhật";
"Support the project" = "Ủng hộ dự án";

// MARK: - General page
"Sync" = "Đồng bộ";
"Startup" = "Khởi động";
"Launch at login" = "Khởi chạy khi đăng nhập";
"Open UpworkBuddy automatically when you sign in." = "Tự động mở UpworkBuddy khi bạn đăng nhập.";
"Refresh Interval" = "Chu kỳ làm mới";
"How often UpworkBuddy polls for new earnings" = "Tần suất UpworkBuddy kiểm tra thu nhập mới";
"Refresh interval" = "Chu kỳ làm mới";
"1 min" = "1 phút";
"30 min" = "30 phút";
"1 minute" = "1 phút";
"%d minutes" = "%d phút";

// MARK: - Goals page
"Targets" = "Mục tiêu";
"Notifications" = "Thông báo";
"Celebration" = "Chào mừng";
"Confetti when a goal is hit" = "Bắn pháo hoa khi đạt mục tiêu";
"Plays a quick burst when any target reaches 100%." = "Phát hiệu ứng nhanh khi bất kỳ mục tiêu nào đạt 100%.";
"Goal tracking" = "Theo dõi mục tiêu";
"Stay on pace day, week, month, and year. Get a banner when you cross a target." = "Theo dõi tiến độ ngày, tuần, tháng, năm. Nhận thông báo khi vượt mục tiêu.";
"Tracking off" = "Tắt theo dõi";
"Notifications on" = "Thông báo bật";
"Notifications blocked — check System Settings" = "Thông báo bị chặn — kiểm tra Cài đặt hệ thống";
"Awaiting permission" = "Đang chờ quyền";
"Notifications unavailable" = "Thông báo không khả dụng";
"Alert Thresholds" = "Cột mốc quan trọng";
"Custom Thresholds" = "Cột mốc tùy chỉnh";
"e.g. 50" = "vd. 50";
"Sound" = "Âm thanh";
"Tap a value to type directly" = "Nhấn vào giá trị để nhập trực tiếp";
"Enable tracking to edit" = "Bật theo dõi để chỉnh sửa";
"Get notified about usage milestones" = "Nhận thông báo khi đạt cột mốc";
"Goal celebration animation" = "Hoạt ảnh chào mừng mục tiêu";

// MARK: - Display page
"Theme" = "Chủ đề";
"Used across dashboard, menu bar, and settings" = "Áp dụng cho bảng điều khiển, thanh menu và cài đặt";
"Dashboard" = "Bảng điều khiển";
"Primary metric" = "Chỉ số chính";
"Renders large in the popover header." = "Hiển thị lớn trong tiêu đề popover.";
"Hide sensitive amounts" = "Ẩn số tiền nhạy cảm";
"Masks earnings, rates, and totals across the app." = "Ẩn thu nhập, tỷ lệ và tổng số trong toàn ứng dụng.";
"Currency" = "Tiền tệ";
"Display currency" = "Hiển thị tiền tệ";
"FX support coming in v2." = "Hỗ trợ ngoại hối sẽ có trong v2.";

// MARK: - Shortcuts page
"Bindings" = "Liên kết";
"Esc cancels recording" = "Esc hủy ghi";
"Global shortcuts" = "Phím tắt toàn cầu";
"Shortcuts work from any application. Each shortcut must include at least one modifier key (⌘, ⌥, ⌃, or ⇧)." = "Phím tắt hoạt động từ mọi ứng dụng. Mỗi phím tắt phải có ít nhất một phím bổ trợ (⌘, ⌥, ⌃ hoặc ⇧).";

// MARK: - Account page
"Connection" = "Kết nối";
"Signed in via OAuth." = "Đã đăng nhập qua OAuth.";
"Not connected." = "Chưa kết nối.";
"Danger zone" = "Vùng nguy hiểm";
"Disconnect" = "Ngắt kết nối";
"Sign out and clear cached earnings on this Mac." = "Đăng xuất và xóa dữ liệu thu nhập đã lưu trên Mac này.";

// MARK: - Menu bar
"Menu bar" = "Thanh menu";
"Choose which targets surface in the status bar" = "Chọn mục tiêu hiển thị trên thanh trạng thái";
"Today target" = "Mục tiêu hôm nay";
"Daily progress in the menu bar" = "Tiến độ hàng ngày trên thanh menu";
"Weekly target" = "Mục tiêu tuần";
"Weekly progress in the menu bar" = "Tiến độ hàng tuần trên thanh menu";
"Icon Style" = "Kiểu biểu tượng";
"Display Mode" = "Chế độ hiển thị";
"Display style" = "Kiểu hiển thị";
"Add a goal target" = "Thêm mục tiêu";

// MARK: - Menu bar enums
"Icon + value" = "Biểu tượng + giá trị";
"Icon only" = "Chỉ biểu tượng";
"Value only" = "Chỉ giá trị";
"Icon + primary metric" = "Biểu tượng + chỉ số chính";
"Icon + percentage" = "Biểu tượng + phần trăm";
"Icon + remaining" = "Biểu tượng + còn lại";
"Glyph only, no value" = "Chỉ ký hiệu, không có giá trị";
"Glyph + current value" = "Ký hiệu + giá trị hiện tại";
"Glyph + percent of goal" = "Ký hiệu + phần trăm mục tiêu";
"Glyph + amount left to goal" = "Ký hiệu + số còn lại đến mục tiêu";
"Value only, no glyph" = "Chỉ giá trị, không có ký hiệu";
"Battery (Classic)" = "Pin (Cổ điển)";
"Progress Bar" = "Thanh tiến trình";
"Percentage" = "Phần trăm";
"Icon with Bar" = "Biểu tượng có thanh";
"Compact" = "Thu gọn";
"Count vs goal" = "Số lượng so với mục tiêu";
"Show as percentage (e.g., 60%)" = "Hiển thị dưới dạng phần trăm (vd. 60%)";
"Show count vs goal (e.g., 5h/8h)" = "Hiển thị số lượng so với mục tiêu (vd. 5h/8h)";

// MARK: - Language page
"Select Language" = "Chọn ngôn ngữ";
"Language changes will take effect after restarting the app" = "Thay đổi ngôn ngữ sẽ có hiệu lực sau khi khởi động lại ứng dụng";

// MARK: - About page
"Reset App Data?" = "Đặt lại dữ liệu ứng dụng?";
"Signs you out, clears cached earnings, and resets all preferences on this Mac. The action cannot be undone." = "Đăng xuất, xóa dữ liệu thu nhập đã lưu và đặt lại tất cả tùy chọn trên Mac này. Hành động này không thể hoàn tác.";
"Version %@" = "Phiên bản %@";
"Check for Updates" = "Kiểm tra cập nhật";
"Created By" = "Được tạo bởi";
"Links" = "Liên kết";
"Send Feedback" = "Gửi phản hồi";
"Reset App Data" = "Đặt lại dữ liệu ứng dụng";
"MIT License • Open Source" = "MIT License • Open Source";

// MARK: - Login
"Track your active Upwork projects, hours, and earnings — right from the menu bar." = "Theo dõi dự án, giờ làm và thu nhập Upwork — ngay từ thanh menu.";
"Connect Upwork" = "Kết nối Upwork";
"A browser window will open for sign-in." = "Một cửa sổ trình duyệt sẽ mở để đăng nhập.";

// MARK: - Dashboard
"Show amounts" = "Hiện số tiền";
"Hide amounts" = "Ẩn số tiền";
"Refresh now" = "Làm mới ngay";

// MARK: - Feedback
"Help Us Improve" = "Giúp chúng tôi cải thiện";
"Your feedback shapes the future of this app" = "Phản hồi của bạn định hình tương lai của ứng dụng này";
"Role" = "Vai trò";
"Tell us anything — feedback, ideas, feature requests…" = "Hãy chia sẻ bất cứ điều gì — phản hồi, ý tưởng, yêu cầu tính năng…";
"Remind Me Later" = "Nhắc tôi sau";
"Don't Ask Again" = "Không hỏi lại";
"UpworkBuddy Feedback — %@" = "Phản hồi UpworkBuddy — %@";
"Developer" = "Lập trình viên";
"Designer" = "Nhà thiết kế";
"Manager" = "Quản lý";
"Student" = "Sinh viên";
"Researcher" = "Nhà nghiên cứu";
"Other" = "Khác";

// MARK: - Projects list
"Activity" = "Hoạt động";
"No tracked work in this period." = "Không có công việc nào được ghi nhận trong kỳ này.";

// MARK: - Software updates
"Version Information" = "Thông tin phiên bản";
"Current Version" = "Phiên bản hiện tại";
"Last Checked" = "Kiểm tra lần cuối";
"Update Preferences" = "Tùy chọn cập nhật";
"Automatic Updates" = "Cập nhật tự động";
"Automatically check for and download updates daily" = "Tự động kiểm tra và tải xuống bản cập nhật hàng ngày";
"Checking…" = "Đang kiểm tra…";
"Secure Updates" = "Cập nhật bảo mật";
"All updates are cryptographically signed and verified before installation" = "Tất cả bản cập nhật được ký mã hóa và xác minh trước khi cài đặt";

// MARK: - Support page
"Support the Project" = "Ủng hộ dự án";
"UpworkBuddy is free and open source" = "UpworkBuddy miễn phí và mã nguồn mở";
"All Features Are Free" = "Tất cả tính năng miễn phí";
"Every feature in this app is completely free to use. No premium tiers, no paywalls, no subscriptions." = "Mọi tính năng trong ứng dụng này hoàn toàn miễn phí. Không có gói trả phí, không có tường phí, không có đăng ký.";
"Open Source" = "Mã nguồn mở";
"The source code is publicly available on GitHub. You can inspect, modify, and contribute to the project." = "Mã nguồn được công khai trên GitHub. Bạn có thể xem, chỉnh sửa và đóng góp cho dự án.";
"No Tracking" = "Không theo dõi";
"Your privacy matters. No analytics, no telemetry, no data collection. Everything stays on your Mac." = "Quyền riêng tư của bạn quan trọng. Không phân tích, không đo lường, không thu thập dữ liệu. Tất cả lưu trên Mac của bạn.";
"If you find this app useful, consider supporting its development" = "Nếu ứng dụng hữu ích, hãy cân nhắc ủng hộ sự phát triển của nó";
"Buy Me a Coffee" = "Mua cho tôi một ly cà phê";
"Your support helps keep this project alive and growing" = "Sự ủng hộ của bạn giúp dự án tiếp tục phát triển";
"You can also support by" = "Bạn cũng có thể ủng hộ bằng cách";
"Starring on GitHub" = "Đánh sao trên GitHub";

// MARK: - Shortcut actions
"Toggle Popover" = "Bật/tắt cửa sổ nổi";
"Refresh Now" = "Làm mới ngay";
"Open Settings" = "Mở cài đặt";
"Show or hide the UpworkBuddy popover" = "Hiển thị hoặc ẩn cửa sổ nổi UpworkBuddy";
"Fetch the latest earnings data" = "Tải dữ liệu thu nhập mới nhất";
"Open the settings window" = "Mở cửa sổ cài đặt";

// MARK: - Music
"Music" = "Âm nhạc";
"Background music while you work" = "Nhạc nền trong khi làm việc";
"Add track" = "Thêm bài hát";
"Track URL" = "URL bài hát";
"Paste YouTube, Spotify or audio URL" = "Dán URL YouTube, Spotify hoặc âm thanh";
"Unsupported URL" = "URL không được hỗ trợ";
"Playlist" = "Danh sách phát";
"Your playlist is empty. Paste a URL above to get started." = "Danh sách phát trống. Dán URL ở trên để bắt đầu.";
"Playback" = "Phát lại";
"Loop" = "Lặp";
"Shuffle" = "Trộn bài";
"One" = "Một bài";
"All" = "Tất cả";
"Sleep timer" = "Hẹn giờ tắt";
"Stop playback after a delay" = "Dừng phát sau một khoảng thời gian";
"Stops in %@" = "Dừng sau %@";
"Sleep timer %@" = "Hẹn giờ tắt %@";
"15 minutes" = "15 phút";
"30 minutes" = "30 phút";
"1 hour" = "1 giờ";
"2 hours" = "2 giờ";
"Volume" = "Âm lượng";
"Now playing" = "Đang phát";
"Play" = "Phát";
"Pause" = "Tạm dừng";
"Next" = "Tiếp theo";
"Previous" = "Trước đó";
"Stop" = "Dừng";
"Remove" = "Xóa";
"Off" = "Tắt";
"Playback failed: %@" = "Phát lại thất bại: %@";
"Paste YouTube, Spotify, SoundCloud, Vimeo, Mixcloud or audio URL" = "Dán URL YouTube, Spotify, SoundCloud, Vimeo, Mixcloud hoặc âm thanh";

// MARK: - Exercises
"Exercises" = "Bài tập";
"Periodic eye rest and standup reminders" = "Nhắc nhở nghỉ mắt và đứng dậy định kỳ";
"Eye break" = "Nghỉ mắt";
"Enable eye break" = "Bật nghỉ mắt";
"Periodically pause your Upwork timer and lock the screen to rest your eyes (20-20-20 rule)." = "Định kỳ tạm dừng bộ đếm Upwork và khóa màn hình để nghỉ mắt (quy tắc 20-20-20).";
"Interval (minutes)" = "Khoảng cách (phút)";
"How often an eye break is triggered." = "Tần suất kích hoạt nghỉ mắt.";
"Break duration (seconds)" = "Thời lượng nghỉ (giây)";
"How long the lock overlay stays on screen." = "Thời gian màn hình khóa hiển thị.";
"On-screen message" = "Thông điệp trên màn hình";
"Custom text shown over the lock overlay." = "Văn bản tùy chỉnh hiển thị trên màn hình khóa.";
"External displays only" = "Chỉ màn hình ngoài";
"Only lock external monitors; keep the main display usable." = "Chỉ khóa màn hình ngoài; giữ màn hình chính có thể sử dụng.";
"Preview" = "Xem trước";
"Preview break now" = "Xem trước nghỉ ngay";
"Shows a 5-second break using the current settings." = "Hiển thị nghỉ 5 giây với cài đặt hiện tại.";
"Look 20 feet away for 20 seconds" = "Nhìn xa 6 mét trong 20 giây";
"Skip break (Esc)" = "Bỏ qua nghỉ (Esc)";

// Standup
"Standup" = "Đứng dậy";
"Enable standup" = "Bật nhắc nhở đứng dậy";
"Periodically lock the screen so you stand up, stretch, and move (~2 min every 30 min — Stanford EHS)." = "Định kỳ khóa màn hình để bạn đứng dậy, giãn cơ và vận động (~2 phút mỗi 30 phút — Stanford EHS).";
"Standup interval (minutes)" = "Khoảng cách đứng dậy (phút)";
"How often a standup is triggered." = "Tần suất kích hoạt nhắc nhở đứng dậy.";
"Standup duration (seconds)" = "Thời lượng đứng dậy (giây)";
"How long the lock overlay stays on screen so you can move." = "Thời gian màn hình khóa hiển thị để bạn có thể vận động.";
"Standup message" = "Thông điệp đứng dậy";
"Only lock external monitors during standup." = "Chỉ khóa màn hình ngoài khi đứng dậy.";
"Preview standup now" = "Xem trước đứng dậy ngay";
"Shows a 5-second standup using the current settings." = "Hiển thị đứng dậy 5 giây với cài đặt hiện tại.";
"Stand up, stretch, and move around" = "Đứng dậy, giãn cơ và đi lại";
```

- [ ] **Step 2: Commit**

```bash
git add Sources/UpworkBuddy/Resources/vi.lproj/Localizable.strings
git commit -m "feat(i18n): add Vietnamese (vi) translations"
```

---

### Task 3: Create Spanish translation file

**Files:**
- Create: `Sources/UpworkBuddy/Resources/es.lproj/Localizable.strings`

- [ ] **Step 1: Create directory and file**

```bash
mkdir -p Sources/UpworkBuddy/Resources/es.lproj
```

Create `Sources/UpworkBuddy/Resources/es.lproj/Localizable.strings`:

```
/*
  Localizable.strings — Spanish (es)
  Translated by AI. Community corrections welcome.
*/

// MARK: - Brand
"Upwork" = "Upwork";
"Buddy" = "Buddy";
"UpworkBuddy" = "UpworkBuddy";

// MARK: - Common actions
"Cancel" = "Cancelar";
"Reset" = "Restablecer";
"Add" = "Añadir";
"Submit" = "Enviar";
"Connected" = "Conectado";
"Disconnected" = "Desconectado";
"Never" = "Nunca";
"Coming soon" = "Próximamente";
"Quit" = "Salir";
"Quit UpworkBuddy" = "Salir de UpworkBuddy";
"Settings" = "Ajustes";

// MARK: - Period
"Today" = "Hoy";
"Week" = "Semana";
"Month" = "Mes";
"Year" = "Año";

// MARK: - Metrics
"Hours" = "Horas";
"Earnings" = "Ganancias";
"target" = "objetivo";
"Session Reset" = "Nuevo comienzo";
"Enable notifications" = "Celebrar hitos";
"Receive alerts when approaching usage limits" = "Recibe un aviso cuando te acerques a tu objetivo diario";
"Enable progress notifications" = "Activar celebraciones de hitos";
"Remove %d%%" = "Eliminar %d%%";
"Add custom threshold" = "Añadir umbral personalizado";
"Notification sound" = "Sonido de notificación";
"Light" = "Claro";
"Dark" = "Oscuro";
"Auto" = "Auto";
"App appearance" = "Apariencia de la app";
"Earnings target" = "Objetivo de ganancias";
"Hours target" = "Objetivo de horas";
"Custom threshold percent" = "Porcentaje de umbral personalizado";
"Remove custom threshold" = "Eliminar umbral personalizado";
"Remove %d percent threshold" = "Eliminar umbral del %d por ciento";
"%@ at %d percent" = "%@ al %d por ciento";
"Warning" = "Casi ahí";
"High Usage" = "¡Muy cerca!";
"Critical" = "Un último esfuerzo";
"Milestone" = "Hito";
"%@ theme" = "Tema %@";
"Reset to default" = "Restablecer predeterminado";
"Code Burn" = "Code Burn";
"Emerald" = "Emerald";
"Error: %@" = "Error: %@";
"Upwork Buddy" = "Upwork Buddy";
"Loading" = "Cargando";
"Updated %@" = "Actualizado %@";
"Last updated %@" = "Última actualización %@";
"Name" = "Nombre";
"Email" = "Correo";
"%@: %@" = "%1$@: %2$@";
"Opens donation page in browser" = "Abre la página de donación en el navegador";
"Star on GitHub" = "Dar estrella en GitHub";
"Opens GitHub repo" = "Abre el repositorio de GitHub";
"Last %d days" = "Últimos %d días";
"Trend chart, last %d days, total %@" = "Gráfico de tendencia, últimos %1$d días, total %2$@";
"Goal progress %d percent" = "Progreso del objetivo %d por ciento";
"Clear shortcut" = "Borrar atajo";
"Time period" = "Período";

// MARK: - Settings categories
"General" = "General";
"Goals" = "Objetivos";
"Display" = "Pantalla";
"Language" = "Idioma";
"Shortcuts" = "Atajos";
"Account" = "Cuenta";
"Software Updates" = "Actualizaciones";
"Support" = "Soporte";
"About" = "Acerca de";
"About UpworkBuddy" = "Acerca de UpworkBuddy";

"Refresh cadence and login behavior" = "Frecuencia de actualización y comportamiento de inicio de sesión";
"Hours and earnings targets, with notifications" = "Objetivos de horas y ganancias con notificaciones";
"Theme, menu bar, and dashboard" = "Tema, barra de menú y panel";
"Choose your preferred language" = "Elige tu idioma preferido";
"Global keyboard shortcuts" = "Atajos de teclado globales";
"Connected Upwork session" = "Sesión de Upwork conectada";
"Keep your app up to date" = "Mantén tu app actualizada";
"Support the project" = "Apoya el proyecto";

// MARK: - General page
"Sync" = "Sincronizar";
"Startup" = "Inicio";
"Launch at login" = "Iniciar al entrar";
"Open UpworkBuddy automatically when you sign in." = "Abrir UpworkBuddy automáticamente al iniciar sesión.";
"Refresh Interval" = "Intervalo de actualización";
"How often UpworkBuddy polls for new earnings" = "Con qué frecuencia UpworkBuddy consulta las ganancias";
"Refresh interval" = "Intervalo de actualización";
"1 min" = "1 min";
"30 min" = "30 min";
"1 minute" = "1 minuto";
"%d minutes" = "%d minutos";

// MARK: - Goals page
"Targets" = "Objetivos";
"Notifications" = "Notificaciones";
"Celebration" = "Celebración";
"Confetti when a goal is hit" = "Confeti al alcanzar un objetivo";
"Plays a quick burst when any target reaches 100%." = "Lanza un efecto rápido cuando cualquier objetivo llega al 100%.";
"Goal tracking" = "Seguimiento de objetivos";
"Stay on pace day, week, month, and year. Get a banner when you cross a target." = "Mantén el ritmo diario, semanal, mensual y anual. Recibe una notificación al cruzar un objetivo.";
"Tracking off" = "Seguimiento desactivado";
"Notifications on" = "Notificaciones activadas";
"Notifications blocked — check System Settings" = "Notificaciones bloqueadas — revisa Ajustes del sistema";
"Awaiting permission" = "Esperando permiso";
"Notifications unavailable" = "Notificaciones no disponibles";
"Alert Thresholds" = "Momentos clave";
"Custom Thresholds" = "Hitos personalizados";
"e.g. 50" = "ej. 50";
"Sound" = "Sonido";
"Tap a value to type directly" = "Toca un valor para escribir directamente";
"Enable tracking to edit" = "Activa el seguimiento para editar";
"Get notified about usage milestones" = "Recibe ánimos al alcanzar tu objetivo";
"Goal celebration animation" = "Animación de celebración de objetivo";

// MARK: - Display page
"Theme" = "Tema";
"Used across dashboard, menu bar, and settings" = "Usado en el panel, barra de menú y ajustes";
"Dashboard" = "Panel";
"Primary metric" = "Métrica principal";
"Renders large in the popover header." = "Se muestra grande en el encabezado del popover.";
"Hide sensitive amounts" = "Ocultar importes sensibles";
"Masks earnings, rates, and totals across the app." = "Oculta ganancias, tarifas y totales en toda la app.";
"Currency" = "Moneda";
"Display currency" = "Mostrar moneda";
"FX support coming in v2." = "Soporte de divisas disponible en v2.";

// MARK: - Shortcuts page
"Bindings" = "Asignaciones";
"Esc cancels recording" = "Esc cancela la grabación";
"Global shortcuts" = "Atajos globales";
"Shortcuts work from any application. Each shortcut must include at least one modifier key (⌘, ⌥, ⌃, or ⇧)." = "Los atajos funcionan desde cualquier aplicación. Cada atajo debe incluir al menos una tecla modificadora (⌘, ⌥, ⌃ o ⇧).";

// MARK: - Account page
"Connection" = "Conexión";
"Signed in via OAuth." = "Sesión iniciada mediante OAuth.";
"Not connected." = "No conectado.";
"Danger zone" = "Zona de peligro";
"Disconnect" = "Desconectar";
"Sign out and clear cached earnings on this Mac." = "Cierra sesión y borra las ganancias en caché de este Mac.";

// MARK: - Menu bar
"Menu bar" = "Barra de menú";
"Choose which targets surface in the status bar" = "Elige qué objetivos aparecen en la barra de estado";
"Today target" = "Objetivo de hoy";
"Daily progress in the menu bar" = "Progreso diario en la barra de menú";
"Weekly target" = "Objetivo semanal";
"Weekly progress in the menu bar" = "Progreso semanal en la barra de menú";
"Icon Style" = "Estilo de icono";
"Display Mode" = "Modo de pantalla";
"Display style" = "Estilo de pantalla";
"Add a goal target" = "Añadir objetivo";

// MARK: - Menu bar enums
"Icon + value" = "Icono + valor";
"Icon only" = "Solo icono";
"Value only" = "Solo valor";
"Icon + primary metric" = "Icono + métrica principal";
"Icon + percentage" = "Icono + porcentaje";
"Icon + remaining" = "Icono + restante";
"Glyph only, no value" = "Solo glifo, sin valor";
"Glyph + current value" = "Glifo + valor actual";
"Glyph + percent of goal" = "Glifo + porcentaje del objetivo";
"Glyph + amount left to goal" = "Glifo + cantidad restante al objetivo";
"Value only, no glyph" = "Solo valor, sin glifo";
"Battery (Classic)" = "Batería (Clásico)";
"Progress Bar" = "Barra de progreso";
"Percentage" = "Porcentaje";
"Icon with Bar" = "Icono con barra";
"Compact" = "Compacto";
"Count vs goal" = "Conteo vs objetivo";
"Show as percentage (e.g., 60%)" = "Mostrar como porcentaje (ej. 60%)";
"Show count vs goal (e.g., 5h/8h)" = "Mostrar conteo vs objetivo (ej. 5h/8h)";

// MARK: - Language page
"Select Language" = "Seleccionar idioma";
"Language changes will take effect after restarting the app" = "Los cambios de idioma tendrán efecto al reiniciar la app";

// MARK: - About page
"Reset App Data?" = "¿Restablecer datos de la app?";
"Signs you out, clears cached earnings, and resets all preferences on this Mac. The action cannot be undone." = "Cierra tu sesión, borra las ganancias en caché y restablece todas las preferencias en este Mac. Esta acción no se puede deshacer.";
"Version %@" = "Versión %@";
"Check for Updates" = "Buscar actualizaciones";
"Created By" = "Creado por";
"Links" = "Enlaces";
"Send Feedback" = "Enviar comentarios";
"Reset App Data" = "Restablecer datos de la app";
"MIT License • Open Source" = "MIT License • Open Source";

// MARK: - Login
"Track your active Upwork projects, hours, and earnings — right from the menu bar." = "Sigue tus proyectos, horas y ganancias de Upwork — directamente desde la barra de menú.";
"Connect Upwork" = "Conectar Upwork";
"A browser window will open for sign-in." = "Se abrirá una ventana del navegador para iniciar sesión.";

// MARK: - Dashboard
"Show amounts" = "Mostrar importes";
"Hide amounts" = "Ocultar importes";
"Refresh now" = "Actualizar ahora";

// MARK: - Feedback
"Help Us Improve" = "Ayúdanos a mejorar";
"Your feedback shapes the future of this app" = "Tu opinión define el futuro de esta app";
"Role" = "Rol";
"Tell us anything — feedback, ideas, feature requests…" = "Cuéntanos cualquier cosa — comentarios, ideas, solicitudes de funciones…";
"Remind Me Later" = "Recuérdamelo más tarde";
"Don't Ask Again" = "No volver a preguntar";
"UpworkBuddy Feedback — %@" = "Comentarios de UpworkBuddy — %@";
"Developer" = "Desarrollador";
"Designer" = "Diseñador";
"Manager" = "Gerente";
"Student" = "Estudiante";
"Researcher" = "Investigador";
"Other" = "Otro";

// MARK: - Projects list
"Activity" = "Actividad";
"No tracked work in this period." = "Sin trabajo registrado en este período.";

// MARK: - Software updates
"Version Information" = "Información de versión";
"Current Version" = "Versión actual";
"Last Checked" = "Última comprobación";
"Update Preferences" = "Preferencias de actualización";
"Automatic Updates" = "Actualizaciones automáticas";
"Automatically check for and download updates daily" = "Buscar y descargar actualizaciones automáticamente cada día";
"Checking…" = "Comprobando…";
"Secure Updates" = "Actualizaciones seguras";
"All updates are cryptographically signed and verified before installation" = "Todas las actualizaciones están firmadas criptográficamente y verificadas antes de instalarse";

// MARK: - Support page
"Support the Project" = "Apoya el proyecto";
"UpworkBuddy is free and open source" = "UpworkBuddy es gratuito y de código abierto";
"All Features Are Free" = "Todas las funciones son gratuitas";
"Every feature in this app is completely free to use. No premium tiers, no paywalls, no subscriptions." = "Todas las funciones de esta app son completamente gratuitas. Sin niveles premium, sin muros de pago, sin suscripciones.";
"Open Source" = "Código abierto";
"The source code is publicly available on GitHub. You can inspect, modify, and contribute to the project." = "El código fuente está disponible públicamente en GitHub. Puedes inspeccionarlo, modificarlo y contribuir al proyecto.";
"No Tracking" = "Sin rastreo";
"Your privacy matters. No analytics, no telemetry, no data collection. Everything stays on your Mac." = "Tu privacidad importa. Sin análisis, sin telemetría, sin recopilación de datos. Todo se queda en tu Mac.";
"If you find this app useful, consider supporting its development" = "Si esta app te resulta útil, considera apoyar su desarrollo";
"Buy Me a Coffee" = "Invítame a un café";
"Your support helps keep this project alive and growing" = "Tu apoyo ayuda a mantener y hacer crecer este proyecto";
"You can also support by" = "También puedes apoyar";
"Starring on GitHub" = "Dando una estrella en GitHub";

// MARK: - Shortcut actions
"Toggle Popover" = "Alternar ventana flotante";
"Refresh Now" = "Actualizar ahora";
"Open Settings" = "Abrir ajustes";
"Show or hide the UpworkBuddy popover" = "Mostrar u ocultar la ventana flotante de UpworkBuddy";
"Fetch the latest earnings data" = "Obtener los últimos datos de ganancias";
"Open the settings window" = "Abrir la ventana de ajustes";

// MARK: - Music
"Music" = "Música";
"Background music while you work" = "Música de fondo mientras trabajas";
"Add track" = "Añadir pista";
"Track URL" = "URL de la pista";
"Paste YouTube, Spotify or audio URL" = "Pega una URL de YouTube, Spotify o audio";
"Unsupported URL" = "URL no compatible";
"Playlist" = "Lista de reproducción";
"Your playlist is empty. Paste a URL above to get started." = "Tu lista de reproducción está vacía. Pega una URL arriba para comenzar.";
"Playback" = "Reproducción";
"Loop" = "Repetir";
"Shuffle" = "Aleatorio";
"One" = "Una";
"All" = "Todas";
"Sleep timer" = "Temporizador";
"Stop playback after a delay" = "Detener la reproducción tras un retraso";
"Stops in %@" = "Para en %@";
"Sleep timer %@" = "Temporizador %@";
"15 minutes" = "15 minutos";
"30 minutes" = "30 minutos";
"1 hour" = "1 hora";
"2 hours" = "2 horas";
"Volume" = "Volumen";
"Now playing" = "Reproduciendo";
"Play" = "Reproducir";
"Pause" = "Pausar";
"Next" = "Siguiente";
"Previous" = "Anterior";
"Stop" = "Detener";
"Remove" = "Eliminar";
"Off" = "Apagado";
"Playback failed: %@" = "Error de reproducción: %@";
"Paste YouTube, Spotify, SoundCloud, Vimeo, Mixcloud or audio URL" = "Pega una URL de YouTube, Spotify, SoundCloud, Vimeo, Mixcloud o audio";

// MARK: - Exercises
"Exercises" = "Ejercicios";
"Periodic eye rest and standup reminders" = "Recordatorios periódicos de descanso visual y ponerse de pie";
"Eye break" = "Descanso visual";
"Enable eye break" = "Activar descanso visual";
"Periodically pause your Upwork timer and lock the screen to rest your eyes (20-20-20 rule)." = "Pausa periódicamente el temporizador de Upwork y bloquea la pantalla para descansar la vista (regla 20-20-20).";
"Interval (minutes)" = "Intervalo (minutos)";
"How often an eye break is triggered." = "Con qué frecuencia se activa el descanso visual.";
"Break duration (seconds)" = "Duración del descanso (segundos)";
"How long the lock overlay stays on screen." = "Cuánto tiempo permanece la pantalla de bloqueo.";
"On-screen message" = "Mensaje en pantalla";
"Custom text shown over the lock overlay." = "Texto personalizado sobre la pantalla de bloqueo.";
"External displays only" = "Solo pantallas externas";
"Only lock external monitors; keep the main display usable." = "Solo bloquea los monitores externos; mantén la pantalla principal usable.";
"Preview" = "Vista previa";
"Preview break now" = "Previsualizar descanso ahora";
"Shows a 5-second break using the current settings." = "Muestra un descanso de 5 segundos con la configuración actual.";
"Look 20 feet away for 20 seconds" = "Mira a 6 metros de distancia durante 20 segundos";
"Skip break (Esc)" = "Saltar descanso (Esc)";

// Standup
"Standup" = "Levantarse";
"Enable standup" = "Activar recordatorio de levantarse";
"Periodically lock the screen so you stand up, stretch, and move (~2 min every 30 min — Stanford EHS)." = "Bloquea periódicamente la pantalla para que te levantes, estires y muevas (~2 min cada 30 min — Stanford EHS).";
"Standup interval (minutes)" = "Intervalo de levantarse (minutos)";
"How often a standup is triggered." = "Con qué frecuencia se activa el recordatorio de levantarse.";
"Standup duration (seconds)" = "Duración de levantarse (segundos)";
"How long the lock overlay stays on screen so you can move." = "Cuánto tiempo permanece la pantalla de bloqueo para que puedas moverte.";
"Standup message" = "Mensaje de levantarse";
"Only lock external monitors during standup." = "Solo bloquea monitores externos al levantarse.";
"Preview standup now" = "Previsualizar levantarse ahora";
"Shows a 5-second standup using the current settings." = "Muestra un levantarse de 5 segundos con la configuración actual.";
"Stand up, stretch, and move around" = "Levántate, estírate y muévete";
```

- [ ] **Step 2: Commit**

```bash
git add Sources/UpworkBuddy/Resources/es.lproj/Localizable.strings
git commit -m "feat(i18n): add Spanish (es) translations"
```

---

### Task 4: Create French translation file

**Files:**
- Create: `Sources/UpworkBuddy/Resources/fr.lproj/Localizable.strings`

- [ ] **Step 1: Create directory and file**

```bash
mkdir -p Sources/UpworkBuddy/Resources/fr.lproj
```

Create `Sources/UpworkBuddy/Resources/fr.lproj/Localizable.strings`:

```
/*
  Localizable.strings — French (fr)
  Translated by AI. Community corrections welcome.
*/

// MARK: - Brand
"Upwork" = "Upwork";
"Buddy" = "Buddy";
"UpworkBuddy" = "UpworkBuddy";

// MARK: - Common actions
"Cancel" = "Annuler";
"Reset" = "Réinitialiser";
"Add" = "Ajouter";
"Submit" = "Envoyer";
"Connected" = "Connecté";
"Disconnected" = "Déconnecté";
"Never" = "Jamais";
"Coming soon" = "Bientôt disponible";
"Quit" = "Quitter";
"Quit UpworkBuddy" = "Quitter UpworkBuddy";
"Settings" = "Réglages";

// MARK: - Period
"Today" = "Aujourd'hui";
"Week" = "Semaine";
"Month" = "Mois";
"Year" = "Année";

// MARK: - Metrics
"Hours" = "Heures";
"Earnings" = "Revenus";
"target" = "objectif";
"Session Reset" = "Nouveau départ";
"Enable notifications" = "Célébrer les jalons";
"Receive alerts when approaching usage limits" = "Recevez une notification quand vous approchez de votre objectif journalier";
"Enable progress notifications" = "Activer les célébrations de jalons";
"Remove %d%%" = "Supprimer %d%%";
"Add custom threshold" = "Ajouter un seuil personnalisé";
"Notification sound" = "Son de notification";
"Light" = "Clair";
"Dark" = "Sombre";
"Auto" = "Auto";
"App appearance" = "Apparence de l'app";
"Earnings target" = "Objectif de revenus";
"Hours target" = "Objectif d'heures";
"Custom threshold percent" = "Pourcentage de seuil personnalisé";
"Remove custom threshold" = "Supprimer le seuil personnalisé";
"Remove %d percent threshold" = "Supprimer le seuil de %d pourcent";
"%@ at %d percent" = "%@ à %d pourcent";
"Warning" = "Presque là";
"High Usage" = "Si proche !";
"Critical" = "Un dernier effort";
"Milestone" = "Jalon";
"%@ theme" = "Thème %@";
"Reset to default" = "Réinitialiser par défaut";
"Code Burn" = "Code Burn";
"Emerald" = "Emerald";
"Error: %@" = "Erreur : %@";
"Upwork Buddy" = "Upwork Buddy";
"Loading" = "Chargement";
"Updated %@" = "Mis à jour %@";
"Last updated %@" = "Dernière mise à jour %@";
"Name" = "Nom";
"Email" = "E-mail";
"%@: %@" = "%1$@ : %2$@";
"Opens donation page in browser" = "Ouvre la page de don dans le navigateur";
"Star on GitHub" = "Étoiler sur GitHub";
"Opens GitHub repo" = "Ouvre le dépôt GitHub";
"Last %d days" = "%d derniers jours";
"Trend chart, last %d days, total %@" = "Graphique de tendance, %1$d derniers jours, total %2$@";
"Goal progress %d percent" = "Progression de l'objectif %d pourcent";
"Clear shortcut" = "Effacer le raccourci";
"Time period" = "Période";

// MARK: - Settings categories
"General" = "Général";
"Goals" = "Objectifs";
"Display" = "Affichage";
"Language" = "Langue";
"Shortcuts" = "Raccourcis";
"Account" = "Compte";
"Software Updates" = "Mises à jour";
"Support" = "Assistance";
"About" = "À propos";
"About UpworkBuddy" = "À propos d'UpworkBuddy";

"Refresh cadence and login behavior" = "Fréquence d'actualisation et comportement de connexion";
"Hours and earnings targets, with notifications" = "Objectifs d'heures et de revenus avec notifications";
"Theme, menu bar, and dashboard" = "Thème, barre de menus et tableau de bord";
"Choose your preferred language" = "Choisissez votre langue préférée";
"Global keyboard shortcuts" = "Raccourcis clavier globaux";
"Connected Upwork session" = "Session Upwork connectée";
"Keep your app up to date" = "Gardez votre app à jour";
"Support the project" = "Soutenir le projet";

// MARK: - General page
"Sync" = "Synchroniser";
"Startup" = "Démarrage";
"Launch at login" = "Lancer à la connexion";
"Open UpworkBuddy automatically when you sign in." = "Ouvrir UpworkBuddy automatiquement lors de la connexion.";
"Refresh Interval" = "Intervalle d'actualisation";
"How often UpworkBuddy polls for new earnings" = "Fréquence à laquelle UpworkBuddy vérifie les nouveaux revenus";
"Refresh interval" = "Intervalle d'actualisation";
"1 min" = "1 min";
"30 min" = "30 min";
"1 minute" = "1 minute";
"%d minutes" = "%d minutes";

// MARK: - Goals page
"Targets" = "Cibles";
"Notifications" = "Notifications";
"Celebration" = "Célébration";
"Confetti when a goal is hit" = "Confettis quand un objectif est atteint";
"Plays a quick burst when any target reaches 100%." = "Lance un effet rapide quand une cible atteint 100 %.";
"Goal tracking" = "Suivi des objectifs";
"Stay on pace day, week, month, and year. Get a banner when you cross a target." = "Restez dans le rythme jour, semaine, mois et année. Recevez une bannière quand vous franchissez un objectif.";
"Tracking off" = "Suivi désactivé";
"Notifications on" = "Notifications activées";
"Notifications blocked — check System Settings" = "Notifications bloquées — vérifiez les Réglages système";
"Awaiting permission" = "En attente d'autorisation";
"Notifications unavailable" = "Notifications indisponibles";
"Alert Thresholds" = "Moments clés";
"Custom Thresholds" = "Jalons personnalisés";
"e.g. 50" = "ex. 50";
"Sound" = "Son";
"Tap a value to type directly" = "Appuyez sur une valeur pour saisir directement";
"Enable tracking to edit" = "Activez le suivi pour modifier";
"Get notified about usage milestones" = "Encouragements à chaque jalon";
"Goal celebration animation" = "Animation de célébration d'objectif";

// MARK: - Display page
"Theme" = "Thème";
"Used across dashboard, menu bar, and settings" = "Utilisé dans le tableau de bord, la barre de menus et les réglages";
"Dashboard" = "Tableau de bord";
"Primary metric" = "Métrique principale";
"Renders large in the popover header." = "Affiché en grand dans l'en-tête du popover.";
"Hide sensitive amounts" = "Masquer les montants sensibles";
"Masks earnings, rates, and totals across the app." = "Masque les revenus, tarifs et totaux dans toute l'app.";
"Currency" = "Devise";
"Display currency" = "Afficher la devise";
"FX support coming in v2." = "Support des devises disponible en v2.";

// MARK: - Shortcuts page
"Bindings" = "Liaisons";
"Esc cancels recording" = "Échap annule l'enregistrement";
"Global shortcuts" = "Raccourcis globaux";
"Shortcuts work from any application. Each shortcut must include at least one modifier key (⌘, ⌥, ⌃, or ⇧)." = "Les raccourcis fonctionnent depuis n'importe quelle application. Chaque raccourci doit inclure au moins une touche de modification (⌘, ⌥, ⌃ ou ⇧).";

// MARK: - Account page
"Connection" = "Connexion";
"Signed in via OAuth." = "Connecté via OAuth.";
"Not connected." = "Non connecté.";
"Danger zone" = "Zone dangereuse";
"Disconnect" = "Déconnecter";
"Sign out and clear cached earnings on this Mac." = "Déconnectez-vous et effacez les revenus en cache sur ce Mac.";

// MARK: - Menu bar
"Menu bar" = "Barre de menus";
"Choose which targets surface in the status bar" = "Choisissez quelles cibles apparaissent dans la barre d'état";
"Today target" = "Objectif du jour";
"Daily progress in the menu bar" = "Progression quotidienne dans la barre de menus";
"Weekly target" = "Objectif hebdomadaire";
"Weekly progress in the menu bar" = "Progression hebdomadaire dans la barre de menus";
"Icon Style" = "Style d'icône";
"Display Mode" = "Mode d'affichage";
"Display style" = "Style d'affichage";
"Add a goal target" = "Ajouter un objectif";

// MARK: - Menu bar enums
"Icon + value" = "Icône + valeur";
"Icon only" = "Icône seule";
"Value only" = "Valeur seule";
"Icon + primary metric" = "Icône + métrique principale";
"Icon + percentage" = "Icône + pourcentage";
"Icon + remaining" = "Icône + restant";
"Glyph only, no value" = "Glyphe seul, sans valeur";
"Glyph + current value" = "Glyphe + valeur actuelle";
"Glyph + percent of goal" = "Glyphe + pourcentage de l'objectif";
"Glyph + amount left to goal" = "Glyphe + montant restant à l'objectif";
"Value only, no glyph" = "Valeur seule, sans glyphe";
"Battery (Classic)" = "Batterie (Classique)";
"Progress Bar" = "Barre de progression";
"Percentage" = "Pourcentage";
"Icon with Bar" = "Icône avec barre";
"Compact" = "Compact";
"Count vs goal" = "Compte vs objectif";
"Show as percentage (e.g., 60%)" = "Afficher en pourcentage (ex. 60 %)";
"Show count vs goal (e.g., 5h/8h)" = "Afficher compte vs objectif (ex. 5h/8h)";

// MARK: - Language page
"Select Language" = "Sélectionner la langue";
"Language changes will take effect after restarting the app" = "Les changements de langue prendront effet après le redémarrage de l'app";

// MARK: - About page
"Reset App Data?" = "Réinitialiser les données de l'app ?";
"Signs you out, clears cached earnings, and resets all preferences on this Mac. The action cannot be undone." = "Vous déconnecte, efface les revenus en cache et réinitialise toutes les préférences sur ce Mac. L'action est irréversible.";
"Version %@" = "Version %@";
"Check for Updates" = "Rechercher des mises à jour";
"Created By" = "Créé par";
"Links" = "Liens";
"Send Feedback" = "Envoyer un retour";
"Reset App Data" = "Réinitialiser les données de l'app";
"MIT License • Open Source" = "MIT License • Open Source";

// MARK: - Login
"Track your active Upwork projects, hours, and earnings — right from the menu bar." = "Suivez vos projets Upwork actifs, vos heures et vos revenus — directement depuis la barre de menus.";
"Connect Upwork" = "Connecter Upwork";
"A browser window will open for sign-in." = "Une fenêtre de navigateur s'ouvrira pour la connexion.";

// MARK: - Dashboard
"Show amounts" = "Afficher les montants";
"Hide amounts" = "Masquer les montants";
"Refresh now" = "Actualiser maintenant";

// MARK: - Feedback
"Help Us Improve" = "Aidez-nous à nous améliorer";
"Your feedback shapes the future of this app" = "Vos retours façonnent l'avenir de cette app";
"Role" = "Rôle";
"Tell us anything — feedback, ideas, feature requests…" = "Dites-nous tout — retours, idées, demandes de fonctionnalités…";
"Remind Me Later" = "Me rappeler plus tard";
"Don't Ask Again" = "Ne plus demander";
"UpworkBuddy Feedback — %@" = "Retour UpworkBuddy — %@";
"Developer" = "Développeur";
"Designer" = "Designer";
"Manager" = "Manager";
"Student" = "Étudiant";
"Researcher" = "Chercheur";
"Other" = "Autre";

// MARK: - Projects list
"Activity" = "Activité";
"No tracked work in this period." = "Aucun travail enregistré sur cette période.";

// MARK: - Software updates
"Version Information" = "Informations de version";
"Current Version" = "Version actuelle";
"Last Checked" = "Dernière vérification";
"Update Preferences" = "Préférences de mise à jour";
"Automatic Updates" = "Mises à jour automatiques";
"Automatically check for and download updates daily" = "Rechercher et télécharger automatiquement les mises à jour chaque jour";
"Checking…" = "Vérification…";
"Secure Updates" = "Mises à jour sécurisées";
"All updates are cryptographically signed and verified before installation" = "Toutes les mises à jour sont signées cryptographiquement et vérifiées avant installation";

// MARK: - Support page
"Support the Project" = "Soutenir le projet";
"UpworkBuddy is free and open source" = "UpworkBuddy est gratuit et open source";
"All Features Are Free" = "Toutes les fonctionnalités sont gratuites";
"Every feature in this app is completely free to use. No premium tiers, no paywalls, no subscriptions." = "Toutes les fonctionnalités de cette app sont entièrement gratuites. Pas de niveaux premium, pas de barrières, pas d'abonnements.";
"Open Source" = "Open Source";
"The source code is publicly available on GitHub. You can inspect, modify, and contribute to the project." = "Le code source est disponible publiquement sur GitHub. Vous pouvez l'inspecter, le modifier et contribuer au projet.";
"No Tracking" = "Sans traçage";
"Your privacy matters. No analytics, no telemetry, no data collection. Everything stays on your Mac." = "Votre vie privée compte. Pas d'analyses, pas de télémétrie, pas de collecte de données. Tout reste sur votre Mac.";
"If you find this app useful, consider supporting its development" = "Si cette app vous est utile, envisagez de soutenir son développement";
"Buy Me a Coffee" = "Offrez-moi un café";
"Your support helps keep this project alive and growing" = "Votre soutien aide à maintenir et développer ce projet";
"You can also support by" = "Vous pouvez aussi soutenir en";
"Starring on GitHub" = "Mettant une étoile sur GitHub";

// MARK: - Shortcut actions
"Toggle Popover" = "Afficher/masquer la fenêtre flottante";
"Refresh Now" = "Actualiser maintenant";
"Open Settings" = "Ouvrir les réglages";
"Show or hide the UpworkBuddy popover" = "Afficher ou masquer la fenêtre flottante UpworkBuddy";
"Fetch the latest earnings data" = "Récupérer les dernières données de revenus";
"Open the settings window" = "Ouvrir la fenêtre des réglages";

// MARK: - Music
"Music" = "Musique";
"Background music while you work" = "Musique de fond pendant votre travail";
"Add track" = "Ajouter une piste";
"Track URL" = "URL de la piste";
"Paste YouTube, Spotify or audio URL" = "Collez une URL YouTube, Spotify ou audio";
"Unsupported URL" = "URL non prise en charge";
"Playlist" = "Liste de lecture";
"Your playlist is empty. Paste a URL above to get started." = "Votre liste de lecture est vide. Collez une URL ci-dessus pour commencer.";
"Playback" = "Lecture";
"Loop" = "Boucle";
"Shuffle" = "Aléatoire";
"One" = "Une";
"All" = "Toutes";
"Sleep timer" = "Minuterie";
"Stop playback after a delay" = "Arrêter la lecture après un délai";
"Stops in %@" = "S'arrête dans %@";
"Sleep timer %@" = "Minuterie %@";
"15 minutes" = "15 minutes";
"30 minutes" = "30 minutes";
"1 hour" = "1 heure";
"2 hours" = "2 heures";
"Volume" = "Volume";
"Now playing" = "En lecture";
"Play" = "Lire";
"Pause" = "Pause";
"Next" = "Suivant";
"Previous" = "Précédent";
"Stop" = "Arrêter";
"Remove" = "Supprimer";
"Off" = "Désactivé";
"Playback failed: %@" = "Échec de la lecture : %@";
"Paste YouTube, Spotify, SoundCloud, Vimeo, Mixcloud or audio URL" = "Collez une URL YouTube, Spotify, SoundCloud, Vimeo, Mixcloud ou audio";

// MARK: - Exercises
"Exercises" = "Exercices";
"Periodic eye rest and standup reminders" = "Rappels périodiques de repos visuel et de lever";
"Eye break" = "Pause visuelle";
"Enable eye break" = "Activer la pause visuelle";
"Periodically pause your Upwork timer and lock the screen to rest your eyes (20-20-20 rule)." = "Mettez périodiquement en pause votre minuteur Upwork et verrouillez l'écran pour reposer vos yeux (règle 20-20-20).";
"Interval (minutes)" = "Intervalle (minutes)";
"How often an eye break is triggered." = "Fréquence de déclenchement de la pause visuelle.";
"Break duration (seconds)" = "Durée de la pause (secondes)";
"How long the lock overlay stays on screen." = "Durée d'affichage de l'écran de verrouillage.";
"On-screen message" = "Message à l'écran";
"Custom text shown over the lock overlay." = "Texte personnalisé affiché sur l'écran de verrouillage.";
"External displays only" = "Écrans externes uniquement";
"Only lock external monitors; keep the main display usable." = "Verrouiller uniquement les moniteurs externes ; garder l'écran principal utilisable.";
"Preview" = "Aperçu";
"Preview break now" = "Aperçu de la pause maintenant";
"Shows a 5-second break using the current settings." = "Affiche une pause de 5 secondes avec les réglages actuels.";
"Look 20 feet away for 20 seconds" = "Regardez à 6 mètres pendant 20 secondes";
"Skip break (Esc)" = "Passer la pause (Échap)";

// Standup
"Standup" = "Se lever";
"Enable standup" = "Activer le rappel de lever";
"Periodically lock the screen so you stand up, stretch, and move (~2 min every 30 min — Stanford EHS)." = "Verrouillez périodiquement l'écran pour vous lever, vous étirer et bouger (~2 min toutes les 30 min — Stanford EHS).";
"Standup interval (minutes)" = "Intervalle de lever (minutes)";
"How often a standup is triggered." = "Fréquence de déclenchement du rappel de lever.";
"Standup duration (seconds)" = "Durée du lever (secondes)";
"How long the lock overlay stays on screen so you can move." = "Durée d'affichage de l'écran de verrouillage pour vous permettre de bouger.";
"Standup message" = "Message de lever";
"Only lock external monitors during standup." = "Verrouiller uniquement les moniteurs externes lors du lever.";
"Preview standup now" = "Aperçu du lever maintenant";
"Shows a 5-second standup using the current settings." = "Affiche un lever de 5 secondes avec les réglages actuels.";
"Stand up, stretch, and move around" = "Levez-vous, étirez-vous et bougez";
```

- [ ] **Step 2: Commit**

```bash
git add Sources/UpworkBuddy/Resources/fr.lproj/Localizable.strings
git commit -m "feat(i18n): add French (fr) translations"
```

---

### Task 5–13: Remaining languages (parallel dispatch)

**Dispatch Tasks 5–13 as parallel agents.** Each agent handles one language. All agents receive the full English source from `Sources/UpworkBuddy/Resources/en.lproj/Localizable.strings` and the same translation rules:

- Keep keys verbatim (left side)
- Preserve `%@`, `%d`, `%1$@`, `%2$@`, `%%` exactly
- Do NOT translate: `Upwork`, `Buddy`, `UpworkBuddy`, `MIT License`, `GitHub`, `OAuth`, `YouTube`, `Spotify`, `SoundCloud`, `Vimeo`, `Mixcloud`, `v2`, `20-20-20`

| Task | Language | Code | Directory |
|------|----------|------|-----------|
| 5 | German | `de` | `Resources/de.lproj/` |
| 6 | Italian | `it` | `Resources/it.lproj/` |
| 7 | Portuguese (Portugal) | `pt-PT` | `Resources/pt-PT.lproj/` |
| 8 | Brazilian Portuguese | `pt-BR` | `Resources/pt-BR.lproj/` |
| 9 | Japanese | `ja` | `Resources/ja.lproj/` |
| 10 | Korean | `ko` | `Resources/ko.lproj/` |
| 11 | Simplified Chinese | `zh-Hans` | `Resources/zh-Hans.lproj/` |
| 12 | Traditional Chinese | `zh-Hant` | `Resources/zh-Hant.lproj/` |
| 13 | Ukrainian | `uk` | `Resources/uk.lproj/` |
| 14 | Turkish | `tr` | `Resources/tr.lproj/` |

Each agent should:

- [ ] `mkdir -p Sources/UpworkBuddy/Resources/<code>.lproj`
- [ ] Write `Localizable.strings` with all keys translated
- [ ] `git add` and commit: `feat(i18n): add <Language> (<code>) translations`

---

### Task 15: Build verification

**Files:** none (verification only)

- [ ] **Step 1: Build**

```bash
swift build 2>&1 | tail -10
```

Expected: `Build complete!` with no errors or warnings about missing localizations.

- [ ] **Step 2: Verify lproj folders present**

```bash
ls Sources/UpworkBuddy/Resources/*.lproj
```

Expected: 14 folders — `vi.lproj es.lproj fr.lproj de.lproj it.lproj pt-PT.lproj pt-BR.lproj ja.lproj ko.lproj zh-Hans.lproj zh-Hant.lproj uk.lproj tr.lproj en.lproj`

- [ ] **Step 3: Verify Vietnamese appears in language list**

```bash
grep -c "vietnamese" Sources/UpworkBuddy/Models/AppLanguage.swift
```

Expected: at least `3` (case declaration + nativeName + englishName)

- [ ] **Step 4: Final commit if any loose files**

```bash
git status
```

If clean — done. If any untracked `.lproj` files remain, stage and commit them.
