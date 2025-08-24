import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

final List<OnboardingPage> onboardingPages = [
  OnboardingPage(
    title: "Build Better Habits",
    description:
        "Track your daily habits and build a routine that sticks. Start your journey to a better you today.",
    icon: Icons.trending_up,
    color: AppColors.blue500,
  ),
  OnboardingPage(
    title: "Stay Motivated",
    description:
        "Get insights and analytics about your progress. See your streaks and celebrate your wins.",
    icon: Icons.analytics,
    color: AppColors.indigo500,
  ),
  OnboardingPage(
    title: "AI-Powered Insights",
    description:
        "Let our AI analyze your patterns and provide personalized recommendations for success.",
    icon: Icons.psychology,
    color: AppColors.blue600,
  ),
];
