import 'package:flutter/material.dart';
import 'package:routina/core/helpers/app_regex.dart';

class RegisterScreenEmailField extends StatelessWidget {
  const RegisterScreenEmailField({super.key, required this.emailController});

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(hintText: 'Email'),
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
