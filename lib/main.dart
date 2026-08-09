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
  
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  
  await notify.initNotifications();
  await notify.requestNotificationPermissions();
  tz.initializeTimeZones();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp();

  // Crashlytics: only collect in release builds, so local debugging
  // never pollutes production crash data.
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kReleaseMode);

  // Catch all uncaught Flutter framework errors (widget build errors,
  // layout errors, etc.) and report them as fatal crashes.
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Catch all uncaught errors OUTSIDE the Flutter framework (async gaps,
  // platform channel errors, isolate errors) that would otherwise crash
  // silently or only show in the device log.
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey : dotenv.env['SUPABASE_KEY']!,
    accessToken: () async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final token = await currentUser.getIdToken(true); // Forces token refresh
        print("Supabase Access Token: $token");
        return token;
      }
      print("Supabase Access Token: No current user");
      return null;
    },
  );

  await FirebaseAppCheck.instance.activate(
    providerAndroid: kReleaseMode
        ? const AndroidPlayIntegrityProvider()
        : const AndroidDebugProvider(),
  );

  // Attach the signed-in user's UID to any crash report, so a crash can
  // be traced back to a specific user without exposing PII (Crashlytics
  // stores only the ID string, nothing else).
  FirebaseAuth.instance.authStateChanges().listen((user) {
    FirebaseCrashlytics.instance.setUserIdentifier(user?.uid ?? 'signed_out');
  });

  await MobileAds.instance.initialize();
  await setupGetIt();

  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocProvider(
        create: (context) => LocaleCubit()..loadSavedLocale(),
        child: RoutinaApp(appRouter: AppRouter(), isFirstTime: isFirstTime),
      ),
    ),
  );
}