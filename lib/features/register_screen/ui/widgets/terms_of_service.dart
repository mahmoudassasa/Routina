import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';

Widget termsAndConditionsText(BuildContext context) {
  return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  child: RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      children: [
        TextSpan(text: context.l10n.bySigningUpYouAgreeTo),
        TextSpan(
          text: ' ${context.l10n.termsOfService}',
          style: const TextStyle(
            color: AppColors.primaryLight,
            fontWeight: FontWeight.w600,
          ),
          recognizer: TapGestureRecognizer()..onTap = openTermsOfService,
        ),
        TextSpan(text: ' ${context.l10n.and} '),
        TextSpan(
          text: context.l10n.privacyPolicy,
          style:  TextStyle(
            color: AppColors.primaryLight,
            fontWeight: FontWeight.w600,
          ),
          recognizer: TapGestureRecognizer()..onTap = openPrivacyPolicy,
        ),
      ],
    ),
  ),
  );

}