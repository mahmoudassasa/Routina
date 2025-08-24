  import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';

class BuildRecommendationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const BuildRecommendationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.spacing2),
            decoration: BoxDecoration(
              color: AppColors.blue50,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child:
                Icon(icon, color: AppColors.blue500, size: AppSizes.iconSize),
          ),
          const SizedBox(width: AppSizes.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBase),
                const SizedBox(height: AppSizes.spacing1),
                Text(description, style: AppTextStyles.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}