import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'audio_player/audio_player_screen.dart';
import 'audio_list/providers/audio_list_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioListAsync = ref.watch(fetchAudioListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('音訊列表'),
      ),
      body: audioListAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text("讀取失敗: $error"),
        ),
        data: (mediaList) => ListView.builder(
          itemCount: mediaList.length,
          itemBuilder: (context, index) {
            final audio = mediaList[index];
            return ListTile(
              title: Text(audio.name),
              leading: const Icon(
                Icons.music_video_rounded,
                color: Colors.blueAccent,
              ),
              trailing: const Icon(
                Icons.favorite_border,
                color: Colors.black,
              ),
              onTap: () {
                debugPrint('play audio${audio.name}');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AudioPlayerScreen(
                      audioList: mediaList,
                      index: index,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
