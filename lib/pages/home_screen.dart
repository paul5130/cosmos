import 'package:cosmos/pages/media_list/audio_list_screen.dart';
import 'package:cosmos/pages/media_list/video_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'media_list/providers/media_list_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaListAsync = ref.watch(fetchMediaListProvider);

    return Scaffold(
      body: mediaListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("讀取失敗: $error")),
        data: (mediaList) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: const Text('Cosmoser'),
              pinned: true,
              floating: false,
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.audiotrack_rounded), text: '音訊列表'),
                  Tab(icon: Icon(Icons.video_library_rounded), text: '影片列表'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              AudioListScreen(
                audioList: mediaList,
              ),
              VideoListScreen(
                videoList:
                    mediaList.where((media) => media.videoId != null).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
