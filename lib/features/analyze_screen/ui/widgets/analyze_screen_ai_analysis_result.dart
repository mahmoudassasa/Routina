import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_state.dart';

class AnalyzeScreenAiAnalysisResult extends StatelessWidget {
  final AiAnalysisState state;

  const AnalyzeScreenAiAnalysisResult({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  static void showAnalysisSheet(BuildContext context, AiAnalysisState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: 0.8.sh),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          left: 24.w,
          right: 24.w,
          top: 16.h,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1C23) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 24.h),
            _buildHeader(isDark),
            SizedBox(height: 24.h),
            _buildContent(state, isDark),
          ],
        ),
      ),
    );
  }

  static Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(child: Text('✨', style: TextStyle(fontSize: 28.sp))),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Insights',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              'Powered by Gemini',
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildContent(AiAnalysisState state, bool isDark) {
    if (state.status == AiAnalysisStatus.loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: const CircularProgressIndicator(color: AppColors.primary),
      );
    }
    
    if (state.status == AiAnalysisStatus.error) {
       return Text(state.errorMessage ?? 'Error occurred');
    }

    return Flexible(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[50],
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            state.analysis ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.6,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }
}