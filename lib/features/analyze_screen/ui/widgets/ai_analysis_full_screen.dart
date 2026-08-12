import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_state.dart';

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
            context.l10n.aiAnalysis,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
            builder: (context, state) {
              final cubit = context.read<AnalyticsCubit>();
              final isThisTypeActive = state.geminiType == 'overall';
              final effectiveStatus =
                  isThisTypeActive ? state.geminiStatus : GeminiStatus.idle;
              final effectiveError = isThisTypeActive ? state.geminiError : null;
              final displayedAnalysis = isThisTypeActive
                  ? state.geminiAnalysis
                  : cubit.cachedResultFor('overall');

              // Loading state
              if (effectiveStatus == GeminiStatus.loading) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header shimmer
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                            highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
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
                                baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
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
                                baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
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
                        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            25,
                            (index) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Container(
                                width: index % 3 == 0 ? 0.6.sw : double.infinity,
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

              // Error state
              if (effectiveStatus == GeminiStatus.error) {
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
                          context.l10n.analysisFailed,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        verticalSpace(12),
                        Text(
                          effectiveError == 'rate_limited'
                              ? context.l10n.rateLimited
                              : effectiveError == 'quota_exceeded'
                              ? context.l10n.quotaExceeded
                              : effectiveError ?? context.l10n.somethingWentWrong,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        verticalSpace(16),
                        ElevatedButton(
                          onPressed: () {
                            cubit.fetchGeminiInsights('overall', forceRefresh: true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(context.l10n.tryAgain),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Success state with analysis
              if (displayedAnalysis != null) {
                return RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                  onRefresh: () async {
                    final habits = context.read<HomeCubit>().state.habits;
                    if (habits.isNotEmpty) {
                      cubit.fetchGeminiInsights('overall', forceRefresh: true);
                      await cubit.stream.firstWhere(
                        (s) => s.geminiType != 'overall' || s.geminiStatus != GeminiStatus.loading,
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
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
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
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Text('✨', style: TextStyle(fontSize: 24.sp)),
                                ),
                              ),
                              horizontalSpace(16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.l10n.aiInsights,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      context.l10n.poweredByGemini,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(24),
                          Text(
                            displayedAnalysis,
                            style: TextStyle(
                              fontSize: 15.sp,
                              height: 1.6.h,
                              color: isDark ? Colors.grey[300] : Colors.grey[800],
                            ),
                          ),
                          verticalSpace(16),
                          Text(
                            '${context.l10n.remainingRequests}: ${state.remainingDailyRequests}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark ? Colors.grey[500] : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Idle state (no analysis yet)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🔮', style: TextStyle(fontSize: 64.sp)),
                    verticalSpace(16),
                    Text(
                      context.l10n.analyzeScreenSubtitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpace(24),
                    ElevatedButton(
                      onPressed: () {
                        cubit.fetchGeminiInsights('overall');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(context.l10n.overallAnalysis),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}