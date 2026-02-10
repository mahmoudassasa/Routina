class AnalysisResponse {
  final String summary;
  final String bestHabit;
  final String improvementAreas;
  final String motivationalTip;
  final String suggestion;

  AnalysisResponse({
    required this.summary,
    required this.bestHabit,
    required this.improvementAreas,
    required this.motivationalTip,
    required this.suggestion,
  });

  factory AnalysisResponse.fromText(String text) {
    return AnalysisResponse(
      summary: _extractSection(text, 'summary') ?? text,
      bestHabit: _extractSection(text, 'best') ?? '',
      improvementAreas: _extractSection(text, 'improvement') ?? '',
      motivationalTip: _extractSection(text, 'tip') ?? '',
      suggestion: _extractSection(text, 'suggestion') ?? '',
    );
  }

  static String? _extractSection(String text, String keyword) {
    final lines = text.split('\n');
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].toLowerCase().contains(keyword)) {
        return lines.skip(i).take(2).join(' ').trim();
      }
    }
    return null;
  }
}