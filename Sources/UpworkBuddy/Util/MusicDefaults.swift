import Foundation

/// Where a track's audio comes from. Each variant maps to a distinct
/// playback engine in `MusicPlayerService`.
///
/// `directURL` — AVPlayer (mp3/m4a/wav/flac/HLS/.m3u8/SHOUTcast streams).
/// All other variants — `WebPlaybackEngine` with the source's official
/// embed widget + JS bridge for play/pause/end events.
enum TrackSource: Codable, Hashable, Sendable {
    case directURL(URL)
    case youtube(videoId: String)
    case spotify(uri: String)        // canonical "spotify:track:..." or "spotify:playlist:..."
    case soundcloud(url: URL)        // full track URL — Widget API uses URL not ID
    case vimeo(videoId: String)
    case mixcloud(path: String)      // /{user}/{slug}/ path component

    enum Kind: String, Codable, Sendable, CaseIterable {
        case audio, youtube, spotify, soundcloud, vimeo, mixcloud
    }

    var kind: Kind {
        switch self {
        case .directURL: return .audio
        case .youtube:   return .youtube
        case .spotify:   return .spotify
        case .soundcloud: return .soundcloud
        case .vimeo:     return .vimeo
        case .mixcloud:  return .mixcloud
        }
    }
}

struct Track: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let source: TrackSource
    var title: String
    var artist: String?
    var artworkURL: URL?
    var durationSeconds: Double?

    init(
        id: UUID = UUID(),
        source: TrackSource,
        title: String,
        artist: String? = nil,
        artworkURL: URL? = nil,
        durationSeconds: Double? = nil
    ) {
        self.id = id
        self.source = source
        self.title = title
        self.artist = artist
        self.artworkURL = artworkURL
        self.durationSeconds = durationSeconds
    }
}

enum LoopMode: String, Codable, Sendable, CaseIterable, Identifiable {
    case off, one, all

    var id: String { rawValue }

    var label: String {
        switch self {
        case .off: return L10n.t("Off")
        case .one: return L10n.t("One")
        case .all: return L10n.t("All")
        }
    }

    var systemImage: String {
        switch self {
        case .off: return "repeat"
        case .one: return "repeat.1"
        case .all: return "repeat"
        }
    }
}

/// UserDefaults keys for the music feature, namespaced to avoid collisions
/// with the existing `AppStore` keys.
enum MusicDefaultsKey {
    static let playlist     = "UpworkBuddyMusicPlaylist"
    static let loopMode     = "UpworkBuddyMusicLoopMode"
    static let shuffle      = "UpworkBuddyMusicShuffle"
    static let lastIndex    = "UpworkBuddyMusicLastIndex"
    static let volume       = "UpworkBuddyMusicVolume"
}
