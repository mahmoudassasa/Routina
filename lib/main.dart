import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';
import 'routina_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    providerAndroid: AndroidPlayIntegrityProvider(),
  );
  // setUpGetIt();
  // To fix the issue of ScreenUtil texts begin hidden
  await ScreenUtil.ensureScreenSize();
  runApp(RoutinaApp(appRouter: AppRouter()));
}


