import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/services/ad_banner_widget.dart';
import 'package:routina/core/services/ad_interstitial_service.dart';
import 'package:routina/features/home_screen/ui/widgets/habits_list.dart';
import 'package:routina/features/home_screen/ui/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AdInterstitialService _interstitialService = AdInterstitialService();

  @override
  void initState() {
    super.initState();
    _interstitialService.load();
    _interstitialService.handleAppOpenCount(context);
  }

  @override
  void dispose() {
    _interstitialService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackgroundGradientStart,
                  AppColors.darkBackgroundGradientEnd,
                ]
              : [
                  AppColors.backgroundGradientStart,
                  AppColors.backgroundGradientEnd,
                ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const AdBannerWidget(),
        body: SafeArea(
          child: Column(
            children: [
              const HomeHeader(),
              Expanded(child: HabitsList()),
            ],
          ),
        ),
      ),
    );
  }
}
