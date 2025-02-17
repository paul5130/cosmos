import 'dart:io';

import 'package:audio_service/audio_service.dart';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../model/hehe_media.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  AudioPlayerHandler() {
    _player.playbackEventStream
        .map(
          _transformEvent,
        )
        .pipe(
          playbackState,
        );
  }

  MediaItem _toMediaitem(HeHeMedia media, Duration duration) => MediaItem(
        id: media.audioId != null ? media.audioId! : media.videoId!,
        title: media.name,
        artUri: media.imageUrl != null
            ? Uri.parse(
                media.imageUrl!,
              )
            : null,
        duration: duration,
      );
  Future<void> setupAudio(
    HeHeMedia media,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final filename =
        media.audioId != null ? '${media.audioId}.mp3' : '${media.videoId}.mp4';
    final file = File('${directory.path}/$filename');

    await _player.setAudioSource(AudioSource.file(file.path));

    final duration = _player.duration;
    if (duration != null) {
      final currentMediaItem = _toMediaitem(media, duration);
      mediaItem.add(currentMediaItem);
    }
    await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  Future<Duration> getCurrentPosition() async => _player.position;

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
