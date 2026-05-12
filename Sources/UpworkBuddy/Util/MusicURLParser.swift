import Foundation

/// Stateless parser that classifies a user-pasted URL into a `TrackSource`.
/// Recognizes YouTube and Spotify variants, otherwise falls back to direct
/// audio URL when the scheme is `http(s)` and the path looks audio-shaped.
enum MusicURLParser {
    static func parse(_ raw: String) -> TrackSource? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let id = youTubeVideoId(from: trimmed) {
            return .youtube(videoId: id)
        }
        if let uri = spotifyURI(from: trimmed) {
            return .spotify(uri: uri)
        }
        if let url = soundCloudURL(from: trimmed) {
            return .soundcloud(url: url)
        }
        if let id = vimeoVideoId(from: trimmed) {
            return .vimeo(videoId: id)
        }
        if let path = mixcloudPath(from: trimmed) {
            return .mixcloud(path: path)
        }
        if let url = URL(string: trimmed),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https" || scheme == "file" {
            return .directURL(url)
        }
        return nil
    }

    // MARK: - YouTube

    /// Accepts:
    ///   • https://www.youtube.com/watch?v=VIDEOID...
    ///   • https://youtu.be/VIDEOID
    ///   • https://www.youtube.com/shorts/VIDEOID
    ///   • https://www.youtube.com/embed/VIDEOID
    ///   • https://music.youtube.com/watch?v=VIDEOID
    private static func youTubeVideoId(from raw: String) -> String? {
        guard let url = URL(string: raw),
              let host = url.host?.lowercased() else { return nil }

        let isYTDomain = host == "youtu.be"
            || host.hasSuffix("youtube.com")
            || host.hasSuffix("youtube-nocookie.com")
        guard isYTDomain else { return nil }

        if host == "youtu.be" {
            let id = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            return validVideoId(id)
        }

        // /watch?v=ID
        if url.path == "/watch",
           let comps = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let v = comps.queryItems?.first(where: { $0.name == "v" })?.value {
            return validVideoId(v)
        }

        // /shorts/ID, /embed/ID, /v/ID, /live/ID
        let segments = url.pathComponents.filter { $0 != "/" }
        if segments.count >= 2,
           ["shorts", "embed", "v", "live"].contains(segments[0]) {
            return validVideoId(segments[1])
        }
        return nil
    }

    // MARK: - SoundCloud

    /// Accepts:
    ///   • https://soundcloud.com/{user}/{track}
    ///   • https://soundcloud.com/{user}/sets/{playlist}
    ///   • https://m.soundcloud.com/{user}/{track}
    ///   • https://on.soundcloud.com/{shortcode}
    private static func soundCloudURL(from raw: String) -> URL? {
        guard let url = URL(string: raw),
              let host = url.host?.lowercased() else { return nil }
        guard host == "soundcloud.com"
            || host == "m.soundcloud.com"
            || host == "on.soundcloud.com"
            || host == "w.soundcloud.com" else { return nil }
        // Trivial sanity: needs at least one path segment.
        let segments = url.pathComponents.filter { $0 != "/" }
        guard !segments.isEmpty else { return nil }
        return url
    }

    // MARK: - Vimeo

    /// Accepts:
    ///   • https://vimeo.com/{ID}
    ///   • https://vimeo.com/channels/{channel}/{ID}
    ///   • https://vimeo.com/{ID}/{hash}  (private link)
    ///   • https://player.vimeo.com/video/{ID}
    private static func vimeoVideoId(from raw: String) -> String? {
        guard let url = URL(string: raw),
              let host = url.host?.lowercased() else { return nil }
        guard host == "vimeo.com" || host == "player.vimeo.com" else { return nil }
        let segments = url.pathComponents.filter { $0 != "/" }
        // Find first numeric segment — that's the video ID.
        for seg in segments where seg.allSatisfy({ $0.isNumber }) && seg.count >= 6 {
            return seg
        }
        return nil
    }

    // MARK: - Mixcloud

    /// Accepts:
    ///   • https://www.mixcloud.com/{user}/{slug}/
    ///   • https://mixcloud.com/{user}/{slug}/
    private static func mixcloudPath(from raw: String) -> String? {
        guard let url = URL(string: raw),
              let host = url.host?.lowercased() else { return nil }
        guard host == "mixcloud.com" || host == "www.mixcloud.com" else { return nil }
        let segments = url.pathComponents.filter { $0 != "/" }
        guard segments.count >= 2 else { return nil }
        // Mixcloud feed paths are "/user/slug/" — preserve trailing slash.
        return "/\(segments[0])/\(segments[1])/"
    }

    private static func validVideoId(_ raw: String) -> String? {
        // YouTube IDs are 11 chars, alphanumeric + `-` and `_`. Keep the
        // check loose so future format changes don't reject valid IDs, but
        // reject anything obviously non-id-shaped.
        guard raw.count >= 8, raw.count <= 32 else { return nil }
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_"))
        return raw.unicodeScalars.allSatisfy(allowed.contains) ? raw : nil
    }

    // MARK: - Spotify

    /// Accepts:
    ///   • spotify:track:ID, spotify:playlist:ID, spotify:album:ID, spotify:episode:ID
    ///   • https://open.spotify.com/track/ID, /playlist/ID, /album/ID, /episode/ID (with optional locale prefix)
    private static func spotifyURI(from raw: String) -> String? {
        if raw.lowercased().hasPrefix("spotify:") {
            let parts = raw.split(separator: ":")
            guard parts.count >= 3 else { return nil }
            let kind = String(parts[1]).lowercased()
            guard ["track", "playlist", "album", "episode", "show"].contains(kind) else { return nil }
            let id = String(parts[2])
            return "spotify:\(kind):\(id)"
        }

        guard let url = URL(string: raw),
              let host = url.host?.lowercased(),
              host == "open.spotify.com" || host == "play.spotify.com" else { return nil }

        // Strip an optional locale segment like /intl-en/track/ID
        var segments = url.pathComponents.filter { $0 != "/" }
        if let first = segments.first, first.hasPrefix("intl-") {
            segments.removeFirst()
        }
        guard segments.count >= 2 else { return nil }
        let kind = segments[0].lowercased()
        guard ["track", "playlist", "album", "episode", "show"].contains(kind) else { return nil }
        let id = segments[1].split(separator: "?").first.map(String.init) ?? segments[1]
        return "spotify:\(kind):\(id)"
    }
}
