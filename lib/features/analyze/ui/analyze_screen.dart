import 'package:flutter/material.dart';
import '../../../core/helpers/app_constants.dart';
import 'widgets/ai_insights_card.dart';
import 'widgets/build_metric_card.dart';
import 'widgets/recommendations_card.dart';
import 'widgets/weekly_progress_chart_card.dart';

class AnalyzeScreen extends StatelessWidget {
  const AnalyzeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blue25, AppColors.indigo25],
        ),
      ),
      child: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'AI Analysis',
                style: AppTextStyles.h1,
              ),
              SizedBox(height: AppSizes.spacing2),
              Text(
                'Insights and recommendations for your habits',
                style: AppTextStyles.bodySm,
              ),

              SizedBox(height: AppSizes.spacing6),

              // AI Insights Card
              AIinsightsCard(),

              SizedBox(height: AppSizes.spacing6),

              // Weekly Progress Chart
              WeeklyProgressChartCard(),
              SizedBox(height: AppSizes.spacing6),

              // Performance Metrics
              Text(
                'Performance Metrics',
                style: AppTextStyles.h3,
              ),
              SizedBox(height: AppSizes.spacing4),

              Row(
                children: [
                  Expanded(
                    child: BuildMetricCard(
                      title: 'Completion Rate',
                      value: '85%',
                      icon: Icons.check_circle,
                      color: AppColors.green500,
                      change: '+12%',
                      isPositive: true,
                    ),
                  ),
                  SizedBox(width: AppSizes.spacing3),
                  Expanded(
                    child: BuildMetricCard(
                      title: 'Streak Count',
                      value: '12 days',
                      icon: Icons.local_fire_department,
                      color: AppColors.blue500,
                      change: '+3 days',
                      isPositive: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSizes.spacing3),

              Row(
                children: [
                  Expanded(
                    child: BuildMetricCard(
                      title: 'Best Habit',
                      value: 'Reading',
                      icon: Icons.menu_book,
                      color: AppColors.indigo500,
                      change: '100%',
                      isPositive: true,
                    ),
                  ),
                  SizedBox(width: AppSizes.spacing3),
                  Expanded(
                    child: BuildMetricCard(
                      title: 'Needs Focus',
                      value: 'Sleep',
                      icon: Icons.bedtime,
                      color: AppColors.blue600,
                      change: '60%',
                      isPositive: false,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSizes.spacing6),

              // Recommendations
              RecommendationsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
