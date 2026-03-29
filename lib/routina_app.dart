import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:routina/core/routing/app_router.dart';
import 'package:routina/core/services/no_internet_screen.dart';
import 'package:routina/core/theaming/app_theme/app_theme.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/widgets/main_navigation_bar.dart';
import 'package:routina/features/onboarding_screen/ui/onboarding_screen.dart';

class RoutinaApp extends StatefulWidget {
  final AppRouter appRouter;

  const RoutinaApp({super.key, required this.appRouter});

  @override
  State<RoutinaApp> createState() => _RoutinaAppState();
}

class _RoutinaAppState extends State<RoutinaApp> {
  bool _hasInternet = true;
  bool _checkingInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternet();
    InternetConnection().onStatusChange.listen((status) {
      if (mounted) {
        setState(() {
          _hasInternet = status == InternetStatus.connected;
        });
      }
    });
  }

  Future<void> _checkInternet() async {
    final hasInternet = await InternetConnection().hasInternetAccess;
    if (mounted) {
      setState(() {
        _hasInternet = hasInternet;
        _checkingInternet = false;
      });
    }
  }

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
            home: _buildHome(),
            onGenerateRoute: widget.appRouter.generateRoute,
          );
        },
      ),
    );
  }

  Widget _buildHome() {
    if (_checkingInternet) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_hasInternet) {
      return NoInternetScreen(onRetry: _checkInternet);
    }
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const MainNavigationBar();
        }
        return const OnboardingScreen();
      },
    );
  }
}
