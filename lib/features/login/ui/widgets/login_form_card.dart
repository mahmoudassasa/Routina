import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';
import '../../../home/ui/home_screen.dart';
import 'forgot_password_screen.dart';

class LoginFormCard extends StatefulWidget {
  const LoginFormCard({super.key});

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate to main app
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  // void _handleLogin() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     // Simulate a login delay
  //     Future.delayed(const Duration(seconds: 2), () {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       // Handle successful login here
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius2xl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius2xl),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    borderSide: const BorderSide(color: AppColors.blue300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    borderSide: const BorderSide(color: AppColors.blue500, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.blue50,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSizes.spacing4),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    borderSide: const BorderSide(color: AppColors.blue300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    borderSide: const BorderSide(color: AppColors.blue500, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.blue50,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSizes.spacing2),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.blue600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.spacing4),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue500,
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : Text(
                          'Sign In',
                          style: AppTextStyles.bodyBase.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}