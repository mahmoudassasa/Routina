import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';



  class BuildStateCard extends StatelessWidget {
    final String title;
    final String value;
    final IconData icon;
    final Color color;
  
    const BuildStateCard({
      super.key,
      required this.title,
      required this.value,
      required this.icon,
      required this.color,
    });
  
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.spacing3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: AppSizes.iconSize),
            const SizedBox(height: AppSizes.spacing1),
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
      );
    }
  }
  
