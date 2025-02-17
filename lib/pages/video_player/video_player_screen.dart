import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../main.dart';
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

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     if (_controller != null && _controller!.value.isPlaying) {
  //       _backgroundPosition = _controller!.value.position;
  //       _controller?.pause();
  //       debugPrint('Stop video controller');
  //       audioPlayerHandler
  //           .playAudio(
  //         widget.videoList[_currentIndex],
  //         _backgroundPosition,
  //       )
  //           .then((_) {
  //         debugPrint('audio is playing');
  //       }).catchError((error) {
  //         debugPrint('Failed to play audio: $error');
  //       });
  //     }
  //   } else if (state == AppLifecycleState.resumed) {
  //     audioPlayerHandler.getCurrentPosition().then((audioPosition) {
  //       audioPlayerHandler.pause();
  //       debugPrint('Stop audio player');
  //       _controller?.seekTo(audioPosition);
  //       debugPrint('play video in position: $audioPosition');
  //       _controller?.play();
  //     }).catchError((error) {
  //       debugPrint('Failed to recover video : $error');
  //     });
  //   }
  // }
}
