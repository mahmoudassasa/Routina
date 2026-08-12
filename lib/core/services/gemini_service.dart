import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeminiAnalysisResponse {
  final String text;
  final bool isFromCache;

  const GeminiAnalysisResponse({required this.text, required this.isFromCache});
}

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }

    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      ],
    );
  }

  Future<String> _generateAnalysis({
    required String type,
    required List<Map<String, dynamic>> habits,
  }) async {
    const maxRetries = 2;
    const retryDelay = Duration(seconds: 2);

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final prompt = _buildPrompt(type: type, habits: habits);
        final content = [Content.text(prompt)];
        final response = await _model.generateContent(content);
        return response.text ?? 'Unable to generate analysis';
      } catch (e) {
        final isRetryable =
            e.toString().contains('503') ||
            e.toString().toLowerCase().contains('unavailable') ||
            e.toString().toLowerCase().contains('high demand');

        if (isRetryable && attempt < maxRetries) {
          await Future.delayed(retryDelay * (attempt + 1));
          continue;
        }
        throw _handleError(e);
      }
    }
    throw Exception('failed: max retries exceeded');
  }

  // Builds the prompt text per analysis type. This is the ONLY place
  // that varies between overall/smart/goal — everything else
  // (caching, retry, quota, error handling) is shared.
  String _buildPrompt({
    required String type,
    required List<Map<String, dynamic>> habits,
  }) {
    switch (type) {
      case 'smart':
        // Build detailed weekly pattern data
        final habitsDetail = habits
            .map((h) {
              final title = h['title'];
              final progress = ((h['progress'] ?? 0.0) * 100).toInt();
              final streak = h['streak'] ?? 0;
              final weekProgress = h['weekProgress'] as List?;
              final days = weekProgress != null
                  ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        .asMap()
                        .entries
                        .where((e) => weekProgress[e.key] == true)
                        .map((e) => e.value)
                        .join(', ')
                  : 'none';
              return '- $title: $progress% progress, $streak-day streak, active on $days.';
            })
            .join('\n');

        return '''
You are a habit improvement coach. Based on the weekly activity of these habits, provide **actionable smart suggestions** to boost consistency.

Habits data:
$habitsDetail

Your response must be structured as follows:
1. **Weekly Pattern Analysis**: Briefly analyze the current weekly activity (which days are strong/weak).
2. **Specific Suggestions**: For each habit, give 1–2 specific, realistic adjustments (e.g., "Run: try morning sessions instead of evening").
3. **One Keystone Habit**: Pick one habit that, if improved, would positively impact others. Explain why.
4. **Daily Scheduling Tip**: Suggest an optimal time window for the most difficult habit.

Keep the total response under 180 words, encouraging and practical.
Respond in the same language as the habit names.
''';

      case 'goal':
        // Build detailed progress and frequency data
        final habitsDetail = habits
            .map((h) {
              final title = h['title'];
              final progress = ((h['progress'] ?? 0.0) * 100).toInt();
              final streak = h['streak'] ?? 0;
              final frequency = h['frequency'] as List?;
              final activeDays = frequency != null
                  ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        .asMap()
                        .entries
                        .where((e) => frequency[e.key] == true)
                        .map((e) => e.value)
                        .join(', ')
                  : 'not set';
              return '- $title: $progress% complete, $streak-day streak, scheduled on $activeDays.';
            })
            .join('\n');

        return '''
You are a strategic planner. Based on the current progress and scheduled frequency of these habits, propose a **goal optimization plan**.

Habits data:
$habitsDetail

Your response must contain:
1. **Priority Ranking**: Rank the habits from highest to lowest priority (based on current progress and streak). Explain briefly.
2. **Frequency Adjustments**: Suggest increasing, decreasing, or keeping the frequency for each habit (e.g., "Read: increase from 3 to 5 days/week").
3. **Weekly Milestones**: Propose one realistic milestone for the top 2 priorities (e.g., "Complete 4 runs this week").
4. **Risk Warning**: Identify the habit most likely to drop off and suggest one preventive action.

Keep the response concise and actionable (max 180 words).
Respond in the same language as the habit names.
''';

      case 'overall':
      default:
        final habitsText = habits
            .map((habit) {
              final title = habit['title'];
              final progress = ((habit['progress'] ?? 0.0) * 100).toInt();
              final streak = habit['streak'] ?? 0;
              return '- $title: $progress% completion, $streak days streak';
            })
            .join('\n');
        return '''
Analyze these habits and provide:
1. Overall performance summary
2. Best performing habit
3. Habits that need improvement
4. Motivational tip
5. One actionable suggestion

Habits:
$habitsText

Keep response concise (max 150 words) and encouraging.
Respond in the same language as the habit names above.
''';
    }
  }

  // Single cached entry point used by AnalyticsCubit for ALL types.
  // The cache key includes `type`, so overall/smart/goal are cached
  // separately — but they all draw from the same daily quota pool
  // (that accounting lives in AnalyticsCubit, not here).
  Future<GeminiAnalysisResponse> fetchCachedAnalysis({
    required String userId,
    required String type,
    required List<Map<String, dynamic>> habits,
    required bool isPremium,
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'gemini_analysis_${userId}_$type';
    final cacheTimeKey = 'gemini_analysis_time_${userId}_$type';

    if (!forceRefresh) {
      final cached = prefs.getString(cacheKey);
      final cachedTime = prefs.getInt(cacheTimeKey);
      if (cached != null && cachedTime != null) {
        final age = DateTime.now().millisecondsSinceEpoch - cachedTime;
        if (age < 86400000) {
          return GeminiAnalysisResponse(text: cached, isFromCache: true);
        }
      }
    }

    final analysis = await _generateAnalysis(type: type, habits: habits);
    await prefs.setString(cacheKey, analysis);
    await prefs.setInt(cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
    return GeminiAnalysisResponse(text: analysis, isFromCache: false);
  }

  Exception _handleError(Object e) {
    final errorStr = e.toString().toLowerCase();
    if (errorStr.contains('429') ||
        errorStr.contains('quota') ||
        errorStr.contains('resource_exhausted') ||
        errorStr.contains('ratelimitexceeded')) {
      return Exception('quota_exceeded');
    }
    return Exception('failed: ${e.toString()}');
  }
}
