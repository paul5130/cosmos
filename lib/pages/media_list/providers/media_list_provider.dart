import 'dart:convert';
import 'dart:io';

import 'package:cosmos/data/gist_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/hehe_media.dart';

part 'media_list_provider.g.dart';

@riverpod
Future<List<HeHeMedia>> fetchMediaList(Ref ref) async {
  final file = await _getLocalFile();
  try {
    final jsonString = await ref.watch(gistClientProvider).fetchMediaListJson();
    final List<dynamic> jsonData = jsonDecode(jsonString);
    final List<HeHeMedia> videoList = jsonData
        .map((e) => HeHeMedia.fromJson(e))
        .where((media) => media.videoId != null)
        .toList();
    debugPrint(jsonString);
    await file.writeAsString(jsonString);
    return videoList;
  } catch (remoteError) {
    debugPrint('Failed to fetch media list from remote: $remoteError');
    if (await file.exists()) {
      try {
        final localJsonString = await file.readAsString();
        final List<dynamic> localJsonData = jsonDecode(localJsonString);
        return localJsonData.map((e) => HeHeMedia.fromJson(e)).toList();
      } catch (localError) {
        debugPrint('Failed to load media list from local');
      }
    }
  }
  return [];
}

Future<File> _getLocalFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/media_list.json');
}
