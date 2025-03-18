import 'package:audio_service/audio_service.dart';

import 'package:cosmos/main.dart';
import 'package:cosmos/providers/audio_list/favorite_audio_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/hehe_audio.dart';
import 'audio/seek_bar.dart';
import 'audio/media_state.dart';

class AudioPlayerScreen extends ConsumerStatefulWidget {
  final List<HeHeAudio> audioList;
  final int index;

  const AudioPlayerScreen({
    super.key,
    required this.audioList,
    required this.index,
  });

  @override
  ConsumerState<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends ConsumerState<AudioPlayerScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      audioPlayerHandler.setPlaylist(widget.audioList, widget.index);
    });
  }

  @override
  void dispose() {
    audioPlayerHandler.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteIds = ref.watch(favoriteAudioListNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Service'),
        actions: [
          StreamBuilder(
            stream: audioHandler.mediaItem,
            builder: (context, snapshot) {
              final isFavorite =
                  favoriteIds.contains(int.parse(snapshot.data?.id ?? '0'));
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  ref
                      .read(favoriteAudioListNotifierProvider.notifier)
                      .toggleFavorite(
                        int.parse(snapshot.data?.id ?? '0'),
                      );
                },
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<MediaItem?>(
              stream: audioHandler.mediaItem,
              builder: (context, snapshot) {
                final mediaItem = snapshot.data;
                return Text(mediaItem?.title ?? '');
              },
            ),
            // Play/pause/stop buttons.
            StreamBuilder<bool>(
              stream: audioHandler.playbackState
                  .map((state) => state.playing)
                  .distinct(),
              builder: (context, snapshot) {
                final playing = snapshot.data ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(Icons.skip_previous, audioHandler.skipToPrevious),
                    if (playing)
                      _button(Icons.pause, audioHandler.pause)
                    else
                      _button(Icons.play_arrow, audioHandler.play),
                    _button(Icons.stop, audioHandler.stop),
                    _button(Icons.skip_next, audioHandler.skipToNext),
                  ],
                );
              },
            ),
            // A seek bar.
            StreamBuilder<MediaState>(
              stream: _mediaStateStream,
              builder: (context, snapshot) {
                final mediaState = snapshot.data;
                return SeekBar(
                  duration: mediaState?.mediaItem?.duration ?? Duration.zero,
                  position: mediaState?.position ?? Duration.zero,
                  onChangeEnd: (newPosition) {
                    audioHandler.seek(newPosition);
                  },
                );
              },
            ),
            // Display the processing state.
            StreamBuilder<AudioProcessingState>(
              stream: audioHandler.playbackState
                  .map((state) => state.processingState)
                  .distinct(),
              builder: (context, snapshot) {
                final processingState =
                    snapshot.data ?? AudioProcessingState.idle;
                return Text("Processing state: ${processingState.toString()}");
              },
            ),
          ],
        ),
      ),
    );
  }

  IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
        icon: Icon(iconData),
        iconSize: 64.0,
        onPressed: onPressed,
      );

  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          audioHandler.mediaItem,
          AudioService.position,
          (mediaItem, position) => MediaState(mediaItem, position));
}
