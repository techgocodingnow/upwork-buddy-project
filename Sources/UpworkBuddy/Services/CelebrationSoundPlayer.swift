import AVFoundation
import CryptoKit

/// Plays the chosen `CelebrationSound`. `.off` is silent; `.custom` plays a
/// user-supplied local file or remote URL — no bundled audio assets, no
/// licensing concerns.
@MainActor
final class CelebrationSoundPlayer {
    static let shared = CelebrationSoundPlayer()

    private init() {}

    /// Tracks AVAudioPlayer instances so callers can replace an in-flight
    /// custom-sound playback when re-triggered.
    private var customPlayers: [AVAudioPlayer] = []

    /// Background download tasks for remote custom sounds; we cache the
    /// downloaded file under Application Support and play from disk on
    /// subsequent fires.
    private var downloadTasks: [URLSessionDataTask] = []

    func play(_ sound: CelebrationSound, customSource: String = "") {
        switch sound {
        case .off:
            return
        case .custom:
            playCustom(source: customSource)
        }
    }

    // MARK: - Custom user sound

    /// Resolve `source` to a local file URL, then start playback. Remote URLs
    /// are downloaded once and cached under
    /// `~/Library/Application Support/UpworkBuddy/CelebrationSounds/<sha>.<ext>`.
    private func playCustom(source raw: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let url = URL(string: trimmed) ?? URL(fileURLWithPath: trimmed, isDirectory: false) as URL? else {
            Log.app.error("Custom celebration sound: empty / invalid source")
            return
        }

        if url.isFileURL {
            playLocalFile(at: url)
            return
        }

        guard let scheme = url.scheme?.lowercased(), scheme == "http" || scheme == "https" else {
            // Treat anything else as a bare path.
            playLocalFile(at: URL(fileURLWithPath: trimmed))
            return
        }

        let cached = cachedFileURL(for: url)
        if FileManager.default.fileExists(atPath: cached.path) {
            playLocalFile(at: cached)
            return
        }

        downloadAndPlay(remote: url, cachedAt: cached)
    }

    private func playLocalFile(at url: URL) {
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
            // Retain until playback finishes; AVAudioPlayer fires `audioPlayerDidFinishPlaying`
            // but we don't need the delegate — we just prune retired entries on next call.
            customPlayers = customPlayers.filter { $0.isPlaying }
            customPlayers.append(player)
        } catch {
            Log.app.error("Custom sound failed to play \(url.path, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }

    private func cachedFileURL(for remote: URL) -> URL {
        let base = celebrationCacheDirectory()
        // Hash the URL string so different remotes don't collide and the same
        // remote always hits the same cache file.
        let key = sha256Hex(remote.absoluteString)
        let ext = remote.pathExtension.isEmpty ? "mp3" : remote.pathExtension
        return base.appendingPathComponent("\(key).\(ext)")
    }

    private func celebrationCacheDirectory() -> URL {
        let fm = FileManager.default
        let support = (try? fm.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )) ?? URL(fileURLWithPath: NSTemporaryDirectory())
        let dir = support.appendingPathComponent("UpworkBuddy/CelebrationSounds", isDirectory: true)
        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    private func downloadAndPlay(remote: URL, cachedAt cached: URL) {
        var req = URLRequest(url: remote)
        req.timeoutInterval = 20
        let task = URLSession.shared.dataTask(with: req) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.downloadTasks.removeAll { $0.state == .completed }
                if let error {
                    Log.app.error("Custom sound download failed: \(error.localizedDescription, privacy: .public)")
                    return
                }
                guard let data, !data.isEmpty else {
                    Log.app.error("Custom sound download returned empty body")
                    return
                }
                do {
                    try data.write(to: cached, options: .atomic)
                    self.playLocalFile(at: cached)
                } catch {
                    Log.app.error("Custom sound cache write failed: \(error.localizedDescription, privacy: .public)")
                }
            }
        }
        downloadTasks.append(task)
        task.resume()
    }

    private func sha256Hex(_ s: String) -> String {
        // Lightweight inline SHA-256 via CryptoKit.
        let digest = SHA256.hash(data: Data(s.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
