import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/features/email_confirmation_screen/logic/cubit/email_verification_cubit.dart';

part 'widgets/background.dart';
part 'widgets/main_content_card.dart';
part 'widgets/email_icon.dart';
part 'widgets/premium_button.dart';
part 'widgets/secondary_button.dart';
part 'widgets/success_dialog.dart';

class EmailConfirmationScreen extends StatelessWidget {
  const EmailConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => EmailVerificationCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            _Background(isDark: isDark),

            _MainContentCard(
              isDark: isDark,
              child:
                  BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
                    listener: _handleStateListeners,
                    builder: (context, state) {
                      final cubit = context.read<EmailVerificationCubit>();
                      return _buildBody(context, state, cubit, isDark);
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

void _handleStateListeners(BuildContext context, EmailVerificationState state) {
  final l10n = context.l10n;

  if (state is EmailVerificationEmailSent) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.verificationEmailSent),
      ),
    );
  }

  if (state is EmailVerificationVerified) {
    _SuccessDialog.show(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.pop();
        context.pushReplacementNamed(Routes.loginScreen);
      }
    });
  }

  if (state is EmailVerificationNotVerified) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.emailNotVerified),
      ),
    );
  }

  if (state is EmailVerificationError) {
    final msg = switch (state.message) {
      'send_error' => l10n.sendEmailError,
      'check_error' => l10n.checkVerificationError,
      _ => l10n.somethingWentWrong,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Widget _buildBody(
    BuildContext context,
    EmailVerificationState state,
    EmailVerificationCubit cubit,
    bool isDark,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _EmailIcon(isDark: isDark),
        verticalSpace(24),

        Text(
          context.l10n.confirmEmail,
          style: AppTextStyles.displaySmall.copyWith(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        verticalSpace(12),

        Text(
          context.l10n.confirmEmailDesc,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
        verticalSpace(32),

        _PremiumButton(
          label: state is EmailVerificationTimerTick
              ? context.l10n.resendIn(state.seconds)
              : context.l10n.resendEmail,
          isLoading: false,
          isDisabled: state is EmailVerificationTimerTick,
          onPressed: () => cubit.resendEmail(),
          isDark: isDark,
        ),

        verticalSpace(16),

        _SecondaryButton(
          label: context.l10n.iVerifiedEmail,
          isLoading: state is EmailVerificationLoading,
          onPressed: () => cubit.checkVerification(),
          isDark: isDark,
        ),

        verticalSpace(16),

TextButton(
  onPressed: () async {
    await FirebaseAuth.instance.currentUser?.delete();
    if (context.mounted) {
      context.pushReplacementNamed(Routes.registerScreen);
    }
  },
  child: Text(
    context.l10n.wrongEmail,
    style: TextStyle(
      color: Colors.redAccent,
      fontSize: 14.sp,
    ),
  ),
),
      ],
    );
  }
}
