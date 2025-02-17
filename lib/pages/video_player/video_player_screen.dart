import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:cosmos/main.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:video_player/video_player.dart';

import '../../model/hehe_media.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.videoList,
    required this.index,
  });
  final List<HeHeMedia> videoList;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  String? _localFilePath;
  bool _isInitialized = false;
  Duration _backgroundPosition = Duration.zero;
  late int _currentIndex;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentIndex = widget.index;
    _checkOrDownloadVideo();
  }

  Future<void> _initializeVideo() async {
    if (_localFilePath == null) return;
    _controller = VideoPlayerController.file(
      File(
        _localFilePath!,
      ),
    );
    await _controller!.initialize();
    setState(() {
      _isInitialized = true;
    });
    // _controller!.setVolume(0.0);
    _controller!.play();
    // _controller!.value.duration;
    audioPlayerHandler.setupAudio(
      widget.videoList[_currentIndex],
      _controller!.value.duration,
    );
    _controller!.addListener(() {
      if (_controller!.value.position >= _controller!.value.duration) {
        _playNextVideo();
      }
    });

    /// 要做背景切換播放模式--------
    // _controller
    //   ..addListener(_videoListener)
    //   ..setLooping(false)
    //   ..initialize().then((_) {
    //     setState(() {});
    //     _controller.play();
    //   });
  }

  Future<void> _playNextVideo() async {
    if (_currentIndex + 1 < widget.videoList.length) {
      _currentIndex++;
      debugPrint('Playing next video: ${widget.videoList[_currentIndex].name}');
      _isInitialized = false;
      _checkOrDownloadVideo();
    } else {
      debugPrint('Played all videos');
    }
  }

  Future<void> _checkOrDownloadVideo() async {
    final localFile =
        await _getLocalFile(widget.videoList[_currentIndex].videoId!);
    if (await localFile.exists()) {
      _localFilePath = localFile.path;
      _initializeVideo();
    } else {
      _downloadAndPlay(
        widget.videoList[_currentIndex],
      );
    }
    _preDownloadNextVideo();
  }

  Future<void> _preDownloadNextVideo() async {
    final nextIndex = _currentIndex + 1;
    if (nextIndex < widget.videoList.length) {
      final nextVideo = widget.videoList[nextIndex];
      final localFile = await _getLocalFile(nextVideo.videoId!);
      if (!await localFile.exists()) {
        debugPrint('predownloading video: ${nextVideo.name}');
        _downloadVideo(nextVideo);
      } else {
        debugPrint('${nextVideo.name} exists, skip download.');
      }
    }
  }

  Future<void> _downloadVideo(HeHeMedia video) async {
    // final file = await _getLocalFile(video.id);
    final task = DownloadTask(
        url: video.videoUrl!,
        filename: '${video.videoId}.mp4',
        baseDirectory: BaseDirectory.applicationDocuments,
        updates: Updates.statusAndProgress);
    final result = await FileDownloader().download(
      task,
      onProgress: (progress) {
        int percentage = (progress * 100).toInt();
        debugPrint('Download ${video.name} progress: $percentage%');
      },
    );
    if (result.status == TaskStatus.complete) {
      debugPrint('${video.name} downloaded');
    } else {
      debugPrint('Failed to download ${video.name} - ${result.status}');
    }
  }

  Future<void> _downloadAndPlay(
    HeHeMedia video,
  ) async {
    // setState(() {
    //   _isDownloading = true;
    // });
    final file = await _getLocalFile(video.videoId!);
    final task = DownloadTask(
        url: video.videoUrl!,
        filename: '${video.videoId}.mp4',
        baseDirectory: BaseDirectory.applicationDocuments,
        updates: Updates.statusAndProgress);
    final result = await FileDownloader().download(
      task,
      onProgress: (progress) {
        int percentage = (progress * 100).toInt();
        debugPrint('Download ${video.name} progress: $percentage%');
      },
    );
    if (result.status == TaskStatus.complete) {
      _localFilePath = file.path;
      _initializeVideo();
    } else {
      debugPrint('Failed to download video file: ${result.status}');
    }
    // setState(() {
    //   _isDownloading = false;
    // });
  }

  Future<File> _getLocalFile(String videoId) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$videoId.mp4');
  }

  @override
  void dispose() {
    // audioPlayerHandler.stop();
    WidgetsBinding.instance.removeObserver(this);
    // _controller!.removeListener(_videoListener);
    if (_controller != null) {
      _controller!.dispose();
    }

    audioPlayerHandler.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoList[_currentIndex].name),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: _isInitialized
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_controller != null && _controller!.value.isPlaying) {
        _backgroundPosition = _controller!.value.position;
        _controller?.pause();
        debugPrint('Stop video controller');
        audioPlayerHandler
            .playAudio(
          widget.videoList[_currentIndex],
          _backgroundPosition,
        )
            .then((_) {
          debugPrint('audio is playing');
        }).catchError((error) {
          debugPrint('Failed to play audio: $error');
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      audioPlayerHandler.getCurrentPosition().then((audioPosition) {
        audioPlayerHandler.pause();
        debugPrint('Stop audio player');
        _controller?.seekTo(audioPosition);
        debugPrint('play video in position: $audioPosition');
        _controller?.play();
      }).catchError((error) {
        debugPrint('Failed to recover video : $error');
      });
    }
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Audio Service Demo'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           // Show media item title
  //           StreamBuilder<MediaItem?>(
  //             stream: audioHandler.mediaItem,
  //             builder: (context, snapshot) {
  //               final mediaItem = snapshot.data;
  //               return Text(mediaItem?.title ?? '');
  //             },
  //           ),
  //           // Play/pause/stop buttons.
  //           StreamBuilder<bool>(
  //             stream: audioHandler.playbackState
  //                 .map((state) => state.playing)
  //                 .distinct(),
  //             builder: (context, snapshot) {
  //               final playing = snapshot.data ?? false;
  //               return Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   // _button(Icons.fast_rewind, audioHandler.rewind),
  //                   if (playing)
  //                     _button(Icons.pause, audioHandler.pause)
  //                   else
  //                     _button(Icons.play_arrow, audioHandler.play),
  //                   // _button(Icons.stop, audioHandler.stop),
  //                   // _button(Icons.fast_forward, audioHandler.fastForward),
  //                 ],
  //               );
  //             },
  //           ),
  //           // A seek bar.
  //           StreamBuilder<MediaState>(
  //             stream: _mediaStateStream,
  //             builder: (context, snapshot) {
  //               final mediaState = snapshot.data;
  //               return SeekBar(
  //                 duration: mediaState?.mediaItem?.duration ?? Duration.zero,
  //                 position: mediaState?.position ?? Duration.zero,
  //                 onChangeEnd: (newPosition) {
  //                   audioHandler.seek(newPosition);
  //                 },
  //               );
  //             },
  //           ),
  //           // Display the processing state.
  //           StreamBuilder<AudioProcessingState>(
  //             stream: audioHandler.playbackState
  //                 .map((state) => state.processingState)
  //                 .distinct(),
  //             builder: (context, snapshot) {
  //               final processingState =
  //                   snapshot.data ?? AudioProcessingState.idle;
  //               return Text(
  //                   // ignore: deprecated_member_use
  //                   "Processing state: ${describeEnum(processingState)}");
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _enterFullScreen() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  // }

  // void _exitFullScreen() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  // }

  // IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
  //       icon: Icon(iconData),
  //       iconSize: 64.0,
  //       onPressed: onPressed,
  //     );
  // Stream<MediaState> get _mediaStateStream =>
  //     Rx.combineLatest2<MediaItem?, Duration, MediaState>(
  //         audioHandler.mediaItem,
  //         AudioService.position,
  //         (mediaItem, position) => MediaState(mediaItem, position));
}
