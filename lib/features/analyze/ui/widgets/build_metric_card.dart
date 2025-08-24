  import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';

class BuildMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String change;
  final bool isPositive;

  const BuildMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing3),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: AppSizes.iconSize),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing1,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive ? AppColors.green500.withOpacity(0.1) : AppColors.blue300.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Text(
                    change,
                    style: AppTextStyles.bodySm.copyWith(
                      color: isPositive ? AppColors.green500 : AppColors.blue600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing2),
            Text(
              value,
              style: AppTextStyles.h3.copyWith(color: color),
            ),
            Text(
              title,
              style: AppTextStyles.bodySm,
            ),
          ],
        ),
      ),
    );
  }
}