// Password Field
import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';

class LoginScreenPasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  const LoginScreenPasswordField({super.key, required this.passwordController});

  @override
  State<LoginScreenPasswordField> createState() => _LoginScreenPasswordFieldState();
}

class _LoginScreenPasswordFieldState extends State<LoginScreenPasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: widget.passwordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: isDark ? Colors.white60 : AppColors.textSecondary),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: isDark ? AppColors.primaryLight : AppColors.primary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            color: isDark ? Colors.white38 : AppColors.textSecondary,
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
    );
  }
}