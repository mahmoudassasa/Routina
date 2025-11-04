import 'package:flutter/material.dart';
import 'package:routina/core/helpers/app_regex.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/helpers/password_validations.dart';

class RegisterScreenPasswordfield extends StatefulWidget {
  final TextEditingController passwordController;

  const RegisterScreenPasswordfield({super.key, required this.passwordController});

  @override
  State<RegisterScreenPasswordfield> createState() => _RegisterScreenPasswordfieldState();
}

class _RegisterScreenPasswordfieldState extends State<RegisterScreenPasswordfield> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final password = widget.passwordController.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        TextFormField(
          controller: widget.passwordController,
          obscureText: isObscure,
          onChanged: (_) => setState(() {}), 
          decoration: InputDecoration(
            hintText: "Enter your password",
            suffixIcon: IconButton(
              icon: Icon(
                isObscure ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textLight,
              ),
              onPressed: () => setState(() => isObscure = !isObscure),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            }
            if (!AppRegex.isPasswordValid(value)) {
              return "Password does not meet requirements";
            }
            return null;
          },
        ),

        verticalSpace(12),

        // ✅ Validation UI
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
