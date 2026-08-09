import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';

Future<void> showOtpVerificationSheet(
  BuildContext context, {
  required String verificationId,
  required String phone,
  required ProfileCubit cubit,
  required VoidCallback onSuccess,
}) {
  final otpController = TextEditingController();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.enterVerificationCode,
              style: AppTextStyles.headlineSmall.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            verticalSpace(16),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 20.sp,
                letterSpacing: 8,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: '000000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            verticalSpace(20),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () async {
                  final smsCode = otpController.text.trim();
                  if (smsCode.length == 6) {
                    try {
                      final credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: smsCode,
                      );

                      final currentUser = FirebaseAuth.instance.currentUser;

                      if (currentUser != null) {
                        await currentUser.linkWithCredential(credential);

                        await cubit.confirmPhoneVerified(phone);

                        if (!ctx.mounted) return;
                        onSuccess();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.l10n.phoneVerifiedSuccessfully,
                            ),
                          ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (!ctx.mounted) return;

                      String errorMessage =
                          context.l10n.invalidCode(e.message ?? '');

                      if (e.code == 'credential-already-in-use') {
                        errorMessage = context.l10n.phoneAlreadyInUse;
                      } else if (e.code == 'provider-already-linked') {
                        errorMessage = context.l10n.providerAlreadyLinked;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } catch (e) {
                      if (!ctx.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.l10n.invalidCode(e.toString()),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  context.l10n.verify,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}