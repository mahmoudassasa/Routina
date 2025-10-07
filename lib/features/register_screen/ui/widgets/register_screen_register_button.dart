import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/register_screen/logic/cubit/register_cubit.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';

class RegisterScreenRegisterButton extends StatefulWidget {
  const RegisterScreenRegisterButton({
    super.key,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _nameController = nameController,
       _emailController = emailController,
       _passwordController = passwordController;

  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  State<RegisterScreenRegisterButton> createState() =>
      _RegisterScreenRegisterButtonState();
}

class _RegisterScreenRegisterButtonState
    extends State<RegisterScreenRegisterButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.status == RegisterStatus.loading
              ? null
              : () {
                  context.read<RegisterCubit>().signUp(
                    widget._nameController.text,
                    widget._emailController.text,
                    widget._passwordController.text,
                  );
                },
          child: state.status == RegisterStatus.loading
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
              : const Text('Create Account'),
        );
      },
    );
  }
}
