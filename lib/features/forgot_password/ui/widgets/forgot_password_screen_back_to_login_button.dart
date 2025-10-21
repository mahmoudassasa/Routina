import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';

class ForgotPasswordScreenBackToLoginButton extends StatefulWidget {
  const ForgotPasswordScreenBackToLoginButton({
    super.key,
      this.textStyle,
  });
  final TextStyle? textStyle;
  @override
  State<ForgotPasswordScreenBackToLoginButton> createState() =>
      _ForgotPasswordScreenBackToLoginButtonState();
}

class _ForgotPasswordScreenBackToLoginButtonState
    extends State<ForgotPasswordScreenBackToLoginButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.pushReplacementNamed(Routes.loginScreen),
      child: Text('Back to Login', style: widget.textStyle),
    );
  }
}
