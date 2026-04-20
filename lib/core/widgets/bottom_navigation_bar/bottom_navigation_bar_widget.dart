import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/bottom_navigation_bar/nav_item_button.dart';
import 'package:routina/core/widgets/bottom_navigation_bar/center_action_button.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onCenterTap;
  final VoidCallback? onCenterLongPress;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.onCenterTap,
    this.onCenterLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final selectedColor = AppColors.primary;
    final unselectedColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: [
              NavItemButton(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                onTap: () => onIndexChanged(0),
              ),
              NavItemButton(
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.track_changes_outlined,
                activeIcon: Icons.track_changes_rounded,
                label: 'Habits',
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                onTap: () => onIndexChanged(1),
              ),
              CenterActionButton(
                onTap: onCenterTap,
                onLongPress: onCenterLongPress,
              ),
              NavItemButton(
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics_rounded,
                label: 'Analyze',
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                onTap: () => onIndexChanged(3),
              ),
              NavItemButton(
                index: 4,
                currentIndex: currentIndex,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                onTap: () => onIndexChanged(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}