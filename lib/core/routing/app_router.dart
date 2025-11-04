import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/widgets/bottom_navigation_bar_main_layout.dart';
import 'package:routina/features/analyze_screen/ui/analyze_screen.dart';
import 'package:routina/features/forgot_password/ui/forgot_password.dart';
import 'package:routina/features/habit_tracker_screen/ui/habit_tracker_screen.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/login_screen/logic/cubit/login_cubit.dart';
import 'package:routina/features/login_screen/ui/login_screen.dart';
import 'package:routina/features/profile_screen/ui/profile_screen.dart';
import 'package:routina/features/register_screen/logic/cubit/register_cubit.dart';
import 'package:routina/features/register_screen/ui/register_screen.dart';
import '../../features/onboarding_screen/ui/onboarding_screen.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(),
            child: const LoginScreen(),
          ),
        );
      // case Routes.homeScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (context) => HomeCubit()..loadHabits(),
      //       child: const HomeScreen(),
      //     ),
      //   );
      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => RegisterCubit(),
            child: const RegisterScreen(),
          ),
        );
      case Routes.forgetPasswordScreen:
        return MaterialPageRoute(builder: (__) => const ForgotPasswordScreen());
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (__) => const ProfileScreen());
      case Routes.habitTrackerScreen:
        return MaterialPageRoute(builder: (__) => const HabitTrackerScreen());
      case Routes.analyzeScreen:
        return MaterialPageRoute(builder: (__) => const AnalyzeScreen());
      case Routes.mainLayout:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit()..loadHabits(),
            child: const BottomNavigationBarMainLayout(),
          ),
        );

      default:
        return null;
    }
  }
}
