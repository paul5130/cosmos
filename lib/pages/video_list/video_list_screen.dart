import 'package:cosmos/pages/video_list/providers/video_list_provider.dart';
import 'package:cosmos/pages/video_list/widgets/video_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoListScreen extends ConsumerWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video List'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final videoList = ref.watch(videoListProviderProvider);
          if (videoList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: VideoGridView(
                      videoList: videoList,
                      onVideoDetailScene: (video) {},
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
