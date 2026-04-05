import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Privacy Policy',
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.primaryDark.withOpacity(0.3), AppColors.darkSurface]
                      : [AppColors.primaryLighter, AppColors.background],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_rounded, color: AppColors.primary, size: 32.sp),
                  SizedBox(height: 12.h),
                  Text(
                    'Your Privacy Matters',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Last updated: April 2026',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            _buildSection(
              isDark: isDark,
              icon: Icons.info_outline_rounded,
              title: '1. Information We Collect',
              content:
                  'Routina collects only the information necessary to provide our habit tracking service. This includes your email address for authentication, habit data you create within the app, and basic usage analytics to improve your experience.',
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.storage_rounded,
              title: '2. How We Use Your Data',
              content:
                  'Your data is used solely to power the features of Routina, including habit tracking, progress analysis, and AI-powered insights. We do not sell, rent, or share your personal information with third parties for marketing purposes.',
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.lock_outline_rounded,
              title: '3. Data Security',
              content:
                  'We use industry-standard security measures including Firebase Authentication and Supabase with Row Level Security (RLS) to protect your data. All data is encrypted in transit and at rest.',
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.auto_awesome_outlined,
              title: '4. AI Features',
              content:
                  'The AI analysis feature in Routina uses Google Gemini to process your habit data. This processing is done securely and your data is not stored or used to train AI models. AI responses are generated in real-time and not retained by third parties.',
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.person_outline_rounded,
              title: '5. Your Rights',
              content:
                  'You have the right to access, correct, or delete your personal data at any time. You can delete your account and all associated data directly from the app settings. For any privacy-related requests, contact us at dev.egy01@gmail.com.',
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.child_care_rounded,
              title: '6. Children\'s Privacy',
              content:
                  'Routina is not directed at children under the age of 13. We do not knowingly collect personal information from children. If you believe a child has provided us with personal information, please contact us immediately.',
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.update_rounded,
              title: '7. Changes to This Policy',
              content:
                  'We may update this Privacy Policy from time to time. We will notify you of any significant changes through the app or via email. Continued use of Routina after changes constitutes acceptance of the updated policy.',
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.mail_outline_rounded,
              title: '8. Contact Us',
              content:
                  'If you have any questions about this Privacy Policy or our data practices, please contact us at dev.egy01@gmail.com. We aim to respond to all inquiries within 48 hours.',
            ),

            SizedBox(height: 32.h),

            // Footer
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Text(
                '© 2026 Routina. All rights reserved.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required bool isDark,
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDark.withOpacity(0.2)
                      : AppColors.primaryLighter,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 48.w),
            child: Text(
              content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Divider(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}