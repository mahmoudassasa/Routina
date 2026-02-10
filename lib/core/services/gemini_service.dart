import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  Future<String> analyzeHabits({
    required List<Map<String, dynamic>> habits,
  }) async {
    try {
      final habitsText = habits
          .map((habit) {
            final title = habit['title'];
            final progress = ((habit['progress'] ?? 0.0) * 100).toInt();
            final streak = habit['streak'] ?? 0;
            return '- $title: $progress% completion, $streak days streak';
          })
          .join('\n');

      final prompt =
          '''
      Analyze these habits and provide:
      1. Overall performance summary
      2. Best performing habit
      3. Habits that need improvement
      4. Motivational tip
      5. One actionable suggestion
      
      Habits:
      $habitsText
      
      Keep response concise (max 150 words) and encouraging.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Unable to generate analysis';
    } catch (e) {
      throw Exception('Failed to analyze habits: ${e.toString()}');
    }
  }

  Future<String> getProgressAnalysis({
    required List<Map<String, dynamic>> habits,
  }) async {
    try {
      final habitsText = habits
          .map((habit) {
            final title = habit['title'];
            final progress = ((habit['progress'] ?? 0.0) * 100).toInt();
            return '- $title: $progress%';
          })
          .join('\n');

      final prompt =
          '''
      Provide detailed progress analysis:
      $habitsText
      
      Include completion trends and consistency patterns. Max 150 words.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Unable to generate progress analysis';
    } catch (e) {
      throw Exception('Failed: ${e.toString()}');
    }
  }

  Future<String> getSmartSuggestions({
    required List<Map<String, dynamic>> habits,
  }) async {
    try {
      final habitsText = habits
          .map((habit) {
            return habit['title'];
          })
          .join(', ');

      final prompt =
          '''
      Based on these habits: $habitsText
      
      Give 5 practical tips to improve consistency. Keep it short and actionable.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Unable to generate suggestions';
    } catch (e) {
      throw Exception('Failed: ${e.toString()}');
    }
  }

  Future<String> getGoalOptimization({
    required List<Map<String, dynamic>> habits,
  }) async {
    try {
      final habitsText = habits
          .map((habit) {
            final title = habit['title'];
            final progress = ((habit['progress'] ?? 0.0) * 100).toInt();
            return '- $title: $progress%';
          })
          .join('\n');

      final prompt =
          '''
      Optimize goals for these habits:
      $habitsText
      
      Suggest which to prioritize and how to adjust frequency. Max 120 words.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Unable to generate optimization';
    } catch (e) {
      throw Exception('Failed: ${e.toString()}');
    }
  }

  Stream<String> streamAnalysis({
    required List<Map<String, dynamic>> habits,
  }) async* {
    try {
      final habitsText = habits
          .map((habit) {
            final title = habit['title'];
            final progress = ((habit['progress'] ?? 0.0) * 100).toInt();
            return '- $title: $progress%';
          })
          .join('\n');

      final prompt =
          '''
      Provide motivational analysis for these habits:
      $habitsText
      
      Be encouraging and specific. Max 100 words.
      ''';

      final content = [Content.text(prompt)];
      final stream = _model.generateContentStream(content);

      await for (final chunk in stream) {
        yield chunk.text ?? '';
      }
    } catch (e) {
      throw Exception('Stream failed: ${e.toString()}');
    }
  }
}
