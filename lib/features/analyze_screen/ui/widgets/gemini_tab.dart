import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_state.dart';
import 'quota_exceeded_card.dart';

class GeminiTab extends StatelessWidget {
  const GeminiTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<AnalyticsCubit>();
    final state = cubit.state;

    final isThisTypeActive = state.geminiType == 'overall';
    final effectiveStatus =
        isThisTypeActive ? state.geminiStatus : GeminiStatus.idle;
    final effectiveError = isThisTypeActive ? state.geminiError : null;
    final displayedAnalysis = isThisTypeActive
        ? state.geminiAnalysis
        : cubit.cachedResultFor('overall');

    if (state.remainingDailyRequests <= 0 &&
        effectiveStatus != GeminiStatus.loaded) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: QuotaExceededCard(isPremiumUser: state.isPremiumUser),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      onRefresh: () async {
        cubit.fetchGeminiInsights('overall', forceRefresh: true);
        await cubit.stream.firstWhere(
          (s) => s.geminiType != 'overall' || s.geminiStatus != GeminiStatus.loading,
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  context.l10n.aiInsights,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                if (effectiveStatus != GeminiStatus.loading)
                  IconButton(
                    onPressed: state.remainingDailyRequests <= 0
                        ? null
                        : () => cubit.fetchGeminiInsights(
                            'overall',
                            forceRefresh: true,
                          ),
                    icon: Icon(
                      Icons.refresh,
                      color: state.remainingDailyRequests <= 0
                          ? (isDark ? Colors.grey[700] : Colors.grey[400])
                          : AppColors.primary,
                      size: 18.sp,
                    ),
                  ),
              ],
            ),
            verticalSpace(12),
            if (effectiveStatus == GeminiStatus.loading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: const Center(child: CircularProgressIndicator()),
              ),
            if (effectiveStatus == GeminiStatus.error) ...[
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 18.sp),
                    horizontalSpace(10),
                    Expanded(
                      child: Text(
                        effectiveError == 'rate_limited'
                            ? context.l10n.rateLimited
                            : effectiveError == 'quota_exceeded'
                            ? context.l10n.quotaExceeded
                            : context.l10n.somethingWentWrong,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      cubit.fetchGeminiInsights('overall', forceRefresh: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(context.l10n.tryAgain),
                ),
              ),
            ],
            if (displayedAnalysis != null)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text('✨', style: TextStyle(fontSize: 16.sp)),
                          ),
                        ),
                        horizontalSpace(10),
                        Text(
                          context.l10n.aiInsights,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(14),
                    Text(
                      displayedAnalysis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.5.h,
                        color: isDark ? Colors.grey[300] : Colors.grey[800],
                      ),
                    ),
                    verticalSpace(14),
                    Text(
                      '${context.l10n.remainingRequests}: ${state.remainingDailyRequests}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.grey[500] : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            if (effectiveStatus == GeminiStatus.idle && displayedAnalysis == null)
              Center(
                child: Column(
                  children: [
                    Text('🔮', style: TextStyle(fontSize: 48.sp)),
                    verticalSpace(16),
                    Text(
                      context.l10n.analyzeScreenSubtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpace(24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => cubit.fetchGeminiInsights('overall'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(context.l10n.generateInsights),
                      ),
                    ),
                  ],
                ),
              ),
            verticalSpace(24),
          ],
        ),
      ),
    );
  }
}