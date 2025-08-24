import 'package:flutter/material.dart';

import '../../features/analyze/ui/analyze_screen.dart';
import '../../features/habitTracker/ui/habit_tracker_screen.dart';
import '../../features/home/ui/home_screen.dart';
import '../../features/login/ui/login_screen.dart';
import '../../features/onboarding/ui/onboarding_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/signup/ui/register_screen.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
case Routes.loginScreen:
  return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.signUpScreen:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case Routes.habitTrackerScreen:
        return MaterialPageRoute(builder: (_) => const HabitTrackerScreen());
      case Routes.analyzeScreen:
        return MaterialPageRoute(builder: (_) => const AnalyzeScreen());
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
    
        
        
    }
  }
}
