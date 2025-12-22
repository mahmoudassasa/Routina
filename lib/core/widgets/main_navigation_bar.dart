import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/ui/home_screen.dart';
import 'package:routina/features/habit_tracker_screen/ui/habit_tracker_screen.dart';
import 'package:routina/features/analyze_screen/ui/analyze_screen.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/ui/profile_screen.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 1. تغليف الـ Scaffold بالـ Providers يضمن وجودهم قبل بناء أي شاشة
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()..loadHabits()),
        BlocProvider(create: (_) => ProfileCubit()..loadUserData()),
        BlocProvider(create: (_) => LogoutCubit()),
      ],
      child: Scaffold(
        // 2. استخدام IndexedStack للحفاظ على حالة الشاشات
        body: IndexedStack(
          index: _currentIndex,
          children: const [
             HomeScreen(),
             HabitTrackerScreen(),
             AnalyzeScreen(),
             ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          
          // التنسيقات
          selectedItemColor: const Color(0xFF3B82F6),
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(size: 24.r),
          unselectedIconTheme: IconThemeData(size: 24.r),
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 8,
          backgroundColor: Colors.white,
          
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_outlined),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              label: 'Analyze',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}