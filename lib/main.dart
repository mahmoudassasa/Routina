import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'routina_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RoutinaApp(appRouter: AppRouter()));
}
