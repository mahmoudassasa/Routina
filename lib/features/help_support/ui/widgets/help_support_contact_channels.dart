part of '../help_support_screen.dart';

extension _HelpSupportContactChannels on _HelpSupportScreenState {
  Widget _contactChannels() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.4,
      children: [
        _channelCard(
          'Email',
          Icons.email_rounded,
          AppColors.primary,
          _launchEmail,
        ),
        _channelCard(
          'WhatsApp',
          Icons.chat_rounded,
          AppColors.success,
          _launchWhatsApp,
        ),
        _channelCard(
          'Telegram',
          Icons.send_rounded,
          AppColors.primaryDark,
          _launchTelegram,
        ),
        _channelCard(
          'Discord',
          Icons.discord,
          AppColors.accent,
          _launchDiscord,
        ),
      ],
    );
  }

  Widget _channelCard(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: color.withValues(alpha: _isDark ? 0.15 : 0.1),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22.sp),
              horizontalSpace(10),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
