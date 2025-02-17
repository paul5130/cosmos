import 'package:flutter/material.dart';

import '../../../model/hehe_media.dart';
import 'video_card.dart';

class VideoGridView extends StatelessWidget {
  const VideoGridView({
    required this.videoList,
    required this.onVideoDetailScene,
    super.key,
  });
  final List<HeHeMedia> videoList;
  final void Function(HeHeMedia) onVideoDetailScene;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    // final bool isLandscape = screenWidth > screenHeight;
    final double childAspectRatio = 5 / 6;
    final int crossAxisCount = _calculateCrossAxisCount(screenWidth);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: videoList.length,
      itemBuilder: (context, index) {
        final video = videoList[index];
        return VideoCard(
          media: video,
          onPressed: onVideoDetailScene,
          onFavoritePressed: () {},
        );
      },
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth >= 1200) {
      return 6;
    } else if (screenWidth >= 800) {
      return 4;
    } else {
      return 2;
    }
  }
}
