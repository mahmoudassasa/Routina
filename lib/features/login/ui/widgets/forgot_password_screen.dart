import 'package:flutter/material.dart';
import '../../../../core/helpers/app_constants.dart';
import '../login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
                // Back Button
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.blue600,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.blue50,
                        padding: const EdgeInsets.all(AppSizes.spacing2),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spacing2),
                    Text(
                      'Back to Login',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.blue600,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSizes.spacing6),
                
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _isEmailSent 
                              ? AppColors.green500.withValues(alpha:0.1)
                              : AppColors.blue500.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          _isEmailSent ? Icons.mark_email_read : Icons.lock_reset,
                          size: 40,
                          color: _isEmailSent ? AppColors.green500 : AppColors.blue500,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      Text(
                        _isEmailSent ? 'Check Your Email' : 'Forgot Password?',
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing2),
                      Text(
                        _isEmailSent 
                            ? 'We\'ve sent password reset instructions to your email'
                            : 'No worries! Enter your email and we\'ll send you reset instructions',
                        style: AppTextStyles.bodyBase.copyWith(
                          color: AppColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSizes.spacing8),
                
                // Main Content Card
                Card(
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
                    child: _isEmailSent ? _buildSuccessContent() : _buildResetForm(),
                  ),
                ),
                
                const SizedBox(height: AppSizes.spacing6),
                
                // Additional Options
                if (!_isEmailSent) _buildHelpOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
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
                return 'Please enter your email address';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          
          const SizedBox(height: AppSizes.spacing6),
          
          // Reset Password Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handlePasswordReset,
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
                      'Send Reset Instructions',
                      style: AppTextStyles.bodyBase.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        // Success Message
        Container(
          padding: const EdgeInsets.all(AppSizes.spacing4),
          decoration: BoxDecoration(
            color: AppColors.green500.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.green500.withValues(alpha:0.2)),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.green500,
                size: 48,
              ),
              const SizedBox(height: AppSizes.spacing3),
              Text(
                'Email Sent Successfully!',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.green500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.spacing2),
              Text(
                'Check your email and follow the instructions to reset your password.',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppSizes.spacing6),
        
        // Resend Email Button
        OutlinedButton(
          onPressed: () {
            setState(() {
              _isEmailSent = false;
            });
            _emailController.clear();
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.blue500),
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.spacing3,
              horizontal: AppSizes.spacing6,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
          ),
          child: Text(
            'Send to Different Email',
            style: AppTextStyles.bodyBase.copyWith(
              color: AppColors.blue500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        const SizedBox(height: AppSizes.spacing4),
        
        // Back to Login Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue500,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              elevation: 2,
            ),
            child: Text(
              'Back to Login',
              style: AppTextStyles.bodyBase.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpOptions() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing4),
        child: Column(
          children: [
            Text(
              'Need more help?',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSizes.spacing3),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contact support feature coming soon!'),
                          backgroundColor: AppColors.blue500,
                        ),
                      );
                    },
                    icon: const Icon(Icons.support_agent, size: 18),
                    label: const Text('Contact Support'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing3),
                      side: const BorderSide(color: AppColors.blue300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spacing3),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('FAQ section coming soon!'),
                          backgroundColor: AppColors.blue500,
                        ),
                      );
                    },
                    icon: const Icon(Icons.help_outline, size: 18),
                    label: const Text('View FAQ'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing3),
                      side: const BorderSide(color: AppColors.blue300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.spacing4),
            
            // Back to Login Link
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  'Back to Login',
                  style: AppTextStyles.bodyBase.copyWith(
                    color: AppColors.blue600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isEmailSent = true;
      });
    }
  }
}