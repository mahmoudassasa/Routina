import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HabitsCacheService {
  static const String _cacheKey = 'cached_habits';
  static const String _cacheTimestampKey = 'cached_habits_timestamp';
  static const Duration cacheValidDuration = Duration(minutes: 10);

  final SharedPreferences _prefs;

  HabitsCacheService(this._prefs);

  Future<void> saveHabits(List<Map<String, dynamic>> habits) async {
    final encoded = jsonEncode(habits);
    await _prefs.setString(_cacheKey, encoded);
    await _prefs.setInt(
      _cacheTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  List<Map<String, dynamic>>? getCachedHabits() {
    final raw = _prefs.getString(_cacheKey);
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  bool isCacheStale() {
    final timestamp = _prefs.getInt(_cacheTimestampKey);
    if (timestamp == null) return true;

    final cachedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(cachedAt) > cacheValidDuration;
  }

  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
    await _prefs.remove(_cacheTimestampKey);
  }
}