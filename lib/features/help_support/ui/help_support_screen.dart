import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

part 'widgets/help_support_app_bar.dart';
part 'widgets/help_support_section_title.dart';
part 'widgets/help_support_contact_channels.dart';
part 'widgets/help_support_guide_card.dart';
part 'widgets/help_support_faq_section.dart';
part 'widgets/help_support_forms.dart';

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

  void _updateFaqIndex(int? index) {
    setState(() => _expandedFaqIndex = index);
  }

  static const String _supportEmail = 'support@nilient.com';
  static const String _whatsappNumber = '+201152461600';
  static const String _telegramUsername = 'mahmoud_assasa';
  static const String _discordInvite = 'https://discord.com/channels/@3ma97';
  static const String _privacyPolicyUrl =
      'https://nilient.com/pages/routina/privacy-policy';

  List<_FaqItem> get _faqs => [
    _FaqItem(
      question: context.l10n.faqStreakQuestion,
      answer: context.l10n.faqStreakAnswer,
    ),
    _FaqItem(
      question: context.l10n.faqAiQuestion,
      answer: context.l10n.faqAiAnswer,
    ),
    _FaqItem(
      question: context.l10n.faqReminderQuestion,
      answer: context.l10n.faqReminderAnswer,
    ),
    _FaqItem(
      question: context.l10n.faqChangeDaysQuestion,
      answer: context.l10n.faqChangeDaysAnswer,
    ),
    _FaqItem(
      question: context.l10n.faqProgressResetQuestion,
      answer: context.l10n.faqProgressResetAnswer,
    ),
    _FaqItem(
      question: context.l10n.faqPrivacyQuestion,
      answer: context.l10n.faqPrivacyAnswer,
    ),
    _FaqItem(
      question: context.l10n.faqDeleteQuestion,
      answer: context.l10n.faqDeleteAnswer,
    ),
    _FaqItem(
      question: context.l10n.faqOfflineQuestion,
      answer: context.l10n.faqOfflineAnswer,
    ),
  ];

  List<_GuideItem> get _guides => [
    _GuideItem(
      icon: Icons.rocket_launch_rounded,
      title: context.l10n.guideGettingStartedTitle,
      steps: [
        context.l10n.guideGettingStartedStep1,
        context.l10n.guideGettingStartedStep2,
        context.l10n.guideGettingStartedStep3,
        context.l10n.guideGettingStartedStep4,
        context.l10n.guideGettingStartedStep5,
      ],
    ),
    _GuideItem(
      icon: Icons.notifications_active_rounded,
      title: context.l10n.guideRemindersGeneralTitle,
      steps: [
        context.l10n.guideRemindersGeneralStep1,
        context.l10n.guideRemindersGeneralStep2,
        context.l10n.guideRemindersGeneralStep3,
        context.l10n.guideRemindersGeneralStep4,
        context.l10n.guideRemindersGeneralStep5,
      ],
    ),
    _GuideItem(
      icon: Icons.notifications_active_rounded,
      title: context.l10n.guideRemindersTitle,
      steps: [
        context.l10n.guideRemindersStep1,
        context.l10n.guideRemindersStep2,
        context.l10n.guideRemindersStep3,
        context.l10n.guideRemindersStep4,
        context.l10n.guideRemindersStep5,
      ],
    ),
    _GuideItem(
      icon: Icons.edit_rounded,
      title: context.l10n.guideEditingTitle,
      steps: [
        context.l10n.guideEditingStep1,
        context.l10n.guideEditingStep2,
        context.l10n.guideEditingStep3,
        context.l10n.guideEditingStep4,
        context.l10n.guideEditingStep5,
      ],
    ),
    _GuideItem(
      icon: Icons.auto_awesome_rounded,
      title: context.l10n.guideAiTitle,
      steps: [
        context.l10n.guideAiStep1,
        context.l10n.guideAiStep2,
        context.l10n.guideAiStep3,
        context.l10n.guideAiStep4,
        context.l10n.guideAiStep5,
      ],
    ),
    _GuideItem(
      icon: Icons.delete_outline_rounded,
      title: context.l10n.guideDeletingTitle,
      steps: [
        context.l10n.guideDeletingStep1,
        context.l10n.guideDeletingStep2,
        context.l10n.guideDeletingStep3,
        context.l10n.guideDeletingStep4,
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

    if (!await launchUrl(uri)) {
      if (!mounted) return;
      _showError(context.l10n.couldNotOpenMail);
    }
  }

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/${_whatsappNumber.replaceAll('+', '')}?text=Hi%2C%20I%20need%20help%20with%20Routina',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      _showError(context.l10n.whatsAppNotInstalled);
    }
  }

  Future<void> _launchTelegram() async {
    final uri = Uri.parse('https://t.me/$_telegramUsername');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      _showError(context.l10n.couldNotOpenTelegram);
    }
  }

  Future<void> _launchDiscord() async {
    final uri = Uri.parse(_discordInvite);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      _showError(context.l10n.couldNotOpenDiscord);
    }
  }

  Future<void> _launchPrivacyPolicyWeb() async {
    final uri = Uri.parse(_privacyPolicyUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      _showError(context.l10n.couldNotOpenBrowser);
    }
  }

  void _showError(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // Reports a real user bug submission to Crashlytics as a NON-FATAL
  // event (it doesn't crash the app, just logs it). Every real bug
  // report a user sends now also shows up in the Firebase Console
  // Crashlytics dashboard with full context — no separate "test crash"
  // button needed, and nothing to remember to remove before release.
  void _logBugReportToCrashlytics(String subject, String body) {
    FirebaseCrashlytics.instance.log('User bug report: $subject');
    FirebaseCrashlytics.instance.recordError(
      Exception('User-reported bug: $subject'),
      StackTrace.current,
      reason: body,
      fatal: false,
    );
  }

  void _submitBugReport() {
    final subject = _bugSubjectController.text.trim();
    final body = _bugBodyController.text.trim();
    if (subject.isEmpty || body.isEmpty) {
      _showError(context.l10n.fillBothFields);
      return;
    }
    _logBugReportToCrashlytics(subject, body);
    _launchEmail(subject: '[Bug] $subject', body: body);
  }

  void _submitContactForm() {
    final name = _contactNameController.text.trim();
    final message = _contactMessageController.text.trim();
    if (name.isEmpty || message.isEmpty) {
      _showError(context.l10n.fillAllFields);
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
                  verticalSpace(8),
                  _sectionTitle(context.l10n.contactUs),
                  verticalSpace(12),

                  _contactChannels(),
                  verticalSpace(12),
                  _sectionTitle(context.l10n.howToGuides),
                  verticalSpace(12),

                  _guidesSection(),
                  verticalSpace(12),
                  _sectionTitle(context.l10n.faq),
                  verticalSpace(12),

                  _faqSection(),
                  verticalSpace(12),
                  _sectionTitle(context.l10n.reportABug),
                  verticalSpace(12),

                  _bugReportForm(),
                  verticalSpace(12),
                  _sectionTitle(context.l10n.sendAMessage),
                  verticalSpace(12),

                  _contactForm(),
                  verticalSpace(12),
                  _sectionTitle(context.l10n.legal),
                  verticalSpace(12),

                  _legalSection(),
                  verticalSpace(48),
                ]),
              ),
            ),
          ],
        ),
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
