import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HabitService {
  HabitService() : _firebaseAuth = FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  static const String _functionUrl =
      'https://gvqgliulacfmhscswyid.supabase.co/functions/v1/verified-habits';

  Future<String> _idToken() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User is not logged in');
    final token = await user.getIdToken();
    if (token == null) throw Exception('Failed to get Firebase ID token');
    return token;
  }

  Future<Map<String, dynamic>> _call(
    String action,
    Map<String, dynamic> payload,
  ) async {
    final token = await _idToken();

    final response = await http.post(
      Uri.parse(_functionUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'action': action, 'payload': payload}),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['error']?.toString() ?? 'Request failed (${response.statusCode})');
    }

    return body;
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
    final weekProgress = _normalizeBoolList(
      _parseBoolList(row['week_progress']),
    );

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
    final result = await _call('get_habits', {});
    if (result['data'] == null) return [];
    final data = result['data'] as List;
    return data
        .map((item) => _mapRowToHabit(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> createHabitForCurrentUser({
    required String title,
    required String iconKey,
    required int colorValue,
    required List<bool> days,
  }) async {
    final result = await _call('add_habit', {
      'title': title,
      'iconKey': iconKey,
      'colorValue': colorValue,
      'days': _normalizeBoolList(days),
    });
    return _mapRowToHabit(result['data'] as Map<String, dynamic>);
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
      'habitId': habitId,
      'frequency': _normalizeBoolList(frequency),
      'weekProgress': _normalizeBoolList(weekProgress),
      'progress': progress,
      'streak': streak,
    };

    if (lastSeenDate != null) {
      payload['lastSeenDate'] =
          '${lastSeenDate.year}-${lastSeenDate.month.toString().padLeft(2, '0')}-${lastSeenDate.day.toString().padLeft(2, '0')}';
    }

    await _call('update_progress', payload);
  }

  Future<void> updateHabit({
    required int habitId,
    required String title,
    required String iconKey,
    required int colorValue,
    required List<bool> days,
  }) async {
    await _call('update_habit', {
      'habitId': habitId,
      'title': title,
      'iconKey': iconKey,
      'colorValue': colorValue,
      'days': _normalizeBoolList(days),
    });
  }

  Future<void> deleteHabit(int habitId) async {
    await _call('delete_habit', {'habitId': habitId});
  }

  Future<void> deleteAllHabits() async {
    await _call('delete_all_habits', {});
  }
}