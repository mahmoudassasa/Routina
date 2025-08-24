import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/helpers/app_constants.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'features/onboarding/ui/onboarding_screen.dart';

class Routina extends StatelessWidget {
final AppRouter appRouter;

  const Routina({super.key, required this.appRouter});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
            designSize: const Size(375, 812),

      child: MaterialApp(
        initialRoute: isLoggedInUser ? Routes.homeScreen : Routes.loginScreen,
        onGenerateRoute: appRouter.generateRoute,
        title: 'Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.blue500,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: AppColors.background,
          cardTheme: const CardThemeData(
            elevation: 2,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusLg)),
            ),
            color: AppColors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.gray800,
            elevation: 0,
            centerTitle: false,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: const TextStyle(
              color: AppColors.gray600,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: TextStyle(
              color: AppColors.gray600.withValues(alpha:0.7),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing4,
              vertical: AppSizes.spacing3,
              
            ),
          ),
        ),
        //TODO: Start with onboarding screen
        home: const OnboardingScreen(),
      ),
    );
  }
}

// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({super.key});

//   @override
//   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// }

// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const HabitTrackerScreen(),
//     const AnalyzeScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.blue500.withValues(alpha:0.1),
//               blurRadius: 10,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppSizes.spacing4,
//               vertical: AppSizes.spacing2,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildNavItem(0, Icons.home, 'Home'),
//                 _buildNavItem(1, Icons.track_changes, 'Habits'),
//                 _buildNavItem(2, Icons.analytics, 'Analyze'),
//                 _buildNavItem(3, Icons.person, 'Profile'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(int index, IconData icon, String label) {
//     final isSelected = _currentIndex == index;
    
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _currentIndex = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(
//           horizontal: isSelected ? AppSizes.spacing4 : AppSizes.spacing2,
//           vertical: AppSizes.spacing2,
//         ),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.blue500.withValues(alpha:0.1) : Colors.transparent,
//           borderRadius: BorderRadius.circular(AppSizes.radiusFull),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? AppColors.blue500 : AppColors.gray600,
//               size: AppSizes.iconSize,
//             ),
//             if (isSelected) ...[
//               const SizedBox(width: AppSizes.spacing1),
//               Text(
//                 label,
//                 style: AppTextStyles.bodySm.copyWith(
//                   color: AppColors.blue500,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }