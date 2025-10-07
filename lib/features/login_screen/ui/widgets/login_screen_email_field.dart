import 'package:flutter/material.dart';

class LoginScreenEmailField extends StatefulWidget {
final TextEditingController _emailController ;
  const LoginScreenEmailField({super.key, required TextEditingController emailController }): _emailController = emailController;

  @override
  State<LoginScreenEmailField> createState() => _LoginScreenEmailFieldState();
}

class _LoginScreenEmailFieldState extends State<LoginScreenEmailField> {
  


  @override

  Widget build(BuildContext context) {
    return TextFormField(
      controller:widget._emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }
}
