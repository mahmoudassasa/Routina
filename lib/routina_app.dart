import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/routing/app_router.dart';
import 'package:routina/core/theaming/app_theme/app_theme.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/widgets/main_navigation_bar.dart';
import 'package:routina/features/onboarding_screen/ui/onboarding_screen.dart';

class RoutinaApp extends StatelessWidget {
  final AppRouter appRouter;

  const RoutinaApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Routina',
            debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.themeMode,    
            
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // ⏳ Loading (usually appears for half a second)
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 👤 If there is a user ⇒, log in immediately
                if (snapshot.hasData) {
                  return const MainNavigationBar();
                }

                // ➕ If there is no user ⇒ go to onboarding
                return const OnboardingScreen();
              },
            ),
            onGenerateRoute: appRouter.generateRoute,
          );
        },
      ),
    );
  }
}
