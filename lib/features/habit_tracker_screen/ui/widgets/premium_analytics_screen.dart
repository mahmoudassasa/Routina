import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/billing_service/ui/widgets/premium_gate.dart';

class PremiumAnalyticsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> habits;

  const PremiumAnalyticsScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = context.watch<BillingCubit>().state.isPremium;

    final sortedByStreak = [...habits]
      ..sort((a, b) => (b['streak'] as int? ?? 0).compareTo(a['streak'] as int? ?? 0));
    final best = sortedByStreak.isNotEmpty ? sortedByStreak.first : null;

    final sortedByProgress = [...habits]
      ..sort((a, b) => (a['progress'] as double? ?? 0.0).compareTo(b['progress'] as double? ?? 0.0));
    final leastProgressHabit = sortedByProgress.isNotEmpty ? sortedByProgress.first : null;

    final avgCompletion = habits.isEmpty
        ? 0.0
        : habits.fold<double>(0, (sum, h) => sum + (h['progress'] as double? ?? 0.0)) / habits.length;

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
            context.l10n.eliteInsights,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: !isPremium
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: PremiumGate(
                    reason: context.l10n.upgradeToPremium,
                    child: const SizedBox.shrink(),
                  ),
                ),
              )
            : habits.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('📊', style: TextStyle(fontSize: 64.sp)),
                        verticalSpace(16),
                        Text(
                          context.l10n.noHabitsYet,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildBody(context, isDark, best, leastProgressHabit, avgCompletion),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    bool isDark,
    Map<String, dynamic>? best,
    Map<String, dynamic>? leastProgressHabit,
    double avgCompletion,
  ) {
    final needsAttention = habits.where((h) => (h['progress'] as double? ?? 0) < 0.5).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  isDark: isDark,
                  label: context.l10n.avgCompletion,
                  value: '${(avgCompletion * 100).toInt()}%',
                  icon: '📊',
                  color: AppColors.primary,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: _MetricCard(
                  isDark: isDark,
                  label: context.l10n.totalHabits,
                  value: '${habits.length}',
                  icon: '📋',
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  isDark: isDark,
                  label: context.l10n.bestStreak,
                  value: '${best?['streak'] ?? 0}d',
                  icon: '🔥',
                  color: Colors.orange,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: _MetricCard(
                  isDark: isDark,
                  label: context.l10n.needsFocus,
                  value: leastProgressHabit != null ? leastProgressHabit['title'] ?? '-' : '-',
                  icon: '⚡',
                  color: Colors.redAccent,
                  small: true,
                ),
              ),
            ],
          ),
          verticalSpace(24),
          // Rule-based tip instead of an AI-generated one — computed
          // locally from the same metrics shown above, no network call.
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.indigo.shade900, Colors.blueAccent.shade700]
                    : [Colors.blue.shade50, Colors.blue.shade100],
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 20.sp)),
                horizontalSpace(12),
                Expanded(
                  child: Text(
                    _buildLocalTip(context, avgCompletion, needsAttention.length),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.white : Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(24),
          Text(
            context.l10n.priorityFocus,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          verticalSpace(12),
          Container(
            width: double.infinity,
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
                if (needsAttention.isEmpty)
                  Center(
                    child: Text(
                      context.l10n.allHabitsOnTrack,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  ...needsAttention.map(
                    (h) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber,
                            size: 16.sp,
                          ),
                          horizontalSpace(8),
                          Expanded(
                            child: Text(
                              h['title'] as String,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            '${((h['progress'] as double? ?? 0) * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          verticalSpace(40),
        ],
      ),
    );
  }

  // Simple rule-based messaging replacing the old Gemini-generated tip.
  // No AI, no network — just thresholds on numbers already computed.
  String _buildLocalTip(BuildContext context, double avgCompletion, int strugglingCount) {
    if (avgCompletion >= 0.8) {
      return context.l10n.tipExcellent;
    } else if (strugglingCount > 0) {
      return context.l10n.tipFocusAreas(strugglingCount);
    } else if (avgCompletion >= 0.5) {
      return context.l10n.insightGreat;
    }
    return context.l10n.insightKeepGoing;
  }
}

class _MetricCard extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;
  final String icon;
  final Color color;
  final bool small;

  const _MetricCard({
    required this.isDark,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: TextStyle(fontSize: 20.sp)),
          verticalSpace(8),
          Text(
            value,
            style: TextStyle(
              fontSize: small ? 13.sp : 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpace(4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}