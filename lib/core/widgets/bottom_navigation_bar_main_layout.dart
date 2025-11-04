import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/ui/home_screen.dart';
import 'package:routina/features/habit_tracker_screen/ui/habit_tracker_screen.dart';
import 'package:routina/features/analyze_screen/ui/analyze_screen.dart';
import 'package:routina/features/profile_screen/ui/profile_screen.dart';

class BottomNavigationBarMainLayout extends StatefulWidget {
  const BottomNavigationBarMainLayout({super.key});

  @override
  State<BottomNavigationBarMainLayout> createState() => _BottomNavigationBarMainLayoutState();
}

class _BottomNavigationBarMainLayoutState extends State<BottomNavigationBarMainLayout> {
  int _currentIndex = 0;

  final screens = [
    BlocProvider(
      create: (_) => HomeCubit()..loadHabits(),
      child: const HomeScreen(),
    ),
    const HabitTrackerScreen(),
    const AnalyzeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),

        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: Colors.grey,

        // نفس الحجم للأيقونات علشان مفيش تكبير
        selectedIconTheme: IconThemeData(size: 24.r),
        unselectedIconTheme: IconThemeData(size: 24.r),

        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,

        showSelectedLabels: true,
        showUnselectedLabels: true,

        elevation: 8,
        backgroundColor: Colors.white,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24.r),
            activeIcon: Icon(Icons.home_outlined, size: 24.r),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_outlined, size: 24.r),
            activeIcon: Icon(Icons.track_changes_outlined, size: 24.r),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined, size: 24.r),
            activeIcon: Icon(Icons.analytics_outlined, size: 24.r),
            label: 'Analyze',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24.r),
            activeIcon: Icon(Icons.person_outline, size: 24.r),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
