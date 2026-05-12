import Testing
import Foundation
@testable import UpworkBuddy

@Suite("MusicURLParser")
struct MusicURLParserTests {

    // MARK: - YouTube

    @Test func parsesYouTubeWatch() {
        let r = MusicURLParser.parse("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
        guard case .youtube(let id) = r else {
            Issue.record("expected .youtube, got \(String(describing: r))"); return
        }
        #expect(id == "dQw4w9WgXcQ")
    }

    @Test func parsesYouTuBeShortLink() {
        let r = MusicURLParser.parse("https://youtu.be/dQw4w9WgXcQ")
        guard case .youtube(let id) = r else {
            Issue.record("expected .youtube"); return
        }
        #expect(id == "dQw4w9WgXcQ")
    }

    @Test func parsesYouTubeShorts() {
        let r = MusicURLParser.parse("https://www.youtube.com/shorts/abcdefghijk")
        guard case .youtube(let id) = r else {
            Issue.record("expected .youtube"); return
        }
        #expect(id == "abcdefghijk")
    }

    @Test func parsesYouTubeEmbed() {
        let r = MusicURLParser.parse("https://www.youtube.com/embed/abcdefghijk")
        guard case .youtube(let id) = r else {
            Issue.record("expected .youtube"); return
        }
        #expect(id == "abcdefghijk")
    }

    @Test func parsesYouTubeMusicDomain() {
        let r = MusicURLParser.parse("https://music.youtube.com/watch?v=dQw4w9WgXcQ")
        guard case .youtube(let id) = r else {
            Issue.record("expected .youtube"); return
        }
        #expect(id == "dQw4w9WgXcQ")
    }

    @Test func parsesYouTubeWatchWithExtraParams() {
        let r = MusicURLParser.parse("https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=42s&list=PL123")
        guard case .youtube(let id) = r else {
            Issue.record("expected .youtube"); return
        }
        #expect(id == "dQw4w9WgXcQ")
    }

    @Test func rejectsTooShortYouTubeId() {
        let r = MusicURLParser.parse("https://youtu.be/short")
        // Falls back to direct URL since YT path didn't validate.
        guard case .directURL = r else {
            Issue.record("expected directURL fallback"); return
        }
    }

    // MARK: - Spotify

    @Test func parsesSpotifyURI() {
        let r = MusicURLParser.parse("spotify:track:6rqhFgbbKwnb9MLmUQDhG6")
        guard case .spotify(let uri) = r else { Issue.record("expected spotify"); return }
        #expect(uri == "spotify:track:6rqhFgbbKwnb9MLmUQDhG6")
    }

    @Test func parsesSpotifyOpenURL() {
        let r = MusicURLParser.parse("https://open.spotify.com/track/6rqhFgbbKwnb9MLmUQDhG6")
        guard case .spotify(let uri) = r else { Issue.record("expected spotify"); return }
        #expect(uri == "spotify:track:6rqhFgbbKwnb9MLmUQDhG6")
    }

    @Test func parsesSpotifyOpenURLWithLocale() {
        let r = MusicURLParser.parse("https://open.spotify.com/intl-en/playlist/37i9dQZF1DXcBWIGoYBM5M")
        guard case .spotify(let uri) = r else { Issue.record("expected spotify"); return }
        #expect(uri == "spotify:playlist:37i9dQZF1DXcBWIGoYBM5M")
    }

    @Test func parsesSpotifyAlbumAndEpisode() {
        if case .spotify(let a) = MusicURLParser.parse("spotify:album:ABC") {
            #expect(a == "spotify:album:ABC")
        } else { Issue.record("album") }
        if case .spotify(let e) = MusicURLParser.parse("spotify:episode:XYZ") {
            #expect(e == "spotify:episode:XYZ")
        } else { Issue.record("episode") }
    }

    @Test func rejectsUnknownSpotifyKind() {
        let r = MusicURLParser.parse("spotify:weird:1234")
        // Falls back to directURL path → URL parsing of "spotify:weird:1234" → no http scheme, so nil
        #expect(r == nil)
    }

    @Test func stripsSpotifyQueryParams() {
        let r = MusicURLParser.parse("https://open.spotify.com/track/abc?si=xyz")
        guard case .spotify(let uri) = r else { Issue.record("expected spotify"); return }
        #expect(uri == "spotify:track:abc")
    }

    // MARK: - SoundCloud / Vimeo / Mixcloud

    @Test func parsesSoundCloud() {
        let r = MusicURLParser.parse("https://soundcloud.com/artist/song")
        guard case .soundcloud(let url) = r else { Issue.record("expected soundcloud"); return }
        #expect(url.host == "soundcloud.com")
    }

    @Test func rejectsSoundCloudWithoutPath() {
        let r = MusicURLParser.parse("https://soundcloud.com")
        // Falls back to directURL since host has no path segments.
        guard case .directURL = r else { Issue.record("expected directURL"); return }
    }

    @Test func parsesVimeo() {
        let r = MusicURLParser.parse("https://vimeo.com/123456789")
        guard case .vimeo(let id) = r else { Issue.record("expected vimeo"); return }
        #expect(id == "123456789")
    }

    @Test func parsesVimeoPlayer() {
        let r = MusicURLParser.parse("https://player.vimeo.com/video/123456789")
        guard case .vimeo(let id) = r else { Issue.record("expected vimeo"); return }
        #expect(id == "123456789")
    }

    @Test func parsesMixcloud() {
        let r = MusicURLParser.parse("https://www.mixcloud.com/userhandle/some-mix/")
        guard case .mixcloud(let path) = r else { Issue.record("expected mixcloud"); return }
        #expect(path == "/userhandle/some-mix/")
    }

    // MARK: - Direct URL fallback

    @Test func parsesDirectHTTPSAsFallback() {
        let r = MusicURLParser.parse("https://example.com/song.mp3")
        guard case .directURL(let url) = r else { Issue.record("expected directURL"); return }
        #expect(url.absoluteString == "https://example.com/song.mp3")
    }

    @Test func parsesFileURLAsDirect() {
        let r = MusicURLParser.parse("file:///tmp/song.mp3")
        guard case .directURL = r else { Issue.record("expected directURL"); return }
    }

    @Test func trimsWhitespace() {
        let r = MusicURLParser.parse("   https://youtu.be/dQw4w9WgXcQ  \n")
        guard case .youtube(let id) = r else { Issue.record("expected youtube"); return }
        #expect(id == "dQw4w9WgXcQ")
    }

    @Test func rejectsEmpty() {
        #expect(MusicURLParser.parse("") == nil)
        #expect(MusicURLParser.parse("   ") == nil)
    }

    @Test func rejectsNonURLGarbage() {
        #expect(MusicURLParser.parse("not a url") == nil)
    }
}
