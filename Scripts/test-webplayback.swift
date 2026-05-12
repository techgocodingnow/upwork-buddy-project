#!/usr/bin/env swift
// Standalone harness for WebPlaybackEngine YouTube loading.
// Usage: swift Scripts/test-webplayback.swift [videoId] [seconds]
// Default: videoId = s2L_V9S7ni4, seconds = 20
//
// Prints timestamped events from JS bridge + WebView navigation delegate.
// Exits 0 if a "playing" event arrives within timeout, 1 otherwise.

import AppKit
import WebKit

let videoId = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "s2L_V9S7ni4"
let timeoutSec = Double(CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "20") ?? 20

let start = Date()
func ts() -> String {
    String(format: "%.3f", Date().timeIntervalSince(start))
}
func log(_ s: String) {
    print("[\(ts())] \(s)")
    fflush(stdout)
}

final class Router: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
    var sawPlaying = false
    func userContentController(_ c: WKUserContentController, didReceive m: WKScriptMessage) {
        let raw = m.body as? String ?? "<non-string>"
        log("bridge: \(raw)")
        if raw == "playing" {
            sawPlaying = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                log("playing confirmed; exiting 0")
                exit(0)
            }
        }
    }
    func webView(_ w: WKWebView, didStartProvisionalNavigation n: WKNavigation!) {
        log("nav: start provisional")
    }
    func webView(_ w: WKWebView, didFinish n: WKNavigation!) {
        log("nav: finished")
    }
    func webView(_ w: WKWebView, didFail n: WKNavigation!, withError e: Error) {
        log("nav: failed \(e.localizedDescription)")
    }
    func webView(_ w: WKWebView, didFailProvisionalNavigation n: WKNavigation!, withError e: Error) {
        log("nav: provisional failed \(e.localizedDescription)")
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let router = Router()

let html = """
<!doctype html>
<html><head><meta charset="utf-8"><style>html,body{margin:0;background:#000;}</style></head>
<body>
<div id="player"></div>
<script>
  function post(kind) {
    try { window.webkit.messageHandlers.musicBridge.postMessage(kind); } catch (e) {}
  }
  post('boot:origin=' + window.location.origin + ' href=' + window.location.href);
  var tag = document.createElement('script');
  tag.src = "https://www.youtube.com/iframe_api";
  tag.onload = function() { post('iframe_api_loaded'); };
  tag.onerror = function() { post('iframe_api_error'); };
  document.head.appendChild(tag);
  function onYouTubeIframeAPIReady() {
    post('yt_api_ready');
    window.player = new YT.Player('player', {
      height: '180', width: '320',
      videoId: '\(videoId)',
      playerVars: { autoplay: 1, controls: 0, playsinline: 1, modestbranding: 1 },
      events: {
        onReady: function(e) { post('ready'); e.target.playVideo(); post('called_playVideo'); },
        onStateChange: function(e) {
          if (e.data === YT.PlayerState.PLAYING) post('playing');
          else if (e.data === YT.PlayerState.PAUSED) post('paused');
          else if (e.data === YT.PlayerState.ENDED) post('ended');
          else if (e.data === YT.PlayerState.BUFFERING) post('buffering');
          else if (e.data === YT.PlayerState.CUED) post('cued');
          else post('state:' + e.data);
        },
        onError: function(e) { post('error:' + e.data); }
      }
    });
    post('player_constructed');
  }
</script>
</body></html>
"""

let config = WKWebViewConfiguration()
config.mediaTypesRequiringUserActionForPlayback = []
let controller = WKUserContentController()
controller.add(router, name: "musicBridge")
config.userContentController = controller

let webView = WKWebView(frame: NSRect(x: 0, y: 0, width: 320, height: 200), configuration: config)
webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
webView.navigationDelegate = router

let panel = NSPanel(
    contentRect: NSRect(x: -10000, y: -10000, width: 320, height: 200),
    styleMask: [.borderless, .nonactivatingPanel],
    backing: .buffered,
    defer: false
)
panel.isReleasedWhenClosed = false
panel.level = .normal
panel.alphaValue = 0
panel.ignoresMouseEvents = true
panel.hidesOnDeactivate = false
panel.contentView = webView
panel.orderFrontRegardless()

log("loading HTML for videoId=\(videoId)")
let baseURLArg = ProcessInfo.processInfo.environment["BASE_URL"] ?? "https://www.youtube.com"
log("baseURL=\(baseURLArg)")
webView.loadHTMLString(html, baseURL: URL(string: baseURLArg))

DispatchQueue.main.asyncAfter(deadline: .now() + timeoutSec) {
    log("TIMEOUT after \(timeoutSec)s; sawPlaying=\(router.sawPlaying)")
    exit(router.sawPlaying ? 0 : 1)
}

app.run()
