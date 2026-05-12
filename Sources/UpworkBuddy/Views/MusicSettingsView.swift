import SwiftUI

/// Settings page for the in-app music player. Mirrors the visual language
/// of the surrounding `SettingsView` (themed cards, dot section headers).
struct MusicSettingsView: View {
    @Bindable var service: MusicPlayerService = .shared

    @State private var draftURL: String = ""
    @State private var inlineError: String?
    @State private var isAdding: Bool = false
    @FocusState private var addFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            addTrackSection
            playlistSection
            playbackSection
            sleepTimerSection
            volumeSection
        }
    }

    // MARK: - Add track

    private var addTrackSection: some View {
        SectionContainer(title: L10n.t("Add track")) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    TextField("", text: $draftURL,
                              prompt: Text(loc: "Paste YouTube, Spotify, SoundCloud, Vimeo, Mixcloud or audio URL"))
                        .textFieldStyle(.plain)
                        .font(Theme.body(size: 12.5))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .fill(Theme.chipBg.opacity(addFocused ? 0.5 : 0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .strokeBorder(addFocused ? Theme.accent : Theme.divider,
                                              lineWidth: addFocused ? 1.2 : 0.5)
                        )
                        .focused($addFocused)
                        .onSubmit(submit)
                        .accessibilityLabel(L10n.t("Track URL"))

                    Button(action: submit) {
                        if isAdding {
                            ProgressView().controlSize(.small)
                        } else {
                            Text(loc: "Add")
                                .font(Theme.body(size: 12, weight: .semibold))
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .tint(Theme.accent)
                    .disabled(draftURL.trimmingCharacters(in: .whitespaces).isEmpty || isAdding)
                }
                if let err = inlineError {
                    Label {
                        Text(err)
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .font(.caption)
                    .foregroundStyle(.orange)
                }
            }
        }
    }

    private func submit() {
        let raw = draftURL.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty, !isAdding else { return }
        inlineError = nil
        isAdding = true
        Task {
            defer { isAdding = false }
            do {
                try await service.add(url: raw)
                draftURL = ""
            } catch {
                inlineError = error.localizedDescription
            }
        }
    }

    // MARK: - Playlist

    private var playlistSection: some View {
        SectionContainer(title: L10n.t("Playlist")) {
            if service.playlist.isEmpty {
                Text(loc: "Your playlist is empty. Paste a URL above to get started.")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
                    .padding(.vertical, 4)
            } else {
                VStack(spacing: 6) {
                    ForEach(Array(service.playlist.enumerated()), id: \.element.id) { idx, track in
                        PlaylistRow(
                            track: track,
                            isCurrent: service.currentIndex == idx,
                            isPlaying: service.isPlaying && service.currentIndex == idx,
                            onPlay:   { service.play(at: idx) },
                            onRemove: { service.remove(id: track.id) }
                        )
                    }
                }
            }
        }
    }

    // MARK: - Playback

    private var playbackSection: some View {
        SectionContainer(title: L10n.t("Playback")) {
            VStack(spacing: 10) {
                cardRow(title: L10n.t("Loop"),
                        systemImage: "repeat") {
                    Picker("", selection: $service.loopMode) {
                        ForEach(LoopMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .tint(Theme.accent)
                    .frame(maxWidth: 200)
                }

                cardRow(title: L10n.t("Shuffle"),
                        systemImage: "shuffle") {
                    Toggle("", isOn: $service.shuffleEnabled)
                        .labelsHidden()
                        .toggleStyle(.switch)
                        .tint(Theme.accent)
                        .accessibilityLabel(L10n.t("Shuffle"))
                }
            }
        }
    }

    // MARK: - Sleep timer

    private var sleepTimerSection: some View {
        SectionContainer(title: L10n.t("Sleep timer")) {
            cardRow(title: timerTitle,
                    systemImage: "moon.zzz") {
                if service.sleepTimerEndsAt != nil {
                    Button(L10n.t("Cancel")) {
                        service.cancelSleepTimer()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                } else {
                    Menu {
                        ForEach([15, 30, 60, 120], id: \.self) { minutes in
                            Button(menuLabel(for: minutes)) {
                                service.startSleepTimer(minutes: minutes)
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(loc: "Off")
                                .font(Theme.body(size: 12, weight: .semibold))
                            Image(systemName: "chevron.down")
                                .font(.caption2)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule().fill(Theme.chipBg.opacity(0.6))
                        )
                    }
                    .menuStyle(.borderlessButton)
                    .fixedSize()
                }
            }
        }
    }

    private var timerTitle: String {
        if let remaining = service.sleepTimerRemainingSeconds {
            let m = remaining / 60
            let s = remaining % 60
            return L10n.t("Stops in %@", String(format: "%d:%02d", m, s))
        }
        return L10n.t("Stop playback after a delay")
    }

    private func menuLabel(for minutes: Int) -> String {
        switch minutes {
        case 15:  return L10n.t("15 minutes")
        case 30:  return L10n.t("30 minutes")
        case 60:  return L10n.t("1 hour")
        case 120: return L10n.t("2 hours")
        default:  return L10n.t("%d minutes", minutes)
        }
    }

    // MARK: - Volume

    private var volumeSection: some View {
        SectionContainer(title: L10n.t("Volume")) {
            HStack(spacing: 10) {
                Image(systemName: "speaker.fill")
                    .foregroundStyle(Theme.textTertiary)
                Slider(value: $service.volume, in: 0...1)
                    .tint(Theme.accent)
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Theme.surface.opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(Theme.divider, lineWidth: 0.5)
            )
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func cardRow<Trailing: View>(
        title: String,
        systemImage: String,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: systemImage)
                .font(Theme.body(size: 14, weight: .medium))
                .foregroundStyle(Theme.accentDeep)
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Theme.accent.opacity(0.12))
                )
            Text(title)
                .font(Theme.body(size: 13.5, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
            Spacer(minLength: 12)
            trailing()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.surface.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.5)
        )
    }
}

// MARK: - Section container

/// Local lightweight section that mirrors the `SettingsSection` private
/// primitive in `SettingsView.swift` without coupling to it.
private struct SectionContainer<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(title.uppercased(with: .current))
                    .font(Theme.body(size: 10, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(Theme.textTertiary)
                Rectangle().fill(Theme.divider).frame(height: 1)
            }
            content()
        }
    }
}

// MARK: - Playlist row

private struct PlaylistRow: View {
    let track: Track
    let isCurrent: Bool
    let isPlaying: Bool
    let onPlay: () -> Void
    let onRemove: () -> Void

    @State private var hovering = false

    var body: some View {
        HStack(spacing: 10) {
            playButton
            artwork
            VStack(alignment: .leading, spacing: 1) {
                Text(track.title)
                    .font(Theme.body(size: 12.5, weight: isCurrent ? .semibold : .regular))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(sourceBadge)
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundStyle(Theme.accentDeep)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(Capsule().fill(Theme.accent.opacity(0.14)))
                    if let artist = track.artist {
                        Text(artist)
                            .font(.caption2)
                            .foregroundStyle(Theme.textSecondary)
                            .lineLimit(1)
                    }
                }
            }
            Spacer(minLength: 4)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(Theme.body(size: 13))
                    .foregroundStyle(Theme.textTertiary.opacity(hovering ? 0.95 : 0.55))
            }
            .buttonStyle(.plain)
            .help(L10n.t("Remove"))
            .accessibilityLabel(L10n.t("Remove"))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isCurrent ? Theme.accent.opacity(0.10) : Theme.surface.opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(isCurrent ? Theme.accent.opacity(0.4) : Theme.divider, lineWidth: 0.5)
        )
        .onHover { hovering = $0 }
        .contentShape(Rectangle())
        .onTapGesture(count: 2, perform: onPlay)
    }

    private var playButton: some View {
        Button(action: onPlay) {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(Theme.body(size: 11, weight: .semibold))
                .foregroundStyle(isCurrent ? Theme.accentDeep : Theme.textSecondary)
                .frame(width: 22, height: 22)
                .background(
                    Circle().fill(isCurrent ? Theme.accent.opacity(0.18) : Theme.chipBg.opacity(0.55))
                )
        }
        .buttonStyle(.plain)
        .help(isPlaying ? L10n.t("Pause") : L10n.t("Play"))
    }

    private var artwork: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Theme.chipBg.opacity(0.6))
                .frame(width: 28, height: 28)
            if let url = track.artworkURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                            .frame(width: 28, height: 28)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    default:
                        sourceGlyph
                    }
                }
            } else {
                sourceGlyph
            }
        }
    }

    private var sourceGlyph: some View {
        Image(systemName: glyphName)
            .font(Theme.body(size: 11, weight: .semibold))
            .foregroundStyle(Theme.accentDeep)
    }

    private var glyphName: String {
        switch track.source.kind {
        case .youtube:    return "play.rectangle"
        case .spotify:    return "waveform"
        case .soundcloud: return "cloud"
        case .vimeo:      return "v.circle"
        case .mixcloud:   return "circle.grid.cross"
        case .audio:      return "music.note"
        }
    }

    private var sourceBadge: String {
        switch track.source.kind {
        case .youtube:    return "YT"
        case .spotify:    return "SPOT"
        case .soundcloud: return "SC"
        case .vimeo:      return "VIM"
        case .mixcloud:   return "MIX"
        case .audio:      return "MP3"
        }
    }
}
