import 'package:flutter/material.dart';

class RegisterScreenPasswordfield extends StatefulWidget {
  const RegisterScreenPasswordfield({
    super.key,
    required TextEditingController passwordController,
    required bool isPasswordVisible,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;
  @override
  State<RegisterScreenPasswordfield> createState() =>
      _RegisterScreenPasswordfieldState();
}

class _RegisterScreenPasswordfieldState
    extends State<RegisterScreenPasswordfield> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}
