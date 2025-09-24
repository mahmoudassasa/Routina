import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';

import '../../../core/routing/routes.dart';
import 'widgets/next_get_started_button.dart';
import 'widgets/onboarding_page_view.dart';
import 'widgets/page_indicators.dart';
import 'widgets/skip_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome to Routina',
      'subtitle':
          'Build better habits with our beautiful and intuitive tracker',
      'icon': '🎯',
    },
    {
      'title': 'Track Your Progress',
      'subtitle':
          'Monitor your daily habits and see your improvements over time',
      'icon': '📊',
    },
    {
      'title': 'Stay Motivated',
      'subtitle': 'Get AI-powered insights and personalized recommendations',
      'icon': '🚀',
    },
  ];

  void _handleNextPressed() {
    if (_currentPage < _pages.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pushReplacementNamed(Routes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundGradientStart,
              AppColors.backgroundGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              SkipButton(
                onPressed: () => context.pushReplacementNamed(Routes.loginScreen),
              ),
              // Page View
              OnboardingPageView(
                pageController: _pageController,
                currentPage: _currentPage,
                pages: _pages,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
              // Page Indicators
              PageIndicators(
                currentPage: _currentPage,
                pages: _pages,
              ),
              const SizedBox(height: 32),
              // Next/Get Started Button
              NextGetStartedButton(
                onPressed: _handleNextPressed,
                currentPage: _currentPage,
                pages: _pages,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
