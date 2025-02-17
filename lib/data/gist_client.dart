import 'package:cosmos/utils/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gist_client.g.dart';

const _gistUrl =
    'https://gist.githubusercontent.com/paul5130/8efa626c91c57309d5c915643dafba15/raw/media_list.json';

class GistClient {
  const GistClient({
    required this.dio,
  });
  final Dio dio;

  Future<String> fetchMediaListJson() async {
    final response = await dio.get(_gistUrl);
    return response.data;
  }
}

@Riverpod(keepAlive: true)
GistClient gistClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  return GistClient(dio: dio);
}
