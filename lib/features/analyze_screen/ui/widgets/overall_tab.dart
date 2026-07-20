import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_state.dart';

class OverallTab extends StatelessWidget {
  const OverallTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        if (state.status == AnalyticsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.totalHabits == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('📊', style: TextStyle(fontSize: 56.sp)),
                verticalSpace(16),
                Text(
                  context.l10n.noHabitsYet,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                verticalSpace(8),
                Text(
                  context.l10n.addHabitsFirst,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildMetricCard(
                    context,
                    isDark,
                    '${state.totalHabits}',
                    context.l10n.totalHabitsLabel,
                    Icons.list_alt,
                    Colors.blue,
                  ),
                  horizontalSpace(10),
                  _buildMetricCard(
                    context,
                    isDark,
                    '${(state.averageProgress * 100).toInt()}%',
                    context.l10n.avgCompletion,
                    Icons.trending_up,
                    Colors.green,
                  ),
                ],
              ),
              verticalSpace(10),
              Row(
                children: [
                  _buildMetricCard(
                    context,
                    isDark,
                    '${state.bestStreak}',
                    context.l10n.bestStreakLabel,
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                  horizontalSpace(10),
                  _buildMetricCard(
                    context,
                    isDark,
                    state.bestStreakHabitName.isNotEmpty
                        ? state.bestStreakHabitName
                        : '-',
                    context.l10n.bestPerforming,
                    Icons.star,
                    Colors.purple,
                    small: true,
                  ),
                ],
              ),
              verticalSpace(20),
              Text(
                context.l10n.weeklyActivity,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              verticalSpace(10),
              Container(
                height: 240.h,
                padding: EdgeInsets.fromLTRB(8.w, 16.h, 16.w, 12.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                  ),
                ),
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    minY: 0,
                    maxY: 120,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24.h,
                          getTitlesWidget: (value, meta) {
                            const days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < days.length) {
                              return Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: Text(
                                  days[value.toInt()],
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32.w,
                          interval: 20,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() > 100) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              '${value.toInt()}%',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: state.weeklyChartData,
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 3.w,
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 3.r,
                              color: AppColors.primary,
                              strokeWidth: 0,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpace(20),
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
                        state.averageProgress > 0.5
                            ? context.l10n.insightGreat
                            : context.l10n.insightKeepGoing,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? Colors.white : Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    bool isDark,
    String value,
    String label,
    IconData icon,
    Color color, {
    bool small = false,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16.sp),
            verticalSpace(6),
            Text(
              value,
              style: TextStyle(
                fontSize: small ? 12.sp : 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}