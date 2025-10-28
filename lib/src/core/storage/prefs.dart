import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized.');
});

final prefsRepositoryProvider = Provider<PrefsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrefsRepository(prefs);
});

class PrefsRepository {
  PrefsRepository(this._prefs);

  final SharedPreferences _prefs;

  int getCount(String key) => _prefs.getInt(key) ?? 0;

  Future<void> setCount(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<void> setCounts(Map<String, int> values) async {
    for (final entry in values.entries) {
      await _prefs.setInt(entry.key, entry.value);
    }
  }

  Future<void> clearCounts(Iterable<String> keys) async {
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
