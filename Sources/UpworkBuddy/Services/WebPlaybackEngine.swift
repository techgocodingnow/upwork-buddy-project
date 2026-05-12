import Foundation
import WebKit
import AppKit

/// Hosts a hidden `WKWebView` for sources that can't be played natively
/// (YouTube IFrame embed, Spotify embed iframe). Exposes a tiny imperative
/// surface — load, play, pause, stop — and reports lifecycle events back to
/// the owning service via `onEvent`.
@MainActor
final class WebPlaybackEngine: NSObject {
    enum Event: Sendable {
        case ready
        case playing
        case paused
        case ended
        case failed(String)
    }

    /// Sink invoked on the main actor. The owning service swaps engines /
    /// advances the playlist based on these events.
    var onEvent: (@MainActor (Event) -> Void)?

    private var webView: WKWebView?
    private var hostWindow: NSWindow?
    private var currentSource: TrackSource?

    // MARK: - Public surface

    func load(_ source: TrackSource) {
        currentSource = source
        let html: String
        let baseURL: URL?
        switch source {
        case .youtube(let id):
            html = Self.youTubeHTML(videoId: id)
            baseURL = URL(string: "https://www.youtube.com")
        case .spotify(let uri):
            html = Self.spotifyHTML(uri: uri)
            baseURL = URL(string: "https://open.spotify.com")
        case .soundcloud(let url):
            html = Self.soundCloudHTML(trackURL: url.absoluteString)
            baseURL = URL(string: "https://soundcloud.com")
        case .vimeo(let id):
            html = Self.vimeoHTML(videoId: id)
            baseURL = URL(string: "https://player.vimeo.com")
        case .mixcloud(let path):
            html = Self.mixcloudHTML(feedPath: path)
            baseURL = URL(string: "https://www.mixcloud.com")
        case .directURL:
            // Direct URLs are owned by AVPlayer — engine never sees them.
            return
        }
        let view = ensureWebView()
        view.loadHTMLString(html, baseURL: baseURL)
    }

    func play() {
        switch currentSource {
        case .youtube:
            evaluate("if (window.player && window.player.playVideo) { window.player.playVideo(); }")
        case .spotify:
            evaluate("if (window.spotifyController) { window.spotifyController.resume(); }")
        case .soundcloud:
            evaluate("if (window.scWidget) { window.scWidget.play(); }")
        case .vimeo:
            evaluate("if (window.vimeoPlayer) { window.vimeoPlayer.play(); }")
        case .mixcloud:
            evaluate("if (window.mixcloudWidget) { window.mixcloudWidget.play(); }")
        default:
            break
        }
    }

    func pause() {
        switch currentSource {
        case .youtube:
            evaluate("if (window.player && window.player.pauseVideo) { window.player.pauseVideo(); }")
        case .spotify:
            evaluate("if (window.spotifyController) { window.spotifyController.pause(); }")
        case .soundcloud:
            evaluate("if (window.scWidget) { window.scWidget.pause(); }")
        case .vimeo:
            evaluate("if (window.vimeoPlayer) { window.vimeoPlayer.pause(); }")
        case .mixcloud:
            evaluate("if (window.mixcloudWidget) { window.mixcloudWidget.pause(); }")
        default:
            break
        }
    }

    func stop() {
        currentSource = nil
        webView?.stopLoading()
        webView?.loadHTMLString("<html><body></body></html>", baseURL: nil)
    }

    func tearDown() {
        if let view = webView {
            view.stopLoading()
            view.configuration.userContentController.removeAllScriptMessageHandlers()
            webView = nil
        }
        hostWindow?.orderOut(nil)
        hostWindow?.contentView = nil
        hostWindow = nil
        currentSource = nil
    }

    // MARK: - WebView lifecycle

    private func ensureWebView() -> WKWebView {
        if let view = webView { return view }

        let config = WKWebViewConfiguration()
        config.mediaTypesRequiringUserActionForPlayback = []
        let controller = WKUserContentController()
        controller.add(MessageRouter(engine: self), name: "musicBridge")
        config.userContentController = controller

        let frame = NSRect(x: 0, y: 0, width: 320, height: 200)
        let view = WKWebView(frame: frame, configuration: config)
        // Spoof a desktop browser UA so YouTube/SoundCloud serve the full
        // player instead of the mobile site, which sometimes blocks autoplay.
        view.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) "
            + "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
        webView = view

        // Host inside an offscreen NSWindow. macOS gates WKWebView media
        // playback on the view being attached to a window — a detached
        // WebProcess often suspends audio playback silently. Off-screen
        // borderless window keeps it active without showing chrome.
        let window = NSWindow(
            contentRect: NSRect(x: -10000, y: -10000, width: 320, height: 200),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        window.level = .floating
        window.alphaValue = 0
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.transient, .ignoresCycle, .stationary]
        window.contentView = view
        window.orderOut(nil)
        // Briefly order in (then off-screen) so the WebProcess attaches.
        // Without this, some macOS versions never wake the media pipeline.
        window.orderFront(nil)
        hostWindow = window
        return view
    }

    private func evaluate(_ js: String) {
        webView?.evaluateJavaScript(js, completionHandler: nil)
    }

    fileprivate func dispatch(event: Event) {
        onEvent?(event)
    }

    // MARK: - HTML payloads

    /// YouTube IFrame Player API host page. Loads the IFrame API script, then
    /// instantiates a Player on a hidden div. State changes ride through
    /// `window.webkit.messageHandlers.musicBridge` back into Swift.
    private static func youTubeHTML(videoId: String) -> String {
        """
        <!doctype html>
        <html><head><meta charset="utf-8"><style>html,body{margin:0;background:#000;}</style></head>
        <body>
        <div id="player"></div>
        <script>
          var tag = document.createElement('script');
          tag.src = "https://www.youtube.com/iframe_api";
          document.head.appendChild(tag);
          function post(kind) {
            try { window.webkit.messageHandlers.musicBridge.postMessage(kind); } catch (e) {}
          }
          function onYouTubeIframeAPIReady() {
            window.player = new YT.Player('player', {
              height: '180', width: '320',
              videoId: '\(videoId)',
              playerVars: { autoplay: 1, controls: 0, playsinline: 1, modestbranding: 1, origin: 'https://www.youtube.com' },
              events: {
                onReady: function(e) { post('ready'); e.target.playVideo(); },
                onStateChange: function(e) {
                  if (e.data === YT.PlayerState.PLAYING) post('playing');
                  else if (e.data === YT.PlayerState.PAUSED) post('paused');
                  else if (e.data === YT.PlayerState.ENDED) post('ended');
                },
                onError: function(e) { post('error:' + e.data); }
              }
            });
          }
        </script>
        </body></html>
        """
    }

    /// SoundCloud Widget API host page. The official `w.soundcloud.com/player`
    /// iframe + `https://w.soundcloud.com/player/api.js` give us play/pause
    /// + finish events. Works for tracks and sets without auth.
    private static func soundCloudHTML(trackURL: String) -> String {
        let escaped = trackURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? trackURL
        return """
        <!doctype html>
        <html><head><meta charset="utf-8"><style>html,body{margin:0;background:#000;}</style></head>
        <body>
        <iframe id="sc" width="100%" height="80" scrolling="no" frameborder="no"
          src="https://w.soundcloud.com/player/?url=\(escaped)&auto_play=true&hide_related=true&show_comments=false&show_user=false&show_reposts=false&visual=false"></iframe>
        <script src="https://w.soundcloud.com/player/api.js"></script>
        <script>
          function post(kind) {
            try { window.webkit.messageHandlers.musicBridge.postMessage(kind); } catch (e) {}
          }
          var iframe = document.getElementById('sc');
          window.scWidget = SC.Widget(iframe);
          window.scWidget.bind(SC.Widget.Events.READY, function() {
            post('ready');
            window.scWidget.play();
          });
          window.scWidget.bind(SC.Widget.Events.PLAY,   function() { post('playing'); });
          window.scWidget.bind(SC.Widget.Events.PAUSE,  function() { post('paused'); });
          window.scWidget.bind(SC.Widget.Events.FINISH, function() { post('ended'); });
          window.scWidget.bind(SC.Widget.Events.ERROR,  function() { post('error:soundcloud'); });
        </script>
        </body></html>
        """
    }

    /// Vimeo Player API host page. Audio rides through the same player as
    /// video. Required for any music-video track.
    private static func vimeoHTML(videoId: String) -> String {
        """
        <!doctype html>
        <html><head><meta charset="utf-8"><style>html,body{margin:0;background:#000;}</style></head>
        <body>
        <iframe id="vimeo" src="https://player.vimeo.com/video/\(videoId)?autoplay=1&playsinline=1&controls=0"
          width="320" height="180" frameborder="0" allow="autoplay; fullscreen"></iframe>
        <script src="https://player.vimeo.com/api/player.js"></script>
        <script>
          function post(kind) {
            try { window.webkit.messageHandlers.musicBridge.postMessage(kind); } catch (e) {}
          }
          var iframe = document.getElementById('vimeo');
          window.vimeoPlayer = new Vimeo.Player(iframe);
          window.vimeoPlayer.ready().then(function() {
            post('ready');
            window.vimeoPlayer.play().catch(function() {});
          });
          window.vimeoPlayer.on('play',  function() { post('playing'); });
          window.vimeoPlayer.on('pause', function() { post('paused'); });
          window.vimeoPlayer.on('ended', function() { post('ended'); });
          window.vimeoPlayer.on('error', function() { post('error:vimeo'); });
        </script>
        </body></html>
        """
    }

    /// Mixcloud Widget API host page. Mixcloud bans third-party audio
    /// extraction but the official iframe + widget JS is on-policy.
    private static func mixcloudHTML(feedPath: String) -> String {
        let feed = "https://www.mixcloud.com\(feedPath)"
        let escaped = feed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? feed
        return """
        <!doctype html>
        <html><head><meta charset="utf-8"><style>html,body{margin:0;background:#000;}</style></head>
        <body>
        <iframe id="mix" width="100%" height="60" frameborder="0"
          src="https://www.mixcloud.com/widget/iframe/?feed=\(escaped)&hide_cover=1&autoplay=1&light=0"></iframe>
        <script src="https://widget.mixcloud.com/media/js/widgetApi.js"></script>
        <script>
          function post(kind) {
            try { window.webkit.messageHandlers.musicBridge.postMessage(kind); } catch (e) {}
          }
          var iframe = document.getElementById('mix');
          window.mixcloudWidget = Mixcloud.PlayerWidget(iframe);
          window.mixcloudWidget.ready.then(function() {
            post('ready');
            window.mixcloudWidget.play();
            window.mixcloudWidget.events.play.on(function()  { post('playing'); });
            window.mixcloudWidget.events.pause.on(function() { post('paused'); });
            window.mixcloudWidget.events.ended.on(function() { post('ended'); });
            window.mixcloudWidget.events.error.on(function() { post('error:mixcloud'); });
          });
        </script>
        </body></html>
        """
    }

    /// Spotify embed host page. Uses Spotify's iframe-api to wrap the embed
    /// in a controller exposing `play/pause/resume`.
    private static func spotifyHTML(uri: String) -> String {
        """
        <!doctype html>
        <html><head><meta charset="utf-8"><style>html,body{margin:0;background:#000;}</style></head>
        <body>
        <div id="embed"></div>
        <script src="https://open.spotify.com/embed/iframe-api/v1"></script>
        <script>
          function post(kind) {
            try { window.webkit.messageHandlers.musicBridge.postMessage(kind); } catch (e) {}
          }
          window.onSpotifyIframeApiReady = function(IFrameAPI) {
            var element = document.getElementById('embed');
            var options = { uri: '\(uri)', width: '100%', height: 80 };
            IFrameAPI.createController(element, options, function(controller) {
              window.spotifyController = controller;
              post('ready');
              controller.addListener('ready', function() { controller.resume(); });
              controller.addListener('playback_update', function(e) {
                if (e && e.data) {
                  if (e.data.isPaused) post('paused');
                  else post('playing');
                  if (e.data.position !== undefined && e.data.duration > 0
                      && e.data.position >= e.data.duration - 250) post('ended');
                }
              });
            });
          };
        </script>
        </body></html>
        """
    }
}

// MARK: - Bridge

/// Bridges JS `webkit.messageHandlers.musicBridge.postMessage(...)` into
/// `WebPlaybackEngine.Event`. Held weakly to avoid retain cycles with the
/// `WKUserContentController`. WebKit delivers script messages on the main
/// thread, so `@MainActor` isolation matches reality.
@MainActor
private final class MessageRouter: NSObject, WKScriptMessageHandler {
    weak var engine: WebPlaybackEngine?

    init(engine: WebPlaybackEngine) {
        self.engine = engine
    }

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        let raw = message.body as? String ?? ""
        guard let engine else { return }
        switch raw {
        case "ready":   engine.dispatch(event: .ready)
        case "playing": engine.dispatch(event: .playing)
        case "paused":  engine.dispatch(event: .paused)
        case "ended":   engine.dispatch(event: .ended)
        default:
            if raw.hasPrefix("error:") {
                engine.dispatch(event: .failed(String(raw.dropFirst("error:".count))))
            }
        }
    }
}
