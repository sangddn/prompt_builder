import 'dart:async';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Service for interacting with YouTube videos using youtube_explode_dart
final class YoutubeService {
  /// Internal YouTube API client
  final _yt = YoutubeExplode();

  /// Closes the internal YouTube API client
  void dispose() {
    _yt.close();
  }

  /// Gets metadata about a YouTube video.
  ///
  /// Takes a YouTube [url] string parameter and returns a [Video] object containing
  /// metadata like title, description, duration etc.
  ///
  /// Example:
  /// ```dart
  /// final video = await youtubeService.getVideoInfo('https://youtube.com/watch?v=abc123');
  /// print(video.title);
  /// ```
  Future<Video> getVideoInfo(String url) async {
    final videoId = VideoId(url);
    return _yt.videos.get(videoId);
  }

  /// Gets the transcript or auto-generated captions for a YouTube video.
  ///
  /// Takes a YouTube [url] string parameter and returns the transcript text as a [String].
  /// Returns an empty string if no captions are available.
  ///
  /// For simplicity, this method fetches only the first available closed caption track.
  ///
  /// Example:
  /// ```dart
  /// final transcript = await youtubeService.getTranscript('https://youtube.com/watch?v=abc123');
  /// print(transcript);
  /// ```
  Future<String> getTranscript(String url) async {
    final videoId = VideoId(url);
    final manifest = await _yt.videos.closedCaptions.getManifest(videoId);
    // pick the first track
    if (manifest.tracks.isNotEmpty) {
      final track = manifest.tracks.first;
      final captions = await _yt.videos.closedCaptions.get(track);
      return captions.captions.map((c) => c.text).join(' ');
    }
    return '';
  }
}
