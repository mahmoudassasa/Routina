import 'package:flutter/material.dart';

class LoginScreenPasswordField extends StatefulWidget {
  const LoginScreenPasswordField({
    super.key,
    required TextEditingController passwordController,
    required bool isPasswordVisible,
    required VoidCallback togglePasswordVisibility,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;


  @override
  State<LoginScreenPasswordField> createState() => _LoginScreenPasswordFieldState();
}

class _LoginScreenPasswordFieldState extends State<LoginScreenPasswordField> {
  bool _isPasswordVisible = false; // add this line

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
              _isPasswordVisible = !_isPasswordVisible; // update the state
            });
          },
        ),
      ),
    );
  }
}