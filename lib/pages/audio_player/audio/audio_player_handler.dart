import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';

import '../../../model/hehe_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  int _currentIndex = 0;
  List<HeHeAudio> _audioList = [];
  AudioPlayerHandler() {
    _initAudioSession();
    _player.playbackEventStream
        .map(
          _transformEvent,
        )
        .pipe(
          playbackState,
        );
    _player.playbackEventStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        skipToNext();
      }
    });
  }
  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    await session.setActive(true);
  }

  void setPlaylist(
    List<HeHeAudio> audioList,
    int index,
  ) {
    _currentIndex = index;
    _audioList = audioList;

    _setupMediaItem(audioList[_currentIndex]);
  }

  Future<void> _setupMediaItem(HeHeAudio audio) async {
    try {
      await _player.setAsset('assets/audio/${audio.pathname}');
      final duration = _player.duration;
      if (duration != null) {
        final currentaudioItem = _toMediaitem(
          audio,
          duration,
        );
        mediaItem.add(currentaudioItem);
      }
      debugPrint('Setting up media item ${audio.originalFilename}');
      await _player.play();
    } catch (e) {
      debugPrint('Error setting up media item ${e.toString()}');
    }
  }

  MediaItem _toMediaitem(
    HeHeAudio audio,
    Duration duration,
  ) =>
      MediaItem(
        id: audio.index.toString(),
        title: audio.originalFilename,
        artUri: null,
        duration: duration,
      );

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToNext() async {
    debugPrint('Skip to next');
    await _player.stop();
    if (_currentIndex < _audioList.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
    await _setupMediaItem(_audioList[_currentIndex]);
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.stop();
    if (_currentIndex > 0) {
      _currentIndex--;
    }
    await _setupMediaItem(_audioList[_currentIndex]);
  }

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: {
        ProcessingState.idle: Platform.isIOS
            ? AudioProcessingState.ready
            : AudioProcessingState.idle,
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
