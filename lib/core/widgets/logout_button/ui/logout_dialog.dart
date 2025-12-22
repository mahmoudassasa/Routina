import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_cubit.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_state.dart';

Future<void> showLogoutDialog(BuildContext context) async {
  // نحصل على الـ Cubit قبل فتح الدايلوج
  final logoutCubit = context.read<LogoutCubit>();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider.value(
        // نمرر الـ cubit الموجود للدايلوج
        value: logoutCubit,
        child: Dialog(
          backgroundColor: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            // داخل ملف logout_dialog.dart
            // ...
            child: BlocBuilder<LogoutCubit, LogoutState>(
              // حولناه لـ Builder فقط بدون Listener
              // جوه ملف logout_dialog.dart
              builder: (context, state) {
                // التعديل هنا: خليه يشوف الـ loading والـ success كأنهم عملية معالجة واحدة
                final isProcessing =
                    state.status == LogoutStatus.loading ||
                    state.status == LogoutStatus.success;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: isProcessing
                      ? _buildProcessingView() // كدة الرسالة هتفضل ظاهرة حتى لما الـ signOut تخلص وندخل في الـ Success
                      : _buildConfirmView(context, () {
                          context.read<LogoutCubit>().logout();
                        }),
                );
              },
            ),
            // ...
          ),
        ),
      );
    },
  );
}

// واجهة السؤال (نفس الكود السابق مع إضافة key للأنيميشن)
Widget _buildConfirmView(BuildContext context, VoidCallback onConfirm) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    key: const ValueKey('confirm'),
    children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.errorLight,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.logout_rounded,
          size: 32,
          color: AppColors.error,
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        "Log Out",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        "Are you sure you want to log out?",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
      ),
      const SizedBox(height: 32),
      Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Log Out",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// واجهة التحميل الحقيقي
Widget _buildProcessingView() {
  return const Column(
    mainAxisSize: MainAxisSize.min,
    key: ValueKey('processing'),
    children: [
      SizedBox(height: 10),
      CircularProgressIndicator(color: AppColors.primary, strokeWidth: 4),
      SizedBox(height: 24),
      Text(
        "Signing out...",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      SizedBox(height: 8),
      Text(
        "Finalizing your session 👋",
        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
      SizedBox(height: 10),
    ],
  );
}
