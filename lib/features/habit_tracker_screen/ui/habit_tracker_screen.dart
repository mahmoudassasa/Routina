import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/ad_banner_widget.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/habit_tracker_screen_content.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/habit_tracker_screen_header.dart';

class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackgroundGradientStart,
                  AppColors.darkBackgroundGradientEnd,
                ]
              : [
                  AppColors.backgroundGradientStart,
                  AppColors.backgroundGradientEnd,
                ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const AdBannerWidget(),
        body: SafeArea(
          child: Column(
            children: [
              const HabitTrackerScreenHeader(),
              const Expanded(child: HabitTrackerScreenContent()),
            ],
          ),
        ),
      ),
    );
  }
}
