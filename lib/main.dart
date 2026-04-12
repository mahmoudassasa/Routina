import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/services/notification_service.dart' as notify;
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'core/routing/app_router.dart';
import 'routina_app.dart';

void main() async {
 // 1. dotenv أولاً
  await dotenv.load(fileName: ".env");

  // 2. باقي الـ initializations
  await notify.initNotifications();
  await notify.requestNotificationPermissions();
  tz.initializeTimeZones();
  await ScreenUtil.ensureScreenSize();

  await Firebase.initializeApp();

  // 3. Supabase بعد ما dotenv اتحمل
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  await FirebaseAppCheck.instance.activate(
    providerAndroid: const AndroidDebugProvider(),
  );
  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(),
      child: RoutinaApp(appRouter: AppRouter()),
    ),
  );
}
