import 'package:cosmos/pages/video_list/providers/video_list_provider.dart';
import 'package:cosmos/pages/video_list/widgets/video_grid_view.dart';
import 'package:cosmos/pages/video_player/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoListScreen extends ConsumerWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final videoListAsync = ref.watch(fetchVideoListProvider);
          return videoListAsync.when(
            data: (videoList) {
              if (videoList.isEmpty) {
                return const Center(
                  child: Text('No data'),
                );
              } else {
                return Padding(
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
                );
              }
            },
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
