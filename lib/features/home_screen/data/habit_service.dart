import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HabitService {
  HabitService()
      : _supabase = Supabase.instance.client,
        _firebaseAuth = FirebaseAuth.instance;

  final SupabaseClient _supabase;
  final FirebaseAuth _firebaseAuth;

  static const String _tableName = 'habits';

  Future<String> _currentUserId() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User is not logged in');
    return user.uid;
  }

  List<bool> _parseBoolList(dynamic value) {
    if (value is List) return value.map((e) => e == true).toList().cast<bool>();
    return List<bool>.filled(7, false);
  }

  List<bool> _normalizeBoolList(List<bool> list) {
    if (list.length == 7) return List<bool>.from(list);
    if (list.length > 7) return List<bool>.from(list.take(7));
    final result = List<bool>.from(list);
    while (result.length < 7) {
      result.add(false);
    }
    return result;
  }

  Map<String, dynamic> _mapRowToHabit(Map<String, dynamic> row) {
    final frequency = _normalizeBoolList(_parseBoolList(row['frequency']));
    final weekProgress =
        _normalizeBoolList(_parseBoolList(row['week_progress']));

    return {
      'id': row['id'],
      'title': row['title'] ?? '',
      'icon': row['icon'] ?? 'sport',
      'color': row['color'] ?? 0,
      'frequency': frequency,
      'weekProgress': weekProgress,
      'progress': (row['progress'] ?? 0).toDouble(),
      'streak': row['streak'] ?? 0,
      'lastSeenDate': row['last_seen_date'],
    };
  }

  Future<List<Map<String, dynamic>>> fetchHabitsForCurrentUser() async {
    final userId = await _currentUserId();
    final response = await _supabase
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .order('created_at');

    return (response as List)
        .map((item) => _mapRowToHabit(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> createHabitForCurrentUser({
    required String title,
    required String iconKey,
    required int colorValue,
    required List<bool> days,
  }) async {
    final userId = await _currentUserId();
    final frequency = _normalizeBoolList(days);
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final response = await _supabase
        .from(_tableName)
        .insert({
          'user_id': userId,
          'title': title,
          'icon': iconKey,
          'color': colorValue,
          'frequency': frequency,
          'week_progress': List<bool>.filled(7, false),
          'progress': 0.0,
          'streak': 0,
          'last_seen_date': todayStr,
        })
        .select()
        .single();

    return _mapRowToHabit(response);
  }

  Future<void> updateHabitProgress({
    required int habitId,
    required List<bool> frequency,
    required List<bool> weekProgress,
    required double progress,
    required int streak,
    DateTime? lastSeenDate,
  }) async {
    final payload = <String, dynamic>{
      'frequency': _normalizeBoolList(frequency),
      'week_progress': _normalizeBoolList(weekProgress),
      'progress': progress,
      'streak': streak,
    };

    if (lastSeenDate != null) {
      payload['last_seen_date'] =
          '${lastSeenDate.year}-${lastSeenDate.month.toString().padLeft(2, '0')}-${lastSeenDate.day.toString().padLeft(2, '0')}';
    }

    await _supabase.from(_tableName).update(payload).eq('id', habitId);
  }

  Future<void> updateHabit({
    required int habitId,
    required String title,
    required String iconKey,
    required int colorValue,
    required List<bool> days,
  }) async {
    await _supabase.from(_tableName).update({
      'title': title,
      'icon': iconKey,
      'color': colorValue,
      'frequency': _normalizeBoolList(days),
    }).eq('id', habitId);
  }

  Future<void> deleteHabit(int habitId) async {
    await _supabase.from(_tableName).delete().eq('id', habitId);
  }
}