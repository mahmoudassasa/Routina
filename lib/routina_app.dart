import 'package:flutter/material.dart';
import 'package:routina/core/routing/app_router.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_theme.dart';



class RoutinaApp extends StatelessWidget {
  final AppRouter appRouter;

  const RoutinaApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routina',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.onBoardingScreen,
      onGenerateRoute: appRouter.generateRoute,
    
    );
  }
}