import 'package:flutter/material.dart';
import 'package:routina/core/helpers/app_regex.dart';
import 'package:routina/core/theaming/app_colors.dart';

class RegisterScreenEmailField extends StatelessWidget {
  const RegisterScreenEmailField({super.key, required this.emailController});

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'Email Address',
        labelStyle: TextStyle(
          color: isDark ? Colors.white60 : AppColors.textSecondary,
        ),
        hintText: 'Enter your email',
        hintStyle: TextStyle(
          color: isDark ? Colors.white30 : Colors.grey[400],
        ),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: isDark ? AppColors.primaryLight : AppColors.primary,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        } else if (!AppRegex.isEmailValid(value.trim())) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}