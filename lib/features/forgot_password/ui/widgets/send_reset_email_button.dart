import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';

class SendResetEmailButton extends StatefulWidget {
  final TextEditingController _emailController;
  const SendResetEmailButton({super.key, required TextEditingController emailController})
      : _emailController = emailController;

  @override
  State<SendResetEmailButton> createState() => _SendResetEmailButtonState();
}

class _SendResetEmailButtonState extends State<SendResetEmailButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _sendResetEmail ,
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
              ),
            )
          : const Text('Send Reset Link'),
    );
  }

  Future<void> _sendResetEmail() async {
    if (widget._emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }
}
