import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';

class RegisterScreenNameField extends StatelessWidget {
  const RegisterScreenNameField({super.key, required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: nameController,
      keyboardType: TextInputType.name,
      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: context.l10n.fullName,
        labelStyle: TextStyle(
          color: isDark ? Colors.white60 : AppColors.textSecondary,
        ),
        hintText: context.l10n.enterFullName,
        hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.grey[400]),
        prefixIcon: Icon(
          Icons.person_outline_rounded,
          color: isDark ? AppColors.primaryLight : AppColors.primary,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return context.l10n.nameRequired;
        } else if (value.trim().length < 3) {
          return context.l10n.nameMinLength;
        }
        return null;
      },
    );
  }
}
