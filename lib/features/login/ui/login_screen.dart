import 'package:flutter/material.dart';
import '../../../core/helpers/app_constants.dart';
import '../../signup/ui/register_screen.dart';
import 'widgets/login_form_card.dart';
import 'widgets/social_login_options_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spacing6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.spacing6),

                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.blue500.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.track_changes,
                          size: 40,
                          color: AppColors.blue500,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      Text(
                        'Welcome Back',
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing2),
                      Text(
                        'Sign in to continue your habit journey',
                        style: AppTextStyles.bodyBase.copyWith(
                          color: AppColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.spacing8),

                // Login Form Card
                const LoginFormCard(),

                const SizedBox(height: AppSizes.spacing6),

                // Social Login Options
                const SocialLoginOptions(),

                const SizedBox(height: AppSizes.spacing4),

                // Register Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: AppTextStyles.bodyBase,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.bodyBase.copyWith(
                            color: AppColors.blue600,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
