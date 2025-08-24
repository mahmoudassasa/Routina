import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';

class WeeklyProgressChartCard extends StatelessWidget {
  const WeeklyProgressChartCard({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Progress',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: AppSizes.spacing4),

            // Mock chart visualization
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.blue50,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 64,
                      color: AppColors.blue500,
                    ),
                    SizedBox(height: AppSizes.spacing2),
                    Text(
                      'Weekly Progress Chart',
                      style: AppTextStyles.bodyBase,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
