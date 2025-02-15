import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cosmos/model/hehe_video.dart';
import 'package:flutter/foundation.dart';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  // static final _item = MediaItem(
  //   id: 'https://drive.usercontent.google.com/download?id=1qT387MGL_1IWotbCuOYFZBxhGObveDFM',
  //   album: "Science Friday",
  //   title: "A Salute To Head-Scratching Science",
  //   artist: "Science Friday and WNYC Studios",
  //   // duration: const Duration(milliseconds: 5739820),
  //   artUri: Uri.parse(
  //       'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
  // );

  final _player = AudioPlayer();
  AudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }
  Future<void> setupAudio(
    HeHeVideo video,
    Duration duration,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${video.id}.mp4');
    final mediaItem = MediaItem(
      id: video.id,
      title: video.name,
      artUri: Uri.parse(video.imageUrl),
      duration: duration,
    );
    this.mediaItem.add(mediaItem);
    _player.setAudioSource(AudioSource.file(file.path));
  }

  Future<void> playAudio(
    HeHeVideo video,
    Duration position,
  ) async {
    // final directory = await getApplicationDocumentsDirectory();
    // final file = File('${directory.path}/${video.id}.mp4');
    // _player.setAudioSource(AudioSource.file(file.path));
    debugPrint('play audio in position: $position');
    await _player.seek(position);
    await _player.play();
  }
  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

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
