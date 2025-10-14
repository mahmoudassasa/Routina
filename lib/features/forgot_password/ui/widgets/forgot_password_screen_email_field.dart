import 'package:flutter/material.dart';

class ForgotPasswordScreenEmailField extends StatefulWidget {
  final TextEditingController _emailController;
  const ForgotPasswordScreenEmailField({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  @override
  State<ForgotPasswordScreenEmailField> createState() =>
      _ForgotPasswordScreenEmailFieldState();
}

class _ForgotPasswordScreenEmailFieldState
    extends State<ForgotPasswordScreenEmailField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }
}
