import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';
import 'build_recommendation_item.dart';

class RecommendationsCard extends StatelessWidget {
  const RecommendationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendations',
              style: AppTextStyles.h3,
            ),
            SizedBox(height: AppSizes.spacing3),
            BuildRecommendationItem(
              icon: Icons.schedule,
              title: 'Schedule reading after dinner',
              description:
                  'Studies show reading before bed improves sleep quality',
            ),
            BuildRecommendationItem(
              icon: Icons.water_drop,
              title: 'Set water reminders',
              description:
                  'Increase your water intake by 20% for better hydration',
            ),
            BuildRecommendationItem(
              icon: Icons.fitness_center,
              title: 'Morning workouts',
              description:
                  'Try exercising in the morning for higher energy levels',
            ),
          ],
        ),
      ),
    );
  }
}
