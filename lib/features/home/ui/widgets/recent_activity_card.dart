import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';
import 'build_activity_item.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

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
              'Recent Activity',
              style: AppTextStyles.h3,
            ),
            SizedBox(height: AppSizes.spacing3),
            BuildActivityItem(
              icon: Icons.water_drop,
              title: 'Drink Water',
              subtitle: 'Completed 2 hours ago',
              color: AppColors.blue500,
            ),
            BuildActivityItem(
              icon: Icons.fitness_center,
              title: 'Workout',
              subtitle: 'Completed this morning',
              color: AppColors.green500,
            ),
            BuildActivityItem(
              icon: Icons.menu_book,
              title: 'Reading',
              subtitle: 'Completed yesterday',
              color: AppColors.indigo500,
            ),
          ],
        ),
      ),
    );
  }
}
