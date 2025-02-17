import 'package:cosmos/pages/media_list/widgets/video_grid_view.dart';
import 'package:cosmos/pages/video_player/video_player_screen.dart';
import 'package:flutter/material.dart';

import '../../model/hehe_media.dart';

class VideoListScreen extends StatelessWidget {
  final List<HeHeMedia> videoList;

  const VideoListScreen({
    super.key,
    required this.videoList,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: VideoGridView(
                videoList: videoList,
                onVideoDetailScene: (video) {
                  final index = videoList.indexOf(video);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        videoList: videoList,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
