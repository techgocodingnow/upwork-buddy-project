import Foundation
import AVFoundation

/// Async metadata enrichment for tracks added by URL. Each variant has its
/// own best-effort path; failures degrade gracefully by leaving fields nil
/// (the caller falls back to a sensible title from the URL).
enum MusicMetadataFetcher {
    struct Result: Sendable {
        var title: String?
        var artist: String?
        var artworkURL: URL?
        var durationSeconds: Double?
    }

    static func fetch(for source: TrackSource) async -> Result {
        switch source {
        case .youtube(let id):
            return await fetchYouTube(videoId: id)
        case .spotify(let uri):
            return await fetchSpotify(uri: uri)
        case .soundcloud(let url):
            return await fetchOEmbed(provider: "https://soundcloud.com/oembed", target: url.absoluteString)
        case .vimeo(let id):
            return await fetchOEmbed(provider: "https://vimeo.com/api/oembed.json", target: "https://vimeo.com/\(id)")
        case .mixcloud(let path):
            return await fetchOEmbed(provider: "https://www.mixcloud.com/oembed/", target: "https://www.mixcloud.com\(path)")
        case .directURL(let url):
            return await fetchDirect(url: url)
        }
    }

    /// Generic oEmbed JSON fetch. Most providers return the same envelope —
    /// title, author_name, thumbnail_url — so one path covers SoundCloud,
    /// Vimeo, Mixcloud (and any future provider that follows the spec).
    private static func fetchOEmbed(provider: String, target: String) async -> Result {
        guard var comps = URLComponents(string: provider) else { return Result() }
        var items = comps.queryItems ?? []
        items.append(URLQueryItem(name: "url", value: target))
        items.append(URLQueryItem(name: "format", value: "json"))
        comps.queryItems = items
        guard let url = comps.url else { return Result() }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(OEmbed.self, from: data)
            return Result(
                title: decoded.title,
                artist: decoded.author_name ?? decoded.provider_name,
                artworkURL: decoded.thumbnail_url.flatMap(URL.init(string:))
            )
        } catch {
            Log.music.error("oEmbed (\(provider, privacy: .public)) failed: \(error.localizedDescription, privacy: .public)")
            return Result()
        }
    }

    // MARK: - YouTube oEmbed (no API key)

    private static func fetchYouTube(videoId: String) async -> Result {
        let endpoint = "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=\(videoId)&format=json"
        guard let url = URL(string: endpoint) else { return Result() }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(OEmbed.self, from: data)
            return Result(
                title: decoded.title,
                artist: decoded.author_name,
                artworkURL: decoded.thumbnail_url.flatMap(URL.init(string:))
            )
        } catch {
            Log.music.error("YouTube oEmbed failed: \(error.localizedDescription, privacy: .public)")
            return Result()
        }
    }

    // MARK: - Spotify oEmbed (no auth, no Premium)

    private static func fetchSpotify(uri: String) async -> Result {
        // Convert spotify:track:ID -> https://open.spotify.com/track/ID
        let parts = uri.split(separator: ":")
        guard parts.count >= 3 else { return Result() }
        let kind = String(parts[1])
        let id = String(parts[2])
        let webURL = "https://open.spotify.com/\(kind)/\(id)"
        let endpoint = "https://open.spotify.com/oembed?url=\(webURL)"
        guard let url = URL(string: endpoint) else { return Result() }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(OEmbed.self, from: data)
            return Result(
                title: decoded.title,
                artist: decoded.author_name ?? decoded.provider_name,
                artworkURL: decoded.thumbnail_url.flatMap(URL.init(string:))
            )
        } catch {
            Log.music.error("Spotify oEmbed failed: \(error.localizedDescription, privacy: .public)")
            return Result()
        }
    }

    // MARK: - Direct asset metadata via AVAsset

    private static func fetchDirect(url: URL) async -> Result {
        let asset = AVURLAsset(url: url)
        var title: String?
        var artist: String?
        var duration: Double?

        do {
            let metadataItems = try await asset.load(.commonMetadata)
            for item in metadataItems {
                guard let key = item.commonKey?.rawValue else { continue }
                switch key {
                case "title":
                    if let value = try? await item.load(.stringValue) { title = value }
                case "artist":
                    if let value = try? await item.load(.stringValue) { artist = value }
                default:
                    break
                }
            }
            let cmDuration = try await asset.load(.duration)
            let seconds = CMTimeGetSeconds(cmDuration)
            if seconds.isFinite, seconds > 0 { duration = seconds }
        } catch {
            // Asset may not be readable yet (live stream, paywall) — degrade silently.
        }

        return Result(
            title: title,
            artist: artist,
            artworkURL: nil,
            durationSeconds: duration
        )
    }

    // MARK: - oEmbed envelope

    private struct OEmbed: Decodable {
        let title: String?
        let author_name: String?
        let provider_name: String?
        let thumbnail_url: String?
    }
}
