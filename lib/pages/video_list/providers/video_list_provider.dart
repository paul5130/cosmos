import 'dart:convert';

import 'package:cosmos/data/gist_client.dart';
import 'package:cosmos/model/hehe_video.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_list_provider.g.dart';

@riverpod
Future<List<HeHeVideo>> fetchVideoList(Ref ref) async {
  final jsonString = await ref.watch(gistClientProvider).fetchVideoListJson();
  final List<dynamic> jsonData = jsonDecode(jsonString);
  final List<HeHeVideo> videoList =
      jsonData.map((e) => HeHeVideo.fromJson(e)).toList();
  return videoList;
}
