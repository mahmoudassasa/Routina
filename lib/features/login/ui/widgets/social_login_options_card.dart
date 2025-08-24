

import 'package:flutter/material.dart';

import '../../../../core/helpers/app_constants.dart';

class SocialLoginOptions extends StatelessWidget {
  const SocialLoginOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing4),
        child: Column(
          children: [
            Text(
              'Or continue with',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.gray600,
              ),
            ),
            const SizedBox(height: AppSizes.spacing3),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google sign-in coming soon!')),
                      );
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: const Text('Google'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing3),
                      side: const BorderSide(color: AppColors.blue300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spacing3),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Apple sign-in coming soon!')),
                      );
                    },
                    icon: const Icon(Icons.apple, size: 20),
                    label: const Text('Apple'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing3),
                      side: const BorderSide(color: AppColors.blue300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}