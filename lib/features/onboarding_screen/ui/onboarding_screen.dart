import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/routing/routes.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background with smooth color transition
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark
                      ? const Color(0xFF1A1A1A)
                      : AppColors.backgroundGradientStart,
                  isDark ? Colors.black : AppColors.backgroundGradientEnd,
                ],
              ),
            ),
          ),

          // Theme Toggle Button (Themed)
          Positioned(
            top: 50,
            left: 20,
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  child: FloatingActionButton.small(
                    heroTag: 'themeToggle',
                    elevation: 0,
                    backgroundColor: isDark
                        ? Colors.white10
                        : AppColors.primary.withValues(alpha: 0.1),
                    shape: CircleBorder(
                      side: BorderSide(
                        color: isDark
                            ? Colors.white24
                            : AppColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    child: Icon(
                      isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: isDark
                          ? Colors.amber[400]
                          : AppColors
                                .primary, // Amber color for sun icon in dark mode
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SkipButton(
                  onPressed: () =>
                      context.pushReplacementNamed(Routes.loginScreen),
                ),

                Expanded(
                  flex: 3,
                  child: OnboardingPageView(
                    pageController: _pageController,
                    currentPage: _currentPage,
                    pages: _pages,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PageIndicators(currentPage: _currentPage, pages: _pages),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: NextGetStartedButton(
                          onPressed: _handleNextPressed,
                          currentPage: _currentPage,
                          pages: _pages,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
