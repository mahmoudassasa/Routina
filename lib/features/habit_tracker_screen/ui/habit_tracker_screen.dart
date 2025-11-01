import 'package:flutter/material.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/habit_tracker_screen_coming_soon_content.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/habit_tracker_screen_header.dart';

class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    return  Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC), // very light blue
              Color(0xFFE0E7FF), // light indigo
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              HabitTrackerScreenHeader(),
              // Coming Soon Content
              HabitTrackerScreenComingSoonContent(),
            ],
          ),
        ),
      );
  }
}
