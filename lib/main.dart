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
  WidgetsFlutterBinding.ensureInitialized();
await notify.initNotifications();  
  await notify.requestNotificationPermissions();
  tz.initializeTimeZones();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  // To fix the issue of ScreenUtil texts begin hidden
  await ScreenUtil.ensureScreenSize();

  Supabase.initialize(
    url: 'https://gvqgliulacfmhscswyid.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd2cWdsaXVsYWNmbWhzY3N3eWlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUxMzIyMTgsImV4cCI6MjA4MDcwODIxOH0.f6Gx8x45nGzp_h0ZPKFO2LXKtfOSRy04d0Y9pP7mLOY',
  );
  // FirebaseAppCheck.instance.activate(
  //   providerAndroid: AndroidPlayIntegrityProvider(),
  // );

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
