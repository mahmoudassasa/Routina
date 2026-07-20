import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_state.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/feature_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

void showQuickAiAnalysisSheet(BuildContext context) {
  final homeCubit = context.read<HomeCubit>();
  final billingCubit = context.read<BillingCubit>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (context) => AnalyticsCubit(
        homeCubit: homeCubit,
        billingCubit: billingCubit,
      )..fetchGeminiInsights('overall'),
      child: _QuickAiAnalysisSheet(
        homeCubit: homeCubit,
        billingCubit: billingCubit,
      ),
    ),
  );
}

class _QuickAiAnalysisSheet extends StatelessWidget {
  final HomeCubit homeCubit;
  final BillingCubit billingCubit;

  const _QuickAiAnalysisSheet({
    required this.homeCubit,
    required this.billingCubit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analyticsState = context.watch<AnalyticsCubit>().state;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1C23) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                    Text(
                      '${context.l10n.remainingRequests}: ${analyticsState.remainingDailyRequests}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.grey[500] : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(24),
          Flexible(
            child: _buildContent(context, analyticsState, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AnalyticsState state, bool isDark) {
    if (state.geminiStatus == GeminiStatus.loading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
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

    if (state.geminiStatus == GeminiStatus.error) {
      String errorMsg;
      String actionLabel = '';
      VoidCallback? action;

      if (state.geminiError == 'rate_limited') {
        errorMsg = context.l10n.rateLimited;
        actionLabel = context.l10n.tryAgainLater;
      } else if (state.geminiError == 'quota_exceeded') {
        errorMsg = context.l10n.quotaExceeded;
        actionLabel = context.l10n.upgradeToPremium;
        action = () {
          context.pop();
          showPremiumFeatureBottomSheet(
            context: context,
            icon: '✨',
            title: context.l10n.unlockMoreAnalysis,
            description: context.l10n.unlockMoreAnalysisDesc,
            features: [
              context.l10n.daily30Requests,
              context.l10n.advancedInsights,
              context.l10n.prioritySupport,
            ],
          );
        };
      } else if (state.geminiError == 'premium_required') {
        errorMsg = context.l10n.upgradeToPremium;
        actionLabel = context.l10n.upgradeToPremium;
        action = () {
          context.pop();
        };
      } else {
        errorMsg = context.l10n.somethingWentWrong;
        actionLabel = context.l10n.tryAgain;
        action = () {
          context.read<AnalyticsCubit>().fetchGeminiInsights('overall', forceRefresh: true);
        };
      }

      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            verticalSpace(12),
            Text(
              errorMsg,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel.isNotEmpty) ...[
              verticalSpace(16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: action,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(actionLabel),
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (state.geminiStatus == GeminiStatus.loaded && state.geminiAnalysis != null) {
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
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Text(
                state.geminiAnalysis!,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.6.h,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
            ),
            verticalSpace(16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  final analyticsCubit = context.read<AnalyticsCubit>();
                  context.pop();
                  context.pushNamed(
                    Routes.analyzeScreen,
                    arguments: {
                      'homeCubit': homeCubit,
                      'billingCubit': billingCubit,
                      'analyticsCubit': analyticsCubit,
                    },
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
  }
}