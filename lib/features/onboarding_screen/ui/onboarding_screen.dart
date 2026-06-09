import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/widgets/language_bottom_sheet.dart';
import 'package:routina/features/locale/logic/locale_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List<Map<String, String>> get _pages => [
    {
      'title': context.l10n.onboarding1Title,
      'subtitle': context.l10n.onboarding1Subtitle,
      'icon': '🎯',
    },
    {
      'title': context.l10n.onboarding2Title,
      'subtitle': context.l10n.onboarding2Subtitle,
      'icon': '📊',
    },
    {
      'title': context.l10n.onboarding3Title,
      'subtitle': context.l10n.onboarding3Subtitle,
      'icon': '🚀',
    },
  ];

  Future<void> _onFinish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    if (mounted) {
      context.pushReplacementNamed(Routes.loginScreen);
    }
  }

  void _handleNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onFinish();
    }
  }

  void _showPreferencesSheet(BuildContext context, bool isDark) {
    final themeCubit = context.read<ThemeCubit>();
    final localeCubit = context.read<LocaleCubit>();
    final darkModeLabel = context.l10n.darkMode;
    final languageLabel = context.l10n.language;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: themeCubit),
          BlocProvider.value(value: localeCubit),
        ],
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return ListTile(
                    leading: Icon(
                      state.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      darkModeLabel,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    trailing: Switch(
                      value: state.isDarkMode,
                      activeThumbColor: AppColors.primary,
                      onChanged: (_) =>
                          context.read<ThemeCubit>().toggleTheme(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.language_rounded,
                  color: AppColors.primary,
                ),
                title: Text(
                  languageLabel,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider.value(
                      value: localeCubit,
                      child: LanguageBottomSheet(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
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
          Positioned(
            top: 50,
            left: 20,
            child: FloatingActionButton.small(
              heroTag: 'settingsOnboarding',
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
              onPressed: () => _showPreferencesSheet(context, isDark),
              child: Icon(
                Icons.tune_rounded,
                color: isDark ? Colors.white70 : AppColors.primary,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SkipButton(onPressed: _onFinish),
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
                      PageIndicators(
                          currentPage: _currentPage, pages: _pages),
                      verticalSpace(40),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        child: NextGetStartedButton(
                          onPressed: _handleNextPressed,
                          currentPage: _currentPage,
                          pages: _pages,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpace(20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}