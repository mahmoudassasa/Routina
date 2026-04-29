import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_state.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:shimmer/shimmer.dart';

class AiAnalysisFullScreen extends StatelessWidget {
  const AiAnalysisFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackgroundGradientStart,
                  AppColors.darkBackgroundGradientEnd,
                ]
              : [
                  AppColors.backgroundGradientStart,
                  AppColors.backgroundGradientEnd,
                ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          title: Text(
            'AI Analysis',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<AiAnalysisCubit, AiAnalysisState>(
            builder: (context, state) {
              if (state.status == AiAnalysisStatus.loading) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header shimmer
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: isDark
                                ? Colors.grey[800]!
                                : Colors.grey[300]!,
                            highlightColor: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[100]!,
                            child: Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                          horizontalSpace(16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: isDark
                                    ? Colors.grey[800]!
                                    : Colors.grey[300]!,
                                highlightColor: isDark
                                    ? Colors.grey[700]!
                                    : Colors.grey[100]!,
                                child: Container(
                                  width: 120.w,
                                  height: 18.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                              verticalSpace(8),
                              Shimmer.fromColors(
                                baseColor: isDark
                                    ? Colors.grey[800]!
                                    : Colors.grey[300]!,
                                highlightColor: isDark
                                    ? Colors.grey[700]!
                                    : Colors.grey[100]!,
                                child: Container(
                                  width: 80.w,
                                  height: 13.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      verticalSpace(24),
                      // Content shimmer lines
                      Shimmer.fromColors(
                        baseColor: isDark
                            ? Colors.grey[800]!
                            : Colors.grey[300]!,
                        highlightColor: isDark
                            ? Colors.grey[700]!
                            : Colors.grey[100]!,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            25,
                            (index) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Container(
                                width: index % 3 == 0
                                    ? 0.6.sw
                                    : double.infinity,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state.status == AiAnalysisStatus.error) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80.sp,
                          color: Colors.red,
                        ),
                        verticalSpace(24),
                        Text(
                          'Analysis Failed',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        verticalSpace(12),
                        Text(
                          state.errorMessage ?? 'Unknown error',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
            //Success state with analysis
              if (state.status == AiAnalysisStatus.success &&
                  state.analysis != null) {
                return RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: isDark
                      ? AppColors.darkSurface
                      : Colors.white,
                  onRefresh: () async {
                    final habits = context.read<HomeCubit>().state.habits;
                    if (habits.isNotEmpty) {
                      context.read<AiAnalysisCubit>().analyzeHabits(habits);
                      await context.read<AiAnalysisCubit>().stream.firstWhere(
                        (s) => s.status != AiAnalysisStatus.loading,
                      );
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(24.w),
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.2 : 0.05,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Text(
                                    '✨',
                                    style: TextStyle(fontSize: 24.sp),
                                  ),
                                ),
                              ),
                              horizontalSpace(16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AI Insights',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Powered by Gemini',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(24),
                          Text(
                            state.analysis!,
                            style: TextStyle(
                              fontSize: 15.sp,
                              height: 1.6,
                              color: isDark
                                  ? Colors.grey[300]
                                  : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
