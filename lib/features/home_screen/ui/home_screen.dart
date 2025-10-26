import 'package:flutter/material.dart';
import 'package:routina/core/helpers/constants.dart';

import 'package:routina/features/home_screen/ui/widgets/ai_analyze_button.dart';
import 'package:routina/features/home_screen/ui/widgets/habits_list.dart';
import 'package:routina/features/home_screen/ui/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        body: Column(
          children: [
            // Header
            HomeHeader(),
            // Habits List
            HabitsList(),
            // AI Analyze Button
            AiAnalyzeButton(),
          ],
        ),
        bottomNavigationBar: BottomBarNavigation(),
      ),
    );
  }
}
