import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/services/gemini_service.dart';
import 'ai_analysis_state.dart';

class AiAnalysisCubit extends Cubit<AiAnalysisState> {
  AiAnalysisCubit({GeminiService? geminiService})
      : _geminiService = geminiService ?? GeminiService(),
        super(const AiAnalysisState());

  final GeminiService _geminiService;

  Future<void> analyzeHabits(List<Map<String, dynamic>> habits) async {
    emit(state.copyWith(status: AiAnalysisStatus.loading));
    
    try {
      final analysis = await _geminiService.analyzeHabits(habits: habits);
      emit(state.copyWith(
        status: AiAnalysisStatus.success,
        analysis: analysis,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AiAnalysisStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void reset() {
    emit(const AiAnalysisState());
  }
}