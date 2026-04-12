import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int? _expandedFaqIndex;
  final _bugSubjectController = TextEditingController();
  final _bugBodyController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactMessageController = TextEditingController();

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
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bugSubjectController.dispose();
    _bugBodyController.dispose();
    _contactNameController.dispose();
    _contactMessageController.dispose();
    super.dispose();
  }

  static const String _supportEmail = 'dev.egy01@gmail.com';
  static const String _whatsappNumber = '+201152461600';
  static const String _telegramUsername = 'mahmoud_assasa';
  static const String _discordInvite = 'https://discord.com/channels/@3ma97';
  static const String _privacyPolicyUrl =
      'https://mellow-lokum-05a071.netlify.app/';

  final List<_FaqItem> _faqs = const [
    _FaqItem(
      question: 'How do I add a new habit?',
      answer:
          'Tap the + button on the home screen, fill in the habit details like title, frequency, then tap Create Habit button.',
    ),
    _FaqItem(
      question: 'How do streaks work?',
      answer:
          'A streak counts the consecutive days you complete a habit. Missing a scheduled day resets your streak back to zero.',
    ),
    _FaqItem(
      question: 'Can I edit or delete a habit?',
      answer:
          'Yes! Swipe to the left any habit card to Delete. To edit press on the pen button.',
    ),
    _FaqItem(
      question: 'Why am I not getting reminders?',
      answer:
          'Make sure notifications are enabled for Routina in your phone Settings → Apps → Routina → Notifications. Also check that Do Not Disturb is off.',
    ),
  ];

  final List<_GuideItem> _guides = const [
    _GuideItem(
      icon: Icons.rocket_launch_rounded,
      title: 'Getting Started',
      steps: [
        'Open Routina and tap the + button',
        'Enter your habit name and choose an icon',
        'Set which days of the week to track it',
        'Optionally add a reminder time',
        'Tap Save — your habit is live!',
      ],
    ),
    _GuideItem(
      icon: Icons.notifications_active_rounded,
      title: 'Setting Up Reminders',
      steps: [
        'Tap on to Profile screen to open it',
        'Tap the bell icon or to set the reminder',
        'Pick your preferred time',
        'Make sure Routina has notification permission',
        'You\'ll get a daily nudge at that time',
      ],
    ),
  ];

  Future<void> _launchEmail({String subject = '', String body = ''}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      },
    );
    if (!await launchUrl(uri)) _showError('Could not open mail app.');
  }

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/${_whatsappNumber.replaceAll('+', '')}?text=Hi%2C%20I%20need%20help%20with%20Routina',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showError('WhatsApp is not installed.');
    }
  }

  Future<void> _launchTelegram() async {
    final uri = Uri.parse('https://t.me/$_telegramUsername');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showError('Could not open Telegram.');
    }
  }

  Future<void> _launchDiscord() async {
    final uri = Uri.parse(_discordInvite);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showError('Could not open Discord.');
    }
  }

  Future<void> _launchPrivacyPolicyWeb() async {
    final uri = Uri.parse(_privacyPolicyUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showError('Could not open browser.');
    }
  }

  void _showError(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _submitBugReport() {
    final subject = _bugSubjectController.text.trim();
    final body = _bugBodyController.text.trim();
    if (subject.isEmpty || body.isEmpty) {
      _showError('Please fill in both fields before sending.');
      return;
    }
    _launchEmail(subject: '[Bug] $subject', body: body);
  }

  void _submitContactForm() {
    final name = _contactNameController.text.trim();
    final message = _contactMessageController.text.trim();
    if (name.isEmpty || message.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }
    _launchEmail(subject: 'Support Request from $name', body: message);
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _scaffoldBg =>
      _isDark ? AppColors.darkBackground : AppColors.background;
  Color get _surfaceColor =>
      _isDark ? AppColors.darkSurface : AppColors.surface;
  Color get _surfaceLightColor =>
      _isDark ? AppColors.darkBackgroundLight : AppColors.surfaceLight;
  Color get _borderColor => _isDark ? AppColors.darkBorder : AppColors.border;
  Color get _textPrimary =>
      _isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get _textSecondary =>
      _isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get _iconSubtle =>
      _isDark ? AppColors.darkTextLight : AppColors.textLight;

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
                  SizedBox(height: 8.h),
                  _sectionTitle('Contact Us'),
                  SizedBox(height: 12.h),
                  _contactChannels(),
                  SizedBox(height: 32.h),
                  _sectionTitle('How-to Guides'),
                  SizedBox(height: 12.h),
                  _guidesSection(),
                  SizedBox(height: 32.h),
                  _sectionTitle('FAQ'),
                  SizedBox(height: 12.h),
                  _faqSection(),
                  SizedBox(height: 32.h),
                  _sectionTitle('Report a Bug'),
                  SizedBox(height: 12.h),
                  _bugReportForm(),
                  SizedBox(height: 32.h),
                  _sectionTitle('Send a Message'),
                  SizedBox(height: 12.h),
                  _contactForm(),
                  SizedBox(height: 32.h),
                  _sectionTitle('Legal'),
                  SizedBox(height: 12.h),
                  _legalSection(),
                  SizedBox(height: 48.h),
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
      expandedHeight: 140.h,
      pinned: true,
      backgroundColor: _scaffoldBg,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      leadingWidth: 56.w,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h),
        title: Text(
          'Help & Support',
          style: AppTextStyles.headlineMedium.copyWith(color: _textPrimary),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isDark
                  ? [
                      AppColors.primaryDark.withValues(alpha:  0.25),
                      AppColors.darkBackground,
                    ]
                  : [
                      AppColors.primaryLighter.withValues(alpha:0.5),
                      AppColors.background,
                    ],
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 24.w, top: 60.h),
              child: Icon(
                Icons.support_agent_rounded,
                size: 56.sp,
                color: AppColors.primary.withValues(alpha:0.15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(color: _textPrimary),
        ),
      ],
    );
  }

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
      color: color.withValues(alpha:_isDark ? 0.15 : 0.1),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22.sp),
              SizedBox(width: 10.w),
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

  Widget _guidesSection() => Column(children: _guides.map(_guideCard).toList());

  Widget _guideCard(_GuideItem guide) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: _surfaceLightColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _borderColor.withValues(alpha:0.6)),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: _isDark
                ? AppColors.primaryDark.withValues(alpha:0.3)
                : AppColors.primaryLighter,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(guide.icon, color: AppColors.primary, size: 20.sp),
        ),
        title: Text(
          guide.title,
          style: AppTextStyles.titleMedium.copyWith(color: _textPrimary),
        ),
        iconColor: AppColors.primary,
        collapsedIconColor: _iconSubtle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              top: 4.h,
            ),
            child: Column(
              children: guide.steps
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 11.r,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              '${e.key + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              e.value,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: _textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqSection() {
    return Column(
      children: _faqs.asMap().entries.map((e) {
        final i = e.key;
        final faq = e.value;
        final expanded = _expandedFaqIndex == i;
        final expandedBg = _isDark
            ? AppColors.primaryDark.withValues(alpha:0.2)
            : AppColors.primaryLighter;
        final expandedBorder = _isDark
            ? AppColors.primaryLight.withValues(alpha:0.35)
            : AppColors.primaryLight;
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: expanded ? expandedBg : _surfaceLightColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: expanded ? expandedBorder : _borderColor),
          ),
          child: InkWell(
            onTap: () =>
                setState(() => _expandedFaqIndex = expanded ? null : i),
            borderRadius: BorderRadius.circular(14.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          faq.question,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: expanded ? AppColors.primary : _textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                    ],
                  ),
                  if (expanded) ...[
                    SizedBox(height: 10.h),
                    Text(
                      faq.answer,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _bugReportForm() {
    final bgColor = _isDark
        ? AppColors.error.withValues(alpha:0.1)
        : AppColors.errorLight;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.error.withValues(alpha:0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bug_report_rounded,
                color: AppColors.error,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Something not working?',
                style: AppTextStyles.titleMedium.copyWith(color: _textPrimary),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _inputField(
            controller: _bugSubjectController,
            label: 'Issue title',
            hint: 'e.g. Notification not showing',
          ),
          SizedBox(height: 12.h),
          _inputField(
            controller: _bugBodyController,
            label: 'Describe the bug',
            hint: 'Steps to reproduce...',
            maxLines: 4,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submitBugReport,
              icon: Icon(Icons.send_rounded, size: 18.sp),
              label: const Text('Send Bug Report'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactForm() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: _surfaceLightColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          _inputField(
            controller: _contactNameController,
            label: 'Your name',
            hint: 'Enter your name',
          ),
          SizedBox(height: 12.h),
          _inputField(
            controller: _contactMessageController,
            label: 'Message',
            hint: 'What can we help you with?',
            maxLines: 4,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submitContactForm,
              icon: Icon(Icons.email_rounded, size: 18.sp),
              label: const Text('Send Message'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legalSection() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceLightColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        children: [
          _legalTile(
            icon: Icons.shield_rounded,
            title: 'Privacy Policy',
            subtitle: 'How we handle your data',
            onTap: () => context.pushNamed(Routes.privacyPolicyScreen),
          ),
          Divider(height: 1, color: _borderColor),
          _legalTile(
            icon: Icons.open_in_new_rounded,
            title: 'Privacy Policy (Web)',
            subtitle: 'View on browser',
            onTap: _launchPrivacyPolicyWeb,
            iconColor: AppColors.primaryLight,
          ),
        ],
      ),
    );
  }

  Widget _legalTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 14.w),
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
              color: _iconSubtle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.bodyMedium.copyWith(color: _textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: _textSecondary),
        hintText: hint,
        hintStyle: AppTextStyles.bodySmall.copyWith(color: _iconSubtle),
        filled: true,
        fillColor: _surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}

class _GuideItem {
  final IconData icon;
  final String title;
  final List<String> steps;
  const _GuideItem({
    required this.icon,
    required this.title,
    required this.steps,
  });
}
