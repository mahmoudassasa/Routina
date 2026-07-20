import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_state.dart';
import 'package:routina/features/analyze_screen/ui/widgets/quota_exceeded_card.dart';

class GoalOptimizationTab extends StatefulWidget {
  const GoalOptimizationTab({super.key});

  @override
  State<GoalOptimizationTab> createState() => _GoalOptimizationTabState();
}

class _GoalOptimizationTabState extends State<GoalOptimizationTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<AnalyticsCubit>();
      final state = cubit.state;
      if (state.isPremiumUser &&
          (state.geminiStatus == GeminiStatus.idle ||
              state.geminiType != 'goal')) {
        cubit.fetchGeminiInsights('goal');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AnalyticsCubit>().state;

    if (!state.isPremiumUser) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.workspace_premium,
                size: 56.sp,
                color: AppColors.primary,
              ),
              verticalSpace(16),
              Text(
                context.l10n.upgradeToPremium,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpace(8),
              Text(
                context.l10n.goalOptimizationPremiumDesc,
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
                  onPressed: () => context.pushNamed(Routes.paywallScreen),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(context.l10n.upgradeToPremium),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.remainingDailyRequests <= 0 &&
        state.geminiStatus != GeminiStatus.loaded) {
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
        final cubit = context.read<AnalyticsCubit>();
        cubit.fetchGeminiInsights('goal', forceRefresh: true);
        await cubit.stream.firstWhere(
          (s) => s.geminiStatus != GeminiStatus.loading,
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
                  '🎯 ${context.l10n.goalOptimization}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                if (state.geminiStatus != GeminiStatus.loading)
                  IconButton(
                    onPressed: state.remainingDailyRequests <= 0
                        ? null
                        : () {
                            context
                                .read<AnalyticsCubit>()
                                .fetchGeminiInsights('goal', forceRefresh: true);
                          },
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
            if (state.geminiStatus == GeminiStatus.loading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: const Center(child: CircularProgressIndicator()),
              ),
            if (state.geminiStatus == GeminiStatus.error) ...[
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
                        state.geminiError == 'rate_limited'
                            ? context.l10n.rateLimited
                            : state.geminiError == 'quota_exceeded'
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
                  onPressed: () {
                    context
                        .read<AnalyticsCubit>()
                        .fetchGeminiInsights('goal', forceRefresh: true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(context.l10n.tryAgain),
                ),
              ),
            ],
            if (state.geminiStatus == GeminiStatus.loaded &&
                state.geminiAnalysis != null)
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
                            child: Text('🎯', style: TextStyle(fontSize: 16.sp)),
                          ),
                        ),
                        horizontalSpace(10),
                        Text(
                          context.l10n.goalOptimization,
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
                      state.geminiAnalysis!,
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
            verticalSpace(24),
          ],
        ),
      ),
    );
  }
}