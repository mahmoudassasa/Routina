import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_state.dart';

void showQuickAiAnalysisSheet(BuildContext context) {
  // احفظه قبل الـ showModalBottomSheet
  final aiCubit = context.read<AiAnalysisCubit>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: aiCubit, // ← استخدم النسخة المحفوظة
      child: const _QuickAiAnalysisSheet(),
    ),
  );
}

class _QuickAiAnalysisSheet extends StatelessWidget {
  const _QuickAiAnalysisSheet();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1C23) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 20.h),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Text('✨', style: TextStyle(fontSize: 24.sp)),
                  ),
                ),
                SizedBox(width: 14.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick AI Analysis',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      'Powered by Gemini',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Content
          Flexible(
            child: BlocBuilder<AiAnalysisCubit, AiAnalysisState>(
              builder: (context, state) {
                if (state.status == AiAnalysisStatus.loading) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Analyzing your habits...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.status == AiAnalysisStatus.error) {
                  String errorMsg = 'Something went wrong. Please try again.';
                  if (state.errorMessage?.contains('503') == true ||
                      state.errorMessage?.contains('high demand') == true) {
                    errorMsg =
                        'AI is busy right now. Please try again in a moment.';
                  } else if (state.errorMessage?.contains('network') == true) {
                    errorMsg = 'Check your internet connection and try again.';
                  }

                  return Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: AppColors.error,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          errorMsg,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (state.status == AiAnalysisStatus.success &&
                    state.analysis != null) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            state.analysis!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.6,
                              color: isDark
                                  ? Colors.grey[300]
                                  : Colors.grey[800],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                          
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.analytics_outlined, size: 18.sp),
                            label: const Text('View Full Analysis'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
