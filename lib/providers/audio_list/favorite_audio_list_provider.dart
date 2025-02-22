import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorite_audio_list_provider.g.dart';

@riverpod
class FavoriteAudioListNotifier extends _$FavoriteAudioListNotifier {
  @override
  Set<int> build() {
    _loadFavorites();
    return {};
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedFavorites =
        prefs.getStringList('favorite_audio_ids');

    if (savedFavorites != null) {
      state = savedFavorites.map(int.parse).toSet();
    }
  }

  Future<void> toggleFavorite(int id) async {
    final newFavorites = {...state}; // 複製當前狀態
    if (newFavorites.contains(id)) {
      newFavorites.remove(id);
    } else {
      newFavorites.add(id);
    }

    state = newFavorites;
    await _saveFavorites(); // 🔥 更新本機儲存
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'favorite_audio_ids', state.map((id) => id.toString()).toList());
  }
}
