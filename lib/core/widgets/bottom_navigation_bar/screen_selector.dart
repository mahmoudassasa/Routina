import 'package:flutter/material.dart';
import 'package:routina/features/analyze_screen/ui/analyze_screen.dart';
import 'package:routina/features/habit_tracker_screen/ui/habit_tracker_screen.dart';
import 'package:routina/features/home_screen/ui/home_screen.dart';
import 'package:routina/features/profile_screen/ui/profile_screen.dart';

class ScreenSelector extends StatelessWidget {
  final int currentIndex;

  const ScreenSelector({
    super.key,
    required this.currentIndex,
  });

  int _getScreenIndex(int navIndex) {
    if (navIndex < 2) return navIndex;
    if (navIndex > 2) return navIndex - 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    switch (_getScreenIndex(currentIndex)) {
      case 0:
        return const HomeScreen();
      case 1:
        return const HabitTrackerScreen();
      case 2:
        return const AnalyzeScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}