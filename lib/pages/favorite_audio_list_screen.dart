import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/audio_list/audio_list_provider.dart';
import '../providers/audio_list/favorite_audio_list_provider.dart';
import 'audio_player/audio_player_screen.dart';

class FavoriteAudioListScreen extends ConsumerWidget {
  const FavoriteAudioListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioListAsync = ref.watch(
      fetchAudioListProvider,
    );
    final favoriteIds = ref.watch(favoriteAudioListNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('收藏列表'),
        actions: favoriteIds.isNotEmpty
            ? [
                IconButton(
                  onPressed: () {
                    final audioList =
                        ref.read(fetchAudioListProvider).value ?? [];
                    final favoriteList = audioList
                        .where((audio) => favoriteIds.contains(audio.index))
                        .toList();
                    if (favoriteList.isNotEmpty) {
                      final shuffledList = List.of(favoriteList)..shuffle();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AudioPlayerScreen(
                            audioList: shuffledList,
                            index: 0,
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.shuffle),
                ),
              ]
            : [],
      ),
      body: audioListAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text("讀取失敗: $error"),
        ),
        data: (mediaList) {
          final filteredList = mediaList
              .where(
                (audio) => favoriteIds.contains(audio.index),
              )
              .toList();
          if (filteredList.isEmpty) {
            return const Center(
              child: Text(
                '沒有收藏的音訊',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final audio = filteredList[index];
              return ListTile(
                leading: const Icon(
                  Icons.music_video_rounded,
                  color: Colors.blueAccent,
                ),
                title: Text(audio.name),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    ref
                        .read(favoriteAudioListNotifierProvider.notifier)
                        .toggleFavorite(audio.index);
                  },
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AudioPlayerScreen(
                        audioList: filteredList,
                        index: index,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
