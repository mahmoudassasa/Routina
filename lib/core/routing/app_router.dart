import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/di/dependency_injection.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_cubit.dart';
import 'package:routina/features/analyze_screen/ui/widgets/ai_analysis_full_screen.dart';
import 'package:routina/features/habit_tracker_screen/ui/premium_analytics_screen.dart';
import 'package:routina/features/habit_tracker_screen/ui/strategic_goals_screen.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/ui/widgets/about_screen.dart';
import 'package:routina/features/help_support/ui/help_support_screen.dart';
import 'package:routina/features/privacy_policy/ui/privacy_policy_screen.dart';
import 'package:routina/features/bottom_navigation_bar/ui/main_navigation_bar.dart';
import 'package:routina/core/widgets/notification_screen.dart';
import 'package:routina/features/analyze_screen/ui/analyze_screen.dart';
import 'package:routina/features/email_confirmation_screen/logic/cubit/email_verification_cubit.dart';
import 'package:routina/features/email_confirmation_screen/ui/email_confirmation_screen.dart';
import 'package:routina/features/forgot_password/ui/forgot_password.dart';
import 'package:routina/features/habit_tracker_screen/ui/habit_tracker_screen.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/habit_progress_charts_screen.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/login_screen/logic/cubit/login_cubit.dart';
import 'package:routina/features/login_screen/ui/login_screen.dart';
import 'package:routina/features/profile_screen/ui/widgets/account_information_screen.dart';
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
            create: (context) => getIt<LoginCubit>(),
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
        return MaterialPageRoute(builder: (_) => const MainNavigationBar());

      case Routes.emailConfirmationScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => EmailVerificationCubit(),
            child: const EmailConfirmationScreen(),
          ),
        );
      case Routes.habitProgressChartsScreen:
        final habits = settings.arguments as List<Map<String, dynamic>>;
        return MaterialPageRoute(
          builder: (_) => HabitProgressChartsScreen(habits: habits),
        );
      case Routes.notificationScreen:
        // 1. Get the cubit from arguments
        final homeCubit = settings.arguments as HomeCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: homeCubit, // 2. Provide the same instance to the new screen
            child: const NotificationScreen(),
          ),
        );

      case Routes.helpSupportScreen:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());

      case Routes.privacyPolicyScreen:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());

      case Routes.aiAnalysisFullScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final aiCubit = args['aiCubit'] as AiAnalysisCubit;
        final homeCubit = args['homeCubit'] as HomeCubit;

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: aiCubit),
              BlocProvider.value(value: homeCubit),
            ],
            child: const AiAnalysisFullScreen(),
          ),
        );
      case Routes.strategicGoalsScreen:
        final habits = settings.arguments as List<Map<String, dynamic>>;
        return MaterialPageRoute(
          builder: (_) => StrategicGoalsScreen(habits: habits),
        );

      case Routes.premiumAnalyticsScreen:
        final habits = settings.arguments as List<Map<String, dynamic>>;
        return MaterialPageRoute(
          builder: (_) => PremiumAnalyticsScreen(habits: habits),
        );
      case Routes.aboutScreen:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      case Routes.accountInformationScreen:
        final profileCubit = settings.arguments as ProfileCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: profileCubit,
            child: const AccountInformationScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
