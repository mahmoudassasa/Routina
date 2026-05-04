import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/create_habit/ui/create_habit_bottom_sheet.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_cubit.dart';
import 'package:routina/features/analyze_screen/ui/widgets/quick_ai_analysis_sheet.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/billing_service/ui/widgets/paywall_screen.dart';
import 'package:routina/features/bottom_navigation_bar/ui/widgets/bottom_navigation_bar_widget.dart';
import 'package:routina/features/bottom_navigation_bar/ui/widgets/screen_selector.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int _currentIndex = 0;

  static const int _freeHabitsLimit = 5;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()..loadHabits()),
        BlocProvider(create: (_) => ProfileCubit()..loadUserData()),
        BlocProvider(create: (_) => LogoutCubit()),
        BlocProvider(create: (_) => AiAnalysisCubit()),
        BlocProvider(create: (_) => BillingCubit()..init()),
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
                final billingState = context.read<BillingCubit>().state;
                final habitsCount = homeCubit.state.habits.length;

                // Premium gate: free users limited to 3 habits
                if (!billingState.isPremium && habitsCount >= _freeHabitsLimit) {
                  _showPaywall(context);
                  return;
                }

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider.value(
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

void _showPaywall(BuildContext context) {
  context.push(
    BlocProvider.value(
      value: context.read<BillingCubit>(),
      child: const PaywallScreen(),
    ),
  );
}
}