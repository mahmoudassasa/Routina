import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

part 'widgets/header_card.dart';
part 'widgets/privacy_section.dart';
part 'widgets/footer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.l10n.privacyPolicyTitle,
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
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _buildHeaderCard(isDark, context),

            verticalSpace(24),
            _buildSection(
              isDark: isDark,
              icon: Icons.info_outline_rounded,
              title: context.l10n.privacy1Title,
              content: context.l10n.privacy1Content,
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.storage_rounded,
              title: context.l10n.privacy2Title,
              content: context.l10n.privacy2Content,
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.lock_outline_rounded,
              title: context.l10n.privacy3Title,
              content: context.l10n.privacy3Content,
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.auto_awesome_outlined,
              title: context.l10n.privacy4Title,
              content: context.l10n.privacy4Content,
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.person_outline_rounded,
              title: context.l10n.privacy5Title,
              content: context.l10n.privacy5Content,
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.child_care_rounded,
              title: context.l10n.privacy6Title,
              content: context.l10n.privacy6Content,
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.update_rounded,
              title: context.l10n.privacy7Title,
              content: context.l10n.privacy7Content,
            ),

            _buildSection(
              isDark: isDark,
              icon: Icons.mail_outline_rounded,
              title: context.l10n.privacy8Title,
              content: context.l10n.privacy8Content,
            ),

            verticalSpace(32),
            // Footer
            _buildFooter(isDark, context),

            verticalSpace(32),
          ],
        ),
      ),
    );
  }
}
