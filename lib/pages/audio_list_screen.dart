import 'package:cosmos/pages/favorite_audio_list_screen.dart';
import 'package:cosmos/providers/audio_list/favorite_audio_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/audio_list/audio_list_provider.dart';
import 'audio_player/audio_player_screen.dart';

final searchProvider = StateProvider<String>((ref) => '');

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late TextEditingController searchController;
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(
      text: ref.read(
        searchProvider,
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioListAsync = ref.watch(
      fetchAudioListProvider,
    );
    final searchQuery = ref.watch(searchProvider);
    final favoriteIds = ref.watch(favoriteAudioListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('音訊列表'),
        actions: [
          IconButton(
              onPressed: () {
                final audioList = ref.read(fetchAudioListProvider).value ?? [];
                if (audioList.isNotEmpty) {
                  final shuffledList = List.of(audioList)..shuffle();

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
              icon: const Icon(Icons.shuffle)),
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.redAccent,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FavoriteAudioListScreen(),
              ));
            },
          ),
        ],
      ),
      body: audioListAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text("讀取失敗: $error"),
        ),
        data: (mediaList) {
          final filteredList = searchQuery.isEmpty
              ? mediaList
              : mediaList
                  .where(
                    (audio) => audio.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()),
                  )
                  .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: '搜尋',
                  ),
                  onChanged: (value) {
                    ref.read(searchProvider.notifier).state = value;
                  },
                  onTap: () {
                    searchController.selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: searchController.text.length,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final audio = filteredList[index];
                      final isFavorite = favoriteIds.contains(
                        audio.index,
                      );
                      return ListTile(
                        title: Row(
                          children: [
                            if (audio.index > 221)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                audio.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        leading: const Icon(
                          Icons.music_video_rounded,
                          color: Colors.blueAccent,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.redAccent : Colors.black,
                          ),
                          onPressed: () => ref
                              .read(
                                favoriteAudioListNotifierProvider.notifier,
                              )
                              .toggleFavorite(
                                audio.index,
                              ),
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
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
