import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart'; // تأكد من المسار

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileLogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        color: AppColors.errorLight.withValues(alpha:0.5), // خلفية حمراء شفافة جداً
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.error.withValues(alpha:0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.error.withValues(alpha:0.1), // إطار أحمر خفيف
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Icon Box
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Text
                const Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error, // نص أحمر
                  ),
                ),
                
                const Spacer(),
                
                // Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.error.withValues(alpha:0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}