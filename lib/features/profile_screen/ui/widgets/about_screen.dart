import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String _version = '';

  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.routina.app';

  static const String _privacyPolicyUrl =
      'https://mellow-lokum-05a071.netlify.app/';

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });

    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();

    if (mounted) {
      setState(() {
        _version = '${info.version} (${info.buildNumber})';
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _scaffoldBg =>
      _isDark ? AppColors.darkBackground : AppColors.background;

  Color get _surfaceColor =>
      _isDark ? AppColors.darkSurface : AppColors.surface;

  Color get _borderColor => _isDark ? AppColors.darkBorder : AppColors.border;

  Color get _textPrimary =>
      _isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

  Color get _textSecondary =>
      _isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.couldNotOpenBrowser)));
    }
  }

  void _shareApp() {
    Share.share(context.l10n.shareAppMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  verticalSpace(8),
                  _buildAppIdentityCard(),
                  verticalSpace(24),
                  _buildActionsList(),
                  verticalSpace(48),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: _scaffoldBg,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary),
        onPressed: () => context.pop(),
      ),
      title: Text(
        context.l10n.about,
        style: AppTextStyles.headlineSmall.copyWith(color: _textPrimary),
      ),
    );
  }

  Widget _buildAppIdentityCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: Image.asset(
              'assets/icons/routina_icon.png',
              width: 40.w,
              height: 40.w,
            ),
          ),
          verticalSpace(16),
          Text(
            context.l10n.appName,
            style: AppTextStyles.displaySmall.copyWith(color: _textPrimary),
          ),
          verticalSpace(6),
          if (_version.isNotEmpty)
            Text(
              context.l10n.appVersion(_version),
              style: AppTextStyles.bodySmall.copyWith(color: _textSecondary),
            ),
          verticalSpace(16),
          Text(
            context.l10n.madeWithLove,
            style: AppTextStyles.bodySmall.copyWith(color: _textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsList() {
    final items = [
      _AboutItem(
        icon: Icons.star_rounded,
        iconColor: const Color(0xFFFFC107),
        title: context.l10n.rateApp,
        subtitle: context.l10n.rateAppSubtitle,
        onTap: () => _launchUrl(_playStoreUrl),
      ),
      _AboutItem(
        icon: Icons.share_rounded,
        iconColor: AppColors.primary,
        title: context.l10n.shareApp,
        subtitle: context.l10n.shareAppSubtitle,
        onTap: _shareApp,
      ),
      _AboutItem(
        icon: Icons.privacy_tip_outlined,
        iconColor: AppColors.primary,
        title: context.l10n.privacyPolicy,
        subtitle: null,
        onTap: () => _showPrivacyOptions(),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;

          return Column(
            children: [
              _buildActionTile(item),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: _borderColor,
                  indent: 56.w,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildActionTile(_AboutItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: item.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: _textPrimary,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    verticalSpace(2),
                    Text(
                      item.subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: _textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            verticalSpace(20),
            Text(
              context.l10n.privacyPolicy,
              style: AppTextStyles.titleMedium.copyWith(color: _textPrimary),
            ),
            verticalSpace(20),
            _privacyOptionTile(
              icon: Icons.phone_android_rounded,
              title: context.l10n.privacyPolicy,
              subtitle: context.l10n.privacyPolicySubtitle,
              onTap: () {
                context.pop();
                context.pushNamed(Routes.privacyPolicyScreen);
              },
            ),
            verticalSpace(12),
            _privacyOptionTile(
              icon: Icons.open_in_new_rounded,
              title: context.l10n.privacyPolicyWeb,
              subtitle: context.l10n.privacyPolicyWebSubtitle,
              onTap: () {
                context.pop();
                _launchUrl(_privacyPolicyUrl);
              },
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _privacyOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: _borderColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.shield_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: _textPrimary,
                    ),
                  ),
                  verticalSpace(2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: _textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _AboutItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
