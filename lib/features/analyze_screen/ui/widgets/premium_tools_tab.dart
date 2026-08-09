import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_state.dart';
import 'quota_exceeded_card.dart';

class PremiumToolsTab extends StatelessWidget {
  const PremiumToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
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
              verticalSpace(20),
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

    if (state.remainingDailyRequests <= 0) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: QuotaExceededCard(isPremiumUser: state.isPremiumUser),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PremiumToolCard(
            icon: '💡',
            title: context.l10n.smartSuggestions,
            description: context.l10n.smartSuggestionsDesc,
            type: 'smart',
          ),
          verticalSpace(16),
          _PremiumToolCard(
            icon: '🎯',
            title: context.l10n.goalOptimization,
            description: context.l10n.goalOptimizationDesc,
            type: 'goal',
          ),
          verticalSpace(24),
        ],
      ),
    );
  }
}

class _PremiumToolCard extends StatefulWidget {
  final String icon;
  final String title;
  final String description;
  final String type;

  const _PremiumToolCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.type,
  });

  @override
  State<_PremiumToolCard> createState() => _PremiumToolCardState();
}

class _PremiumToolCardState extends State<_PremiumToolCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AnalyticsCubit>().state;
    final isThisTypeActive = _expanded;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              setState(() => _expanded = !_expanded);
              if (_expanded) {
                context.read<AnalyticsCubit>().fetchGeminiInsights(widget.type);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        widget.icon,
                        style: TextStyle(fontSize: 22.sp),
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        verticalSpace(2),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
          if (isThisTypeActive)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
              child: _buildExpandedContent(context, state, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    AnalyticsState state,
    bool isDark,
  ) {
    if (state.geminiStatus == GeminiStatus.loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.geminiStatus == GeminiStatus.error) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 16.sp),
            horizontalSpace(8),
            Expanded(
              child: Text(
                state.geminiError == 'quota_exceeded'
                    ? context.l10n.quotaExceeded
                    : context.l10n.somethingWentWrong,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.geminiStatus == GeminiStatus.loaded &&
        state.geminiAnalysis != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.grey[50],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          state.geminiAnalysis!,
          style: TextStyle(
            fontSize: 13.sp,
            height: 1.5.h,
            color: isDark ? Colors.grey[300] : Colors.grey[800],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}