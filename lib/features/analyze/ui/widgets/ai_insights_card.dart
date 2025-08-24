

import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';

class AIinsightsCard extends StatelessWidget {
  const AIinsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius2xl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.blue400, AppColors.indigo500],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radius2xl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.white,
                  size: AppSizes.iconSizeLarge,
                ),
                const SizedBox(width: AppSizes.spacing3),
                Text(
                  'AI Insight',
                  style: AppTextStyles.h3
                      .copyWith(color: AppColors.white),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing4),
            Text(
              'You\'re doing great with your workout routine! Your consistency has improved by 40% this month. Try scheduling your reading habit right after dinner for better adherence.',
              style: AppTextStyles.bodyBase
                  .copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSizes.spacing4),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.blue500,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusFull),
                ),
              ),
              child: const Text('Get More Insights'),
            ),
          ],
        ),
      ),
    );
  }
}