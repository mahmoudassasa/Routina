import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';
import 'build_state_card.dart';

class StateOverview extends StatelessWidget {
  const StateOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius2xl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius2xl),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Overview',
              style: AppTextStyles.h3,
            ),
            SizedBox(height: AppSizes.spacing4),
            Row(
              children: [
                Expanded(
                  child: BuildStateCard(
                    title: 'Completed',
                    value: '4/6',
                    icon: Icons.check_circle,
                    color: AppColors.green500,
                  ),
                ),
                SizedBox(width: AppSizes.spacing3),
                Expanded(
                  child: BuildStateCard(
                    title: 'Streak',
                    value: '12 days',
                    icon: Icons.local_fire_department,
                    color: AppColors.blue500,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.spacing3),
            Row(
              children: [
                Expanded(
                  child: BuildStateCard(
                    title: 'Weekly',
                    value: '85%',
                    icon: Icons.trending_up,
                    color: AppColors.indigo500,
                  ),
                ),
                SizedBox(width: AppSizes.spacing3),
                Expanded(
                  child: BuildStateCard(
                    title: 'Goals',
                    value: '6 active',
                    icon: Icons.flag,
                    color: AppColors.blue600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
