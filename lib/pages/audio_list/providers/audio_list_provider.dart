import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/hehe_audio.dart';

part 'audio_list_provider.g.dart';

@riverpod
Future<List<HeHeAudio>> fetchAudioList(Ref ref) async {
  try {
    final jsonString =
        await rootBundle.loadString('assets/audio/audio_list.json');

    final List<dynamic> jsonData = jsonDecode(jsonString);
    debugPrint('jsonData: $jsonData');
    final List<HeHeAudio> audioList =
        jsonData.map((e) => HeHeAudio.fromJson(e)).toList();
    audioList.sort((a, b) => a.index.compareTo(b.index));
    return audioList;
  } catch (error) {
    debugPrint('❌ Failed to load media list from assets: $error');
  }
  return [];
}
