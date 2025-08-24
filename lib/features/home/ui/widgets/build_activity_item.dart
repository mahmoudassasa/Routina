

import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';

class BuildActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const BuildActivityItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.spacing2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: color, size: AppSizes.iconSize),
          ),
          const SizedBox(width: AppSizes.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBase),
                Text(subtitle, style: AppTextStyles.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}