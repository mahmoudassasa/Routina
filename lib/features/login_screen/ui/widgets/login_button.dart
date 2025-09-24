import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/login_screen/logic/cubit/login_cubit.dart';
import 'package:routina/features/login_screen/logic/cubit/login_state.dart';

class LoginButton extends StatefulWidget {
  final TextEditingController _passwordController;
  final TextEditingController _emailController;
  const LoginButton({
    super.key,
    required TextEditingController passwordController,
    required TextEditingController emailController,
  }) : _passwordController = passwordController,
       _emailController = emailController;

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(Object context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.status == LoginStatus.loading
              ? null
              : () {
                  context.read<LoginCubit>().login(
                    widget._emailController.text,
                    widget._passwordController.text,
                  );
                },
          child: state.status == LoginStatus.loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.textWhite,
                    ),
                  ),
                )
              : const Text('Sign In'),
        );
      },
    );
  }
}
