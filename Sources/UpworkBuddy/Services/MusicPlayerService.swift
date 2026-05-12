import Foundation
import Observation
import AVFoundation
import MediaPlayer

/// Single source of truth for the in-app music player. Owns playlist,
/// transport state, and the two playback engines (AVPlayer for direct
/// audio URLs, `WebPlaybackEngine` for YouTube / Spotify).
///
/// Pattern mirrors `GoalNotificationService`: `@MainActor` singleton
/// instantiated from `AppDelegate.applicationDidFinishLaunching`. Settings
/// + miniplayer views read it via `@Bindable var = MusicPlayerService.shared`.
@MainActor
@Observable
final class MusicPlayerService {
    static let shared = MusicPlayerService()

    // MARK: - Playlist + selection

    private(set) var playlist: [Track] = []
    private(set) var currentIndex: Int? = nil

    var currentTrack: Track? {
        guard let i = currentIndex, playlist.indices.contains(i) else { return nil }
        return playlist[i]
    }

    // MARK: - Transport

    private(set) var isPlaying: Bool = false
    private(set) var positionSeconds: Double = 0
    private(set) var durationSeconds: Double = 0
    private(set) var lastError: String?

    // MARK: - User prefs (persisted)

    var loopMode: LoopMode {
        didSet { UserDefaults.standard.set(loopMode.rawValue, forKey: MusicDefaultsKey.loopMode) }
    }

    var shuffleEnabled: Bool {
        didSet {
            UserDefaults.standard.set(shuffleEnabled, forKey: MusicDefaultsKey.shuffle)
            rebuildShuffleOrder()
        }
    }

    var volume: Double {
        didSet {
            let clamped = max(0, min(1, volume))
            avPlayer.volume = Float(clamped)
            UserDefaults.standard.set(clamped, forKey: MusicDefaultsKey.volume)
        }
    }

    // MARK: - Sleep timer

    private(set) var sleepTimerEndsAt: Date?
    var sleepTimerRemainingSeconds: Int? {
        guard let endsAt = sleepTimerEndsAt else { return nil }
        return max(0, Int(endsAt.timeIntervalSinceNow))
    }
    private var sleepTimerTask: Task<Void, Never>?

    // MARK: - Tick (for position UI updates)

    private var tickTask: Task<Void, Never>?

    // MARK: - Engines

    private let avPlayer = AVPlayer()
    private let webEngine = WebPlaybackEngine()
    private var avTimeObserver: Any?
    private var avEndObserver: NSObjectProtocol?

    // MARK: - Shuffle bookkeeping

    private var shuffledIndices: [Int] = []
    private var shufflePosition: Int = 0

    // MARK: - Init / restore

    private init() {
        let defaults = UserDefaults.standard
        let storedLoop = defaults.string(forKey: MusicDefaultsKey.loopMode).flatMap(LoopMode.init(rawValue:))
        self.loopMode = storedLoop ?? .off
        self.shuffleEnabled = defaults.bool(forKey: MusicDefaultsKey.shuffle)
        let storedVolume = defaults.object(forKey: MusicDefaultsKey.volume) as? Double
        self.volume = storedVolume ?? 0.8

        avPlayer.volume = Float(volume)
        installAVObservers()
        wireWebEngine()
        loadPlaylistFromDefaults()

        // Restore last selection (paused). We deliberately do NOT auto-play
        // on launch — surprising background audio is hostile.
        let storedIndex = defaults.object(forKey: MusicDefaultsKey.lastIndex) as? Int
        if let idx = storedIndex, playlist.indices.contains(idx) {
            currentIndex = idx
            durationSeconds = playlist[idx].durationSeconds ?? 0
        }
    }

    // MARK: - Playlist mutations

    /// Adds a track from a user-pasted URL. Parsing happens synchronously;
    /// metadata enrichment is fired async and patched into the row when it
    /// returns. Throws on unsupported URLs so callers can show an inline
    /// error.
    enum AddError: Error, LocalizedError {
        case unsupported

        var errorDescription: String? { L10n.t("Unsupported URL") }
    }

    func add(url raw: String) async throws {
        guard let source = MusicURLParser.parse(raw) else {
            throw AddError.unsupported
        }
        let placeholderTitle = fallbackTitle(for: source)
        var track = Track(source: source, title: placeholderTitle)
        playlist.append(track)
        persistPlaylist()
        rebuildShuffleOrder()

        let meta = await MusicMetadataFetcher.fetch(for: source)
        // Track may have been removed mid-fetch; locate by id before patching.
        guard let idx = playlist.firstIndex(where: { $0.id == track.id }) else { return }
        track = playlist[idx]
        if let title = meta.title, !title.isEmpty { track.title = title }
        if let artist = meta.artist, !artist.isEmpty { track.artist = artist }
        if let art = meta.artworkURL { track.artworkURL = art }
        if let dur = meta.durationSeconds { track.durationSeconds = dur }
        playlist[idx] = track
        persistPlaylist()

        // Reflect freshly-loaded duration if this track is the current one.
        if currentIndex == idx, let dur = track.durationSeconds {
            durationSeconds = dur
        }
    }

    func remove(id: UUID) {
        guard let idx = playlist.firstIndex(where: { $0.id == id }) else { return }
        let wasCurrent = currentIndex == idx
        playlist.remove(at: idx)
        if let cur = currentIndex {
            if wasCurrent {
                stop()
                currentIndex = playlist.indices.contains(idx) ? idx : nil
            } else if cur > idx {
                currentIndex = cur - 1
            }
        }
        persistPlaylist()
        rebuildShuffleOrder()
    }

    func move(from source: IndexSet, to destination: Int) {
        let oldId = currentTrack?.id
        playlist.move(fromOffsets: source, toOffset: destination)
        if let oldId, let newIdx = playlist.firstIndex(where: { $0.id == oldId }) {
            currentIndex = newIdx
        }
        persistPlaylist()
        rebuildShuffleOrder()
    }

    // MARK: - Transport

    func play(at index: Int) {
        guard playlist.indices.contains(index) else { return }
        currentIndex = index
        UserDefaults.standard.set(index, forKey: MusicDefaultsKey.lastIndex)
        startCurrent()
    }

    func togglePlayPause() {
        if isPlaying { pause() } else { play() }
    }

    func play() {
        if currentIndex == nil, !playlist.isEmpty {
            play(at: 0)
            return
        }
        guard let track = currentTrack else { return }
        if case .directURL = track.source {
            avPlayer.play()
        } else {
            webEngine.play()
        }
        isPlaying = true
        startTickIfNeeded()
        updateNowPlayingInfo()
    }

    func pause() {
        guard let track = currentTrack else { return }
        if case .directURL = track.source {
            avPlayer.pause()
        } else {
            webEngine.pause()
        }
        isPlaying = false
        updateNowPlayingInfo()
    }

    func stop() {
        avPlayer.pause()
        avPlayer.replaceCurrentItem(with: nil)
        webEngine.stop()
        isPlaying = false
        positionSeconds = 0
        stopTick()
        clearNowPlayingInfo()
    }

    func next() {
        advance(by: +1, userInitiated: true)
    }

    func previous() {
        // Restart current track if user is past 3s; otherwise jump back.
        if positionSeconds > 3, let track = currentTrack, case .directURL = track.source {
            seek(to: 0)
            return
        }
        advance(by: -1, userInitiated: true)
    }

    func seek(to seconds: Double) {
        guard let track = currentTrack, case .directURL = track.source else { return }
        let time = CMTime(seconds: max(0, seconds), preferredTimescale: 600)
        avPlayer.seek(to: time)
        positionSeconds = max(0, seconds)
        updateNowPlayingInfo()
    }

    // MARK: - Sleep timer

    func startSleepTimer(minutes: Int) {
        cancelSleepTimer()
        guard minutes > 0 else { return }
        let endsAt = Date().addingTimeInterval(TimeInterval(minutes * 60))
        sleepTimerEndsAt = endsAt
        sleepTimerTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(minutes) * 60 * 1_000_000_000)
            await MainActor.run {
                guard let self else { return }
                if self.sleepTimerEndsAt == endsAt {
                    self.pause()
                    self.sleepTimerEndsAt = nil
                }
            }
        }
    }

    func cancelSleepTimer() {
        sleepTimerTask?.cancel()
        sleepTimerTask = nil
        sleepTimerEndsAt = nil
    }

    // MARK: - Internals

    private func startCurrent() {
        guard let track = currentTrack else { return }
        positionSeconds = 0
        durationSeconds = track.durationSeconds ?? 0
        lastError = nil

        if case .directURL(let url) = track.source {
            webEngine.stop()
            let item = AVPlayerItem(url: url)
            avPlayer.replaceCurrentItem(with: item)
            avPlayer.play()
            isPlaying = true
        } else {
            avPlayer.pause()
            avPlayer.replaceCurrentItem(with: nil)
            webEngine.load(track.source)
            // isPlaying flips true once the engine reports `.playing`.
            isPlaying = true
        }
        startTickIfNeeded()
        updateNowPlayingInfo()
    }

    /// Move to the next/previous track. `userInitiated` distinguishes a
    /// natural end-of-track advance (which respects loopMode .one) from a
    /// "skip" button press (which always advances).
    private func advance(by step: Int, userInitiated: Bool) {
        guard !playlist.isEmpty else { return }
        if loopMode == .one, !userInitiated {
            startCurrent()
            return
        }

        if shuffleEnabled, !shuffledIndices.isEmpty {
            shufflePosition += step
            if shufflePosition < 0 || shufflePosition >= shuffledIndices.count {
                if loopMode == .all || userInitiated {
                    rebuildShuffleOrder()
                    shufflePosition = (shufflePosition + shuffledIndices.count) % shuffledIndices.count
                } else {
                    stop()
                    return
                }
            }
            play(at: shuffledIndices[shufflePosition])
            return
        }

        let cur = currentIndex ?? -step
        var next = cur + step
        if next >= playlist.count {
            if loopMode == .all || userInitiated {
                next = 0
            } else {
                stop()
                return
            }
        } else if next < 0 {
            next = playlist.count - 1
        }
        play(at: next)
    }

    private func rebuildShuffleOrder() {
        guard shuffleEnabled else {
            shuffledIndices = []
            shufflePosition = 0
            return
        }
        shuffledIndices = Array(playlist.indices).shuffled()
        if let cur = currentIndex,
           let pos = shuffledIndices.firstIndex(of: cur) {
            shufflePosition = pos
        } else {
            shufflePosition = 0
        }
    }

    private func fallbackTitle(for source: TrackSource) -> String {
        switch source {
        case .directURL(let url): return url.lastPathComponent
        case .youtube(let id):    return "YouTube · \(id)"
        case .spotify(let uri):
            let parts = uri.split(separator: ":")
            return parts.count >= 3 ? "Spotify · \(parts[2])" : uri
        case .soundcloud(let url): return "SoundCloud · \(url.lastPathComponent)"
        case .vimeo(let id):      return "Vimeo · \(id)"
        case .mixcloud(let path): return "Mixcloud · \(path)"
        }
    }

    // MARK: - Persistence

    private func loadPlaylistFromDefaults() {
        guard let data = UserDefaults.standard.data(forKey: MusicDefaultsKey.playlist) else { return }
        if let decoded = try? JSONDecoder().decode([Track].self, from: data) {
            playlist = decoded
            rebuildShuffleOrder()
        }
    }

    private func persistPlaylist() {
        if let data = try? JSONEncoder().encode(playlist) {
            UserDefaults.standard.set(data, forKey: MusicDefaultsKey.playlist)
        }
    }

    // MARK: - AVPlayer wiring

    private func installAVObservers() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        avTimeObserver = avPlayer.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            // The closure runs on the main queue but `self` is MainActor;
            // jump back through MainActor.assumeIsolated to satisfy strict
            // concurrency without spawning a Task per tick.
            MainActor.assumeIsolated {
                guard let self else { return }
                self.positionSeconds = CMTimeGetSeconds(time)
                if self.durationSeconds == 0,
                   let item = self.avPlayer.currentItem {
                    let dur = CMTimeGetSeconds(item.duration)
                    if dur.isFinite, dur > 0 { self.durationSeconds = dur }
                }
                self.updateNowPlayingPosition()
            }
        }

        avEndObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.handleTrackEnded()
            }
        }
    }

    private func wireWebEngine() {
        webEngine.onEvent = { [weak self] event in
            guard let self else { return }
            switch event {
            case .ready:
                self.lastError = nil
            case .playing:
                self.isPlaying = true
                self.updateNowPlayingInfo()
            case .paused:
                self.isPlaying = false
                self.updateNowPlayingInfo()
            case .ended:
                self.handleTrackEnded()
            case .failed(let reason):
                self.lastError = L10n.t("Playback failed: %@", reason)
                Log.music.error("Web engine failed: \(reason, privacy: .public)")
                // Auto-skip on hard failure so the playlist keeps moving.
                self.advance(by: +1, userInitiated: false)
            }
        }
    }

    private func handleTrackEnded() {
        if loopMode == .one {
            startCurrent()
        } else {
            advance(by: +1, userInitiated: false)
        }
    }

    // MARK: - Tick (position updates for UI)

    private func startTickIfNeeded() {
        guard tickTask == nil else { return }
        tickTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await MainActor.run {
                    // Force observation invalidation for sleepTimerRemainingSeconds.
                    guard let self, self.sleepTimerEndsAt != nil else { return }
                    self.sleepTimerEndsAt = self.sleepTimerEndsAt
                }
            }
        }
    }

    private func stopTick() {
        tickTask?.cancel()
        tickTask = nil
    }

    // MARK: - Now Playing widget

    private func updateNowPlayingInfo() {
        guard let track = currentTrack else { clearNowPlayingInfo(); return }
        var info: [String: Any] = [:]
        info[MPMediaItemPropertyTitle] = track.title
        if let artist = track.artist { info[MPMediaItemPropertyArtist] = artist }
        if let dur = track.durationSeconds { info[MPMediaItemPropertyPlaybackDuration] = dur }
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = positionSeconds
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info

        let cmd = MPRemoteCommandCenter.shared()
        cmd.playCommand.removeTarget(nil)
        cmd.pauseCommand.removeTarget(nil)
        cmd.togglePlayPauseCommand.removeTarget(nil)
        cmd.nextTrackCommand.removeTarget(nil)
        cmd.previousTrackCommand.removeTarget(nil)
        cmd.playCommand.addTarget { [weak self] _ in self?.play(); return .success }
        cmd.pauseCommand.addTarget { [weak self] _ in self?.pause(); return .success }
        cmd.togglePlayPauseCommand.addTarget { [weak self] _ in self?.togglePlayPause(); return .success }
        cmd.nextTrackCommand.addTarget { [weak self] _ in self?.next(); return .success }
        cmd.previousTrackCommand.addTarget { [weak self] _ in self?.previous(); return .success }
    }

    private func updateNowPlayingPosition() {
        guard MPNowPlayingInfoCenter.default().nowPlayingInfo != nil else { return }
        var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = positionSeconds
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    private func clearNowPlayingInfo() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
}
