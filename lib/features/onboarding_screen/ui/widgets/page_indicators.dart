import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';

class PageIndicators extends StatelessWidget {
  final int currentPage;
  final List<Map<String, String>> pages;

  const PageIndicators({
    super.key,
    required this.currentPage,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pages.length,
        (index) {
          final bool isActive = currentPage == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : (isDark ? Colors.white24 : AppColors.border),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
}