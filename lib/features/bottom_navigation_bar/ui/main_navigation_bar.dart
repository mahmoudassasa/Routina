import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/create_habit/ui/create_habit_bottom_sheet.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_cubit.dart';
import 'package:routina/features/analyze_screen/ui/widgets/quick_ai_analysis_sheet.dart';
import 'package:routina/features/bottom_navigation_bar/ui/widgets/screen_selector.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/bottom_navigation_bar/bottom_navigation_bar_widget.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()..loadHabits()),
        BlocProvider(create: (_) => ProfileCubit()..loadUserData()),
        BlocProvider(create: (_) => LogoutCubit()),
        BlocProvider(create: (_) => AiAnalysisCubit()),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: ScreenSelector(currentIndex: _currentIndex),
            bottomNavigationBar: BottomNavigationBarWidget(
              currentIndex: _currentIndex,
              onIndexChanged: (index) => setState(() => _currentIndex = index),
              onCenterTap: () {
                final homeCubit = context.read<HomeCubit>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => BlocProvider.value(
                    value: homeCubit,
                    child: const CreateHabitBottomSheet(),
                  ),
                );
              },
              onCenterLongPress: () {
                final habits = context.read<HomeCubit>().state.habits;
                if (habits.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add some habits first!'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                final aiCubit = context.read<AiAnalysisCubit>();
                aiCubit.analyzeHabits(habits);
                showQuickAiAnalysisSheet(context);
              },
            ),
          );
        },
      ),
    );
  }
}
