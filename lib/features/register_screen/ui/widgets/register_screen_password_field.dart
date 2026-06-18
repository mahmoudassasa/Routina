import 'package:flutter/material.dart';
import 'package:routina/core/helpers/app_regex.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/helpers/password_validations.dart';

class RegisterScreenPasswordfield extends StatefulWidget {
  final TextEditingController passwordController;

  const RegisterScreenPasswordfield({
    super.key,
    required this.passwordController,
  });

  @override
  State<RegisterScreenPasswordfield> createState() =>
      _RegisterScreenPasswordfieldState();
}

class _RegisterScreenPasswordfieldState
    extends State<RegisterScreenPasswordfield> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final password = widget.passwordController.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.passwordController,
          obscureText: isObscure,
          onChanged: (_) => setState(() {}),
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            labelText: context.l10n.password,
            labelStyle: TextStyle(
              color: isDark ? Colors.white60 : AppColors.textSecondary,
            ),
            hintText: context.l10n.enterPassword,
            hintStyle: TextStyle(
              color: isDark ? Colors.white30 : Colors.grey[400],
            ),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: isDark ? Colors.white60 : AppColors.textLight,
              ),
              onPressed: () => setState(() => isObscure = !isObscure),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.l10n.passwordRequired;
            }
            if (!AppRegex.isPasswordValid(value)) {
              return context.l10n.passwordInvalid;
            }
            return null;
          },
        ),

        verticalSpace(16),

        // Validation UI with current password state
        PasswordValidations(
          hasUpperCase: AppRegex.hasUpperCase(password),
          hasLowerCase: AppRegex.hasLowerCase(password),
          hasSpecialCharacters: AppRegex.hasSpecialCharacter(password),
          hasNumber: AppRegex.hasNumber(password),
          hasMinLength: AppRegex.hasMinLength(password),
        ),
      ],
    );
  }
}
