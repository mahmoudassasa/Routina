import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
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
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );
 await FirebaseAppCheck.instance.activate(
  providerAndroid: kReleaseMode
      ? const AndroidPlayIntegrityProvider()
      : const AndroidDebugProvider(),
);
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
