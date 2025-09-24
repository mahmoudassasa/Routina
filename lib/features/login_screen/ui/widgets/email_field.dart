import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
final TextEditingController _emailController ;
  const EmailField({super.key, required TextEditingController emailController }): _emailController = emailController;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  


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
