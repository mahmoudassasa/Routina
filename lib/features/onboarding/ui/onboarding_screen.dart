import 'package:flutter/material.dart';
import '../../../core/helpers/app_constants.dart';
import '../../login/ui/login_screen.dart';
import 'widgets/onboarding_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.blue25, AppColors.indigo25],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(AppSizes.spacing4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 60),
                    Text(
                      'Habit Tracker',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.blue600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _navigateToLogin(),
                      child: Text(
                        'Skip',
                        style: AppTextStyles.bodyBase.copyWith(
                          color: AppColors.blue600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: onboardingPages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: onboardingPages[index].color.withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Icon(
                              onboardingPages[index].icon,
                              size: 60,
                              color: onboardingPages[index].color,
                            ),
                          ),
                          
                          const SizedBox(height: AppSizes.spacing8),
                          
                          // Title
                          Text(
                            onboardingPages[index].title,
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: AppSizes.spacing4),
                          
                          // Description
                          Text(
                            onboardingPages[index].description,
                            style: AppTextStyles.bodyBase.copyWith(
                              fontSize: 16,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingPages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index 
                          ? AppColors.blue500 
                          : AppColors.blue500.withValues(alpha:0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing6),
              
              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.all(AppSizes.spacing6),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.blue500),
                            padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: AppTextStyles.bodyBase.copyWith(
                              color: AppColors.blue500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    
                    if (_currentPage > 0) const SizedBox(width: AppSizes.spacing4),
                    
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage == onboardingPages.length - 1) {
                            _navigateToLogin();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue500,
                          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                          ),
                        ),
                        child: Text(
                          _currentPage == onboardingPages.length - 1 ? 'Get Started' : 'Next',
                          style: AppTextStyles.bodyBase.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
