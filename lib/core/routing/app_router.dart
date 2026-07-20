import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/di/dependency_injection.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_cubit.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/billing_service/ui/widgets/paywall_screen.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/premium_analytics_screen.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/strategic_goals_screen.dart';
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
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: args['homeCubit'] as HomeCubit),
              BlocProvider.value(value: args['billingCubit'] as BillingCubit),
              BlocProvider.value(
                value: args['analyticsCubit'] as AnalyticsCubit,
              ),
            ],
            child: const AnalyzeScreen(),
          ),
        );
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

    case Routes.strategicGoalsScreen:
  final args = settings.arguments;
  final List<Map<String, dynamic>> habits;
  if (args is List<Map<String, dynamic>>) {
    habits = args;
  } else if (args is Map<String, dynamic> && args['habits'] != null) {
    habits = (args['habits'] as List).cast<Map<String, dynamic>>();
  } else {
    habits = [];
  }
  return MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => BillingCubit()..init(),
      child: StrategicGoalsScreen(habits: habits),
    ),
  );

case Routes.premiumAnalyticsScreen:
  final args = settings.arguments;
  final List<Map<String, dynamic>> habits;
  if (args is List<Map<String, dynamic>>) {
    habits = args;
  } else if (args is Map<String, dynamic> && args['habits'] != null) {
    habits = (args['habits'] as List).cast<Map<String, dynamic>>();
  } else {
    habits = [];
  }
  return MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => BillingCubit()..init(),
      child: PremiumAnalyticsScreen(habits: habits),
    ),
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
      case Routes.paywallScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => BillingCubit()..init(),
            child: const PaywallScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
