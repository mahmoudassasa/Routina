// Email Field
import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';

class LoginScreenEmailField extends StatelessWidget {
  final TextEditingController emailController;
  const LoginScreenEmailField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: context.l10n.emailAddress,
        labelStyle: TextStyle(
          color: isDark ? Colors.white60 : AppColors.textSecondary,
        ),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: isDark ? AppColors.primaryLight : AppColors.primary,
        ),
      ),
    );
  }
}
