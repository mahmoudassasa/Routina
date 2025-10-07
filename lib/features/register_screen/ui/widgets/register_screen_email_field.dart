import 'package:flutter/material.dart';

class RegisterScreenEmailField extends StatefulWidget {
  const RegisterScreenEmailField({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;
  @override
  State<RegisterScreenEmailField> createState() =>
      _RegisterScreenEmailFieldState();
}

class _RegisterScreenEmailFieldState extends State<RegisterScreenEmailField> {
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
