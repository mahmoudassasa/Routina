import 'package:flutter/material.dart';

import '../../features/onboarding_screen/ui/onboarding_screen.dart';

import 'routes.dart';

// class AppRouter {
//   Route? generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case Routes.onBoardingScreen:
//         return MaterialPageRoute(builder: (_) => const OnboardingScreen());
//       case Routes.homeScreen:
//         return MaterialPageRoute(
//           builder: (__) => BlocProvider(
//             create: (context) => HomeCubit()..loadHabits(),
//             child: const HomeScreen(),
//           ),
//         );
//       case Routes.loginScreen:
//         return MaterialPageRoute(
//           builder: (__) => BlocProvider(
//             create: (context) => LoginCubit(),
//             child: const LoginScreen(),
//           ),
//         );
//       case Routes.analyzeScreen:
//         return MaterialPageRoute(builder: (__) => const AnalyzeScreen());
//       case Routes.habitTrackerScreen:
//         return MaterialPageRoute(builder: (__) => const HabitTrackerScreen());
//       case Routes.registerScreen:
//         return MaterialPageRoute(
//           builder: (__) => BlocProvider(
//             create: (context) => SignupCubit(),
//             child: const RegisterScreen(),
//           ),
//         );
//       case Routes.forgetPasswordScreen:
//         return MaterialPageRoute(builder: (__) => const ForgotPasswordScreen());
//       case Routes.profileScreen:
//         return MaterialPageRoute(builder: (__) => const ProfileScreen());

//       default:
//         return null;

//     }
//   }
// }

















class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      
      default:
        return null;


    }
  }
}