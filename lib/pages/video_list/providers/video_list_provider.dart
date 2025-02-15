import 'dart:convert';
import 'dart:io';

import 'package:cosmos/data/gist_client.dart';
import 'package:cosmos/model/hehe_video.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_list_provider.g.dart';

@riverpod
Future<List<HeHeVideo>> fetchVideoList(Ref ref) async {
  final file = await _getLocalFile();
  try {
    final jsonString = await ref.watch(gistClientProvider).fetchVideoListJson();
    final List<dynamic> jsonData = jsonDecode(jsonString);
    final List<HeHeVideo> videoList =
        jsonData.map((e) => HeHeVideo.fromJson(e)).toList();
    await file.writeAsString(jsonString);
    return videoList;
  } catch (remoteError) {
    debugPrint('Failed to fetch video list from remote: $remoteError');
    if (await file.exists()) {
      try {
        final localJsonString = await file.readAsString();
        final List<dynamic> localJsonData = jsonDecode(localJsonString);
        return localJsonData.map((e) => HeHeVideo.fromJson(e)).toList();
      } catch (localError) {
        debugPrint('Failed to load video list from local');
      }
    }
  }
  return [];
}

Future<File> _getLocalFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/video_list.json');
}
