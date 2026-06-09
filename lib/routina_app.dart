import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:routina/core/di/dependency_injection.dart';
import 'package:routina/core/routing/app_router.dart';
import 'package:routina/features/app_update_service/logic/cubit/update_cubit.dart';
import 'package:routina/features/app_update_service/ui/app_update_service.dart';
import 'package:routina/features/app_update_service/ui/widgets/update_dialog.dart';
import 'package:routina/features/locale/logic/locale_cubit.dart';
import 'package:routina/features/no_internet/ui/no_internet_screen.dart';
import 'package:routina/core/theaming/app_theme/app_theme.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/features/bottom_navigation_bar/ui/main_navigation_bar.dart';
import 'package:routina/features/login_screen/logic/cubit/login_cubit.dart';
import 'package:routina/features/login_screen/ui/login_screen.dart';
import 'package:routina/features/onboarding_screen/ui/onboarding_screen.dart';
import 'package:routina/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class RoutinaApp extends StatefulWidget {
  final AppRouter appRouter;
  final bool isFirstTime; // Add this
  const RoutinaApp({
    super.key,
    required this.appRouter,
    required this.isFirstTime,
  });

  @override
  State<RoutinaApp> createState() => _RoutinaAppState();
}

class _RoutinaAppState extends State<RoutinaApp> {
  bool _hasInternet = true;
  bool _checkingInternet = true;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _checkInternet();
    _checkForUpdate();
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
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                navigatorKey: _navigatorKey,
                title: 'Routina',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('ar')],
                home: _buildHome(),
                onGenerateRoute: widget.appRouter.generateRoute,
              );
            },
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
          final user = snapshot.data!;
          final isGoogleUser = user.providerData.any(
            (p) => p.providerId == 'google.com',
          );

          if (user.emailVerified || isGoogleUser) {
            return const MainNavigationBar();
          } else {
            FirebaseAuth.instance.signOut();
            return BlocProvider(
              create: (context) => getIt<LoginCubit>(),
              child: const LoginScreen(),
            );
          }
        }

        if (widget.isFirstTime) {
          return const OnboardingScreen();
        } else {
          return BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          );
        }
      },
    );
  }

  Future<void> _checkForUpdate() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version;
      final cubit = UpdateCubit(AppUpdateService());
      await cubit.checkForUpdate(currentVersion);

      if (cubit.state is UpdateRequired) {
        final ctx = _navigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          showDialog(
            context: ctx,
            barrierDismissible: false,
            builder: (_) => const UpdateDialog(),
          );
        }
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
  }
}
