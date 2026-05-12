import AVFoundation
import AppKit
import CryptoKit

/// Plays the chosen `CelebrationSound`. Procedural cases (`applause`,
/// `cheer`, `fanfare`, `magic`, `drumroll`) are synthesized on the fly into
/// an `AVAudioPCMBuffer` and scheduled on an `AVAudioPlayerNode` — no bundled
/// audio assets, no licensing concerns. System cases fall back to
/// `NSSound(named:)`.
@MainActor
final class CelebrationSoundPlayer {
    static let shared = CelebrationSoundPlayer()

    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let format: AVAudioFormat
    private var started = false

    private init() {
        // Mono 44.1k buffer — small, fast to synthesize.
        format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
    }

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
        case .applause, .cheer, .fanfare, .magic, .drumroll:
            playProcedural(sound)
        case .glass, .hero, .submarine, .ping, .funk, .pop:
            if let name = sound.systemName {
                NSSound(named: NSSound.Name(name))?.play()
            }
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

    // MARK: - Procedural

    private func playProcedural(_ sound: CelebrationSound) {
        ensureEngineRunning()
        guard let buf = renderBuffer(for: sound) else { return }
        player.scheduleBuffer(buf, at: nil, options: .interrupts, completionHandler: nil)
        if !player.isPlaying { player.play() }
    }

    private func ensureEngineRunning() {
        guard !started else { return }
        do {
            try engine.start()
            player.play()
            started = true
        } catch {
            Log.app.error("Celebration audio engine failed to start: \(error.localizedDescription, privacy: .public)")
        }
    }

    private func renderBuffer(for sound: CelebrationSound) -> AVAudioPCMBuffer? {
        switch sound {
        case .applause:  return renderApplause(duration: 1.8)
        case .cheer:     return renderCheer(duration: 1.6)
        case .fanfare:   return renderFanfare()
        case .magic:     return renderMagic(duration: 1.2)
        case .drumroll:  return renderDrumroll(duration: 1.4)
        default: return nil
        }
    }

    // MARK: - Buffer helpers

    private func makeBuffer(seconds: Double) -> AVAudioPCMBuffer? {
        let frames = AVAudioFrameCount(seconds * format.sampleRate)
        guard let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frames) else { return nil }
        buf.frameLength = frames
        if let ch = buf.floatChannelData?[0] {
            memset(ch, 0, Int(frames) * MemoryLayout<Float>.size)
        }
        return buf
    }

    private func writeSample(_ buf: AVAudioPCMBuffer, frame i: Int, value v: Float) {
        guard let data = buf.floatChannelData?[0] else { return }
        guard i >= 0 && i < Int(buf.frameLength) else { return }
        data[i] += v
    }

    // MARK: - Generators

    /// Applause = filtered pink-ish noise plus random clap impulses. Envelope
    /// rises ~150ms, sustains, then tails off.
    private func renderApplause(duration: Double) -> AVAudioPCMBuffer? {
        guard let buf = makeBuffer(seconds: duration) else { return nil }
        let sr = format.sampleRate
        let total = Int(buf.frameLength)

        // Background sustained noise bed (filtered).
        var prev: Float = 0
        for i in 0..<total {
            let t = Double(i) / sr
            let env: Float = {
                if t < 0.15 { return Float(t / 0.15) }
                if t > duration - 0.4 { return Float(max(0, (duration - t) / 0.4)) }
                return 1
            }()
            let white = Float.random(in: -1...1)
            // One-pole low-pass for warmer "claps".
            prev = prev * 0.82 + white * 0.18
            writeSample(buf, frame: i, value: prev * 0.18 * env)
        }

        // Sparse clap impulses (~12 per second).
        let claps = Int(duration * 12)
        for _ in 0..<claps {
            let center = Int.random(in: 0..<total)
            let burstLen = Int(sr * Double.random(in: 0.018...0.04))
            let amp = Float.random(in: 0.35...0.7)
            for j in 0..<burstLen {
                let env = expf(-Float(j) / Float(burstLen) * 4)
                let n = Float.random(in: -1...1) * env * amp
                writeSample(buf, frame: center + j, value: n)
            }
        }
        return buf
    }

    /// Cheer = brighter noise + rising whistle ramp.
    private func renderCheer(duration: Double) -> AVAudioPCMBuffer? {
        guard let buf = makeBuffer(seconds: duration) else { return nil }
        let sr = format.sampleRate
        let total = Int(buf.frameLength)

        // Bright noise bed (less low-pass than applause).
        for i in 0..<total {
            let t = Double(i) / sr
            let env: Float = {
                if t < 0.1 { return Float(t / 0.1) }
                if t > duration - 0.3 { return Float(max(0, (duration - t) / 0.3)) }
                return 1
            }()
            writeSample(buf, frame: i, value: Float.random(in: -1...1) * 0.12 * env)
        }

        // Whistle: sweep 700 → 1400 Hz over first half, hold, then fade.
        var phase: Double = 0
        for i in 0..<total {
            let t = Double(i) / sr
            let progress = min(1, t / (duration * 0.5))
            let freq = 700 + progress * 700
            phase += (2 * .pi * freq) / sr
            let env: Float = {
                if t < 0.05 { return Float(t / 0.05) }
                if t > duration - 0.25 { return Float(max(0, (duration - t) / 0.25)) }
                return 1
            }()
            writeSample(buf, frame: i, value: Float(sin(phase)) * 0.22 * env)
        }
        return buf
    }

    /// Fanfare = triadic chord arpeggio C-E-G-C, sawtooth-ish brass tone.
    private func renderFanfare() -> AVAudioPCMBuffer? {
        let notes: [(freq: Double, start: Double, len: Double)] = [
            (261.63, 0.00, 0.45),  // C4
            (329.63, 0.18, 0.45),  // E4
            (392.00, 0.36, 0.55),  // G4
            (523.25, 0.54, 0.85),  // C5
        ]
        let duration = 1.5
        guard let buf = makeBuffer(seconds: duration) else { return nil }
        let sr = format.sampleRate
        let total = Int(buf.frameLength)

        for note in notes {
            let startFrame = Int(note.start * sr)
            let endFrame = min(total, startFrame + Int(note.len * sr))
            var phase: Double = 0
            for i in startFrame..<endFrame {
                phase += (2 * .pi * note.freq) / sr
                // Mix sine + half sine of 2x for brassy harmonic.
                let s = sin(phase) * 0.7 + sin(phase * 2) * 0.25 + sin(phase * 3) * 0.08
                let local = Double(i - startFrame) / Double(endFrame - startFrame)
                let env: Float
                if local < 0.05 { env = Float(local / 0.05) }
                else if local > 0.7 { env = Float(max(0, (1 - local) / 0.3)) }
                else { env = 1 }
                writeSample(buf, frame: i, value: Float(s) * 0.22 * env)
            }
        }
        return buf
    }

    /// Magic = upward chromatic sparkle — rising sine sweep + bell harmonics.
    private func renderMagic(duration: Double) -> AVAudioPCMBuffer? {
        guard let buf = makeBuffer(seconds: duration) else { return nil }
        let sr = format.sampleRate
        let total = Int(buf.frameLength)

        var phase: Double = 0
        var phase2: Double = 0
        for i in 0..<total {
            let t = Double(i) / sr
            let progress = t / duration
            let freq = 400 + pow(progress, 0.7) * 1800   // 400 → 2200 Hz
            phase += (2 * .pi * freq) / sr
            phase2 += (2 * .pi * freq * 1.5) / sr
            let env: Float = {
                if t < 0.04 { return Float(t / 0.04) }
                return Float(max(0, 1 - progress))
            }()
            let s = sin(phase) * 0.5 + sin(phase2) * 0.25
            writeSample(buf, frame: i, value: Float(s) * 0.28 * env)
        }
        return buf
    }

    /// Drumroll = fast filtered noise impulses at increasing rate + closing
    /// "thwack" lower-frequency hit.
    private func renderDrumroll(duration: Double) -> AVAudioPCMBuffer? {
        guard let buf = makeBuffer(seconds: duration) else { return nil }
        let sr = format.sampleRate
        let total = Int(buf.frameLength)

        // Roll fills first 80% of duration; final 20% is the crash.
        let rollEnd = duration * 0.8
        var t: Double = 0
        var rate = 14.0  // hits/sec at start
        while t < rollEnd {
            let center = Int(t * sr)
            let burstLen = Int(sr * 0.025)
            for j in 0..<burstLen {
                let envF = expf(-Float(j) / Float(burstLen) * 5)
                let n = Float.random(in: -1...1) * envF * 0.45
                writeSample(buf, frame: center + j, value: n)
            }
            t += 1.0 / rate
            rate = min(34, rate * 1.04)  // accelerate roll
        }

        // Closing hit: low sine thump.
        let hitStart = Int(rollEnd * sr)
        let hitLen = total - hitStart
        var phase: Double = 0
        for i in 0..<hitLen {
            let envF = expf(-Float(i) / Float(hitLen) * 3.5)
            phase += (2 * .pi * 110) / sr  // ~A2 kick
            writeSample(buf, frame: hitStart + i, value: Float(sin(phase)) * 0.7 * envF)
        }
        return buf
    }
}
