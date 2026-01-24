import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/widgets/main_navigation_bar.dart';
import 'package:routina/features/analyze_screen/ui/analyze_screen.dart';
import 'package:routina/features/email_confirmation_screen/logic/cubit/email_verification_cubit.dart';
import 'package:routina/features/email_confirmation_screen/ui/email_confirmation_screen.dart';
import 'package:routina/features/forgot_password/ui/forgot_password.dart';
import 'package:routina/features/habit_tracker_screen/ui/habit_tracker_screen.dart';
import 'package:routina/features/login_screen/logic/cubit/login_cubit.dart';
import 'package:routina/features/login_screen/ui/login_screen.dart';
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
      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => RegisterCubit(),
            child: const RegisterScreen(),
          ),
        );
      case Routes.forgetPasswordScreen:
        return MaterialPageRoute(builder: (__) => const ForgotPasswordScreen());
      case Routes.habitTrackerScreen:
        return MaterialPageRoute(builder: (__) => const HabitTrackerScreen());
      case Routes.analyzeScreen:
        return MaterialPageRoute(builder: (__) => const AnalyzeScreen());
    case Routes.mainNavigationBar:
  return MaterialPageRoute(
  
    builder: (_) => const MainNavigationBar(), 
  );


      case Routes.emailConfirmationScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => EmailVerificationCubit(),
            child: const EmailConfirmationScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
