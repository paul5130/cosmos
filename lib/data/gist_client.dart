import 'package:cosmos/utils/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gist_client.g.dart';

const _gistUrl =
    'https://gist.githubusercontent.com/paul5130/b774657abe879a95d6a1100b066696f0/raw/85a892f9b490e668799262ef07a4b0e71c86dbd8/video_list.json';

class GistClient {
  const GistClient({
    required this.dio,
  });
  final Dio dio;

  Future<String> fetchVideoListJson() async {
    final response = await dio.get(_gistUrl);
    return response.data;
  }
}

@Riverpod(keepAlive: true)
GistClient gistClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  return GistClient(dio: dio);
}
