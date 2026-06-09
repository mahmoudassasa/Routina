enum AiAnalysisStatus { initial, loading, success, error }

class AiAnalysisState {
  final AiAnalysisStatus status;
  final String? analysis;
  final String? errorMessage;

  const AiAnalysisState({
    this.status = AiAnalysisStatus.initial,
    this.analysis,
    this.errorMessage,
  });

  AiAnalysisState copyWith({
    AiAnalysisStatus? status,
    String? analysis,
    String? errorMessage,
  }) {
    return AiAnalysisState(
      status: status ?? this.status,
      analysis: analysis ?? this.analysis,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}