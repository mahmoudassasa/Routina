import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PremiumService {
  static const String _functionUrl =
      'https://gvqgliulacfmhscswyid.supabase.co/functions/v1/verified-premium';

  Future<String> _idToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    final token = await user.getIdToken();
    if (token == null) throw Exception('Failed to get ID token');
    return token;
  }

  Future<Map<String, dynamic>> _call(String action, Map<String, dynamic> payload) async {
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
      throw Exception(body['error']?.toString() ?? 'Request failed');
    }
    return body;
  }

  Future<Map<String, dynamic>> fetchPremiumStatus() async {
    final result = await _call('get_status', {});
    return result['data'] as Map<String, dynamic>;
  }

  Future<void> updatePremiumStatus({required bool isPremium, DateTime? premiumUntil}) async {
    await _call('update_status', {
      'isPremium': isPremium,
      'premiumUntil': premiumUntil?.toIso8601String(),
    });
  }

  Future<void> ensurePremiumRecord() async {
    await _call('ensure_record', {});
  }

  Future<String?> getAnalysis({required String period}) async {
    try {
      final result = await _call('get_analysis', {'period': period});
      final data = result['data'] as Map<String, dynamic>?;
      if (data == null) return null;
      return data['analysis_text'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveAnalysis({required String analysisText, required String period}) async {
    try {
      await _call('save_analysis', {
        'analysisText': analysisText,
        'period': period,
      });
    } catch (e) {
      throw Exception('Failed to save analysis: $e');
    }
  }
  Future<int> getGeminiQuota() async {
  final result = await _call('get_gemini_quota', {});
  final data = result['data'] as Map<String, dynamic>;
  return data['remaining'] as int;
}

Future<int> incrementGeminiQuota() async {
  final result = await _call('increment_gemini_quota', {});
  final data = result['data'] as Map<String, dynamic>;
  return data['remaining'] as int;
}
}