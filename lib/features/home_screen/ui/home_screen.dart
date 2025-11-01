import 'package:flutter/material.dart';
import 'package:routina/features/home_screen/ui/widgets/ai_analyze_button.dart';
import 'package:routina/features/home_screen/ui/widgets/habits_list.dart';
import 'package:routina/features/home_screen/ui/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final  Color selectedItemColor = Color(0xFF3B82F6),
      unselectedItemColor = Colors.grey;@override
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
      child:  Column(
          children: [
            // Header
            HomeHeader(),
            // Habits List
            HabitsList(),
            // AI Analyze Button
            AiAnalyzeButton(),
          ],
        ),
      );
  }
}
