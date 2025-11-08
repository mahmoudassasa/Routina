import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';

class LoginScreenPasswordField extends StatefulWidget {
  const LoginScreenPasswordField({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  State<LoginScreenPasswordField> createState() => _LoginScreenPasswordFieldState();
}

class _LoginScreenPasswordFieldState extends State<LoginScreenPasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._passwordController,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: AppColors.textSecondary),

        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),

        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.textSecondary,
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),

        // Borders
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        return null;
      },
    );
  }
}
