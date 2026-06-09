import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_state.dart';
import 'package:shimmer/shimmer.dart';

void showQuickAiAnalysisSheet(BuildContext context) {
  final aiCubit = context.read<AiAnalysisCubit>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: aiCubit,
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
          verticalSpace(12),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          verticalSpace(20),

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
                horizontalSpace(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.quickAiAnalysis,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      context.l10n.poweredByGemini,
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

          verticalSpace(24),

          // Content
          Flexible(
            child: BlocBuilder<AiAnalysisCubit, AiAnalysisState>(
              builder: (context, state) {
                if (state.status == AiAnalysisStatus.loading) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 8.h,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                      highlightColor: isDark
                          ? Colors.grey[700]!
                          : Colors.grey[100]!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          20,
                          (i) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Container(
                              width: i % 2 == 0 ? double.infinity : 0.65.sw,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (state.status == AiAnalysisStatus.error) {
                  String errorMsg;
                  if (state.errorMessage == 'quota_exceeded') {
                    errorMsg = context.l10n.quotaExceeded;
                  } else if (state.errorMessage?.contains('503') == true ||
                      state.errorMessage?.contains('high demand') == true) {
                    errorMsg = context.l10n.aiBusy;
                  } else if (state.errorMessage?.contains('network') == true) {
                    errorMsg = context.l10n.networkError;
                  } else {
                    errorMsg = context.l10n.somethingWentWrong;
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
                        verticalSpace(12),
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
                        verticalSpace(16),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final aiCubit = context.read<AiAnalysisCubit>();
                              context.pop();
                              context.pushNamed(
                                Routes.aiAnalysisFullScreen,
                                arguments: aiCubit,
                              );
                            },
                            icon: Icon(Icons.analytics_outlined, size: 18.sp),
                            label: Text(context.l10n.viewFullAnalysis),
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
                        verticalSpace(24),
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
