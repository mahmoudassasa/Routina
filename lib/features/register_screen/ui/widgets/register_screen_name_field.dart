import 'package:flutter/material.dart';

class RegisterScreenNameField extends StatelessWidget {
  const RegisterScreenNameField({super.key, required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: const InputDecoration(hintText: 'Full Name'),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your name';
        } else if (value.trim().length < 3) {
          return 'Name must be at least 3 characters';
        }
        return null;
      },
    );
  }
}
