import 'package:flutter/material.dart';

class RegisterScreenNameField extends StatefulWidget {
  const RegisterScreenNameField({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;
  final TextEditingController _nameController;
  @override
  State<RegisterScreenNameField> createState() =>
      _RegisterScreenNameFieldState();
}

class _RegisterScreenNameFieldState extends State<RegisterScreenNameField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._nameController,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }
}
