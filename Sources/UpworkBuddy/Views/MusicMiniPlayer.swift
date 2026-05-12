import SwiftUI

/// Persistent compact player rendered just above the dashboard footer.
/// Hidden entirely when the playlist is empty so it doesn't clutter the UI
/// for users who haven't opted into the feature.
struct MusicMiniPlayer: View {
    @Bindable var service: MusicPlayerService = .shared

    var body: some View {
        Group {
            if service.playlist.isEmpty {
                EmptyView()
            } else {
                content
            }
        }
    }

    private var content: some View {
        HStack(spacing: 10) {
            artwork
            metadata
            Spacer(minLength: 4)
            controls
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.surface.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.5)
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }

    // MARK: - Pieces

    private var artwork: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Theme.chipBg.opacity(0.7))
                .frame(width: 36, height: 36)
            if let url = service.currentTrack?.artworkURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    default:
                        glyph
                    }
                }
            } else {
                glyph
            }
        }
        .accessibilityHidden(true)
    }

    private var glyph: some View {
        Image(systemName: glyphName)
            .font(Theme.body(size: 14, weight: .semibold))
            .foregroundStyle(Theme.accentDeep)
    }

    private var glyphName: String {
        switch service.currentTrack?.source.kind {
        case .youtube:    return "play.rectangle"
        case .spotify:    return "waveform"
        case .soundcloud: return "cloud"
        case .vimeo:      return "v.circle"
        case .mixcloud:   return "circle.grid.cross"
        default:          return "music.note"
        }
    }

    private var metadata: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(service.currentTrack?.title ?? L10n.t("Now playing"))
                .font(Theme.body(size: 12, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)
                .truncationMode(.tail)
            HStack(spacing: 6) {
                if let artist = service.currentTrack?.artist {
                    Text(artist)
                        .font(.caption2)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(1)
                }
                if let remaining = service.sleepTimerRemainingSeconds {
                    SleepChip(remaining: remaining)
                }
            }
        }
    }

    private var controls: some View {
        HStack(spacing: 4) {
            iconButton("backward.fill", help: L10n.t("Previous")) {
                service.previous()
            }
            iconButton(service.isPlaying ? "pause.fill" : "play.fill",
                       help: service.isPlaying ? L10n.t("Pause") : L10n.t("Play")) {
                service.togglePlayPause()
            }
            iconButton("forward.fill", help: L10n.t("Next")) {
                service.next()
            }
            iconButton("stop.fill", help: L10n.t("Stop")) {
                service.stop()
            }
        }
    }

    private func iconButton(_ system: String, help: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(Theme.body(size: 12, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .frame(width: 26, height: 26)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Theme.chipBg.opacity(0.55))
                )
        }
        .buttonStyle(.plain)
        .help(help)
        .accessibilityLabel(help)
    }
}

private struct SleepChip: View {
    let remaining: Int

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "moon.zzz.fill")
                .font(.caption2)
            Text(label)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
        }
        .foregroundStyle(Theme.accentDeep)
        .padding(.horizontal, 5)
        .padding(.vertical, 1)
        .background(Capsule().fill(Theme.accent.opacity(0.16)))
        .accessibilityLabel(L10n.t("Sleep timer %@", label))
    }

    private var label: String {
        let m = remaining / 60
        let s = remaining % 60
        return String(format: "%d:%02d", m, s)
    }
}
