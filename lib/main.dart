import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:routina/core/di/dependency_injection.dart';
import 'package:routina/core/services/notification_service.dart' as notify;
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/features/locale/logic/locale_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'core/routing/app_router.dart';
import 'routina_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  late final SharedPreferences prefs;
  bool isFirstTime = true;

  try {
    await Future.wait([
      SharedPreferences.getInstance().then((p) {
        prefs = p;
        isFirstTime = prefs.getBool('isFirstTime') ?? true;
      }),
      Firebase.initializeApp(),
      ScreenUtil.ensureScreenSize(),
    ]).timeout(const Duration(seconds: 4));
  } catch (e) {
    debugPrint('Core initialization error or timeout: $e');
  }

  tz.initializeTimeZones();

  FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kReleaseMode);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  try {
    await Future.wait([
      Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        publishableKey: dotenv.env['SUPABASE_KEY']!,
        accessToken: () async {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            return await currentUser.getIdToken(true);
          }
          return null;
        },
      ),
      FirebaseAppCheck.instance.activate(
        providerAndroid: kReleaseMode
            ? const AndroidPlayIntegrityProvider()
            : const AndroidDebugProvider(),
      ),
      MobileAds.instance.initialize(),
      notify.initNotifications(),
      setupGetIt(),
    ]).timeout(const Duration(seconds: 4));
  } catch (e) {
    debugPrint('Secondary services initialization error or timeout: $e');
  }

  FirebaseAuth.instance.authStateChanges().listen((user) {
    FirebaseCrashlytics.instance.setUserIdentifier(user?.uid ?? 'signed_out');
  });

  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocProvider(
        create: (context) => LocaleCubit()..loadSavedLocale(),
        child: RoutinaApp(appRouter: AppRouter(), isFirstTime: isFirstTime),
      ),
    ),
  );

  notify.requestNotificationPermissions();
}