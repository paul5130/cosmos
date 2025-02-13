import 'dart:convert';

import 'package:cosmos/data/gist_client.dart';
import 'package:cosmos/model/hehe_video.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_list_provider.g.dart';

@Riverpod(keepAlive: true)
class VideoListProvider extends _$VideoListProvider {
  @override
  List<HeHeVideo> build() {
    _fetchData();
    return [];
  }

  Future<void> _fetchData() async {
    final jsonString = await ref.watch(gistClientProvider).fetchVideoListJson();
    final List<dynamic> jsonData = jsonDecode(jsonString);
    state = jsonData.map((e) => HeHeVideo.fromJson(e)).toList();
  }
}
