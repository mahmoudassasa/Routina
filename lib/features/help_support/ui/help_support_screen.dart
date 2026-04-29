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

  static const String _supportEmail = 'dev.egy01@gmail.com';
  static const String _whatsappNumber = '+201152461600';
  static const String _telegramUsername = 'mahmoud_assasa';
  static const String _discordInvite = 'https://discord.com/channels/@3ma97';
  static const String _privacyPolicyUrl =
      'https://mellow-lokum-05a071.netlify.app/';

  final List<_FaqItem> _faqs = const [
      _FaqItem(
    question: 'How does the streak system work?',
    answer:
        'Your streak increases each day you complete all scheduled habits. '
        'Missing a scheduled day resets your streak to zero. '
        'Rest days (days not in your habit frequency) do not break your streak.',
  ),
  _FaqItem(
    question: 'What does the AI Analysis do?',
    answer:
        'The AI Analysis reviews your habit data — including streaks, progress, '
        'and completion patterns — and generates a personalized summary with insights '
        'and recommendations to help you improve.',
  ),
_FaqItem(
    question: 'How do I set a reminder for a habit?',
    answer:
        'When creating a new habit, tap the notification bell icon to set a daily reminder. '
        'You can also update reminders by editing an existing habit.',
  ),
  _FaqItem(
    question: 'Can I change the days a habit repeats?',
    answer:
        'Yes. When creating or editing a habit, select the days of the week '
        'you want the habit to be active. Unselected days are treated as rest days.',
  ),
  _FaqItem(
    question: 'Why was my progress reset?',
    answer:
        'Progress resets if you missed completing a habit on a scheduled day. '
        'This is by design to keep your tracking accurate. '
        'Routina checks for missed days automatically when you open the app.',
  ),
  _FaqItem(
    question: 'Is my data private?',
    answer:
        'Yes. Your data is stored securely and is only accessible to your account. '
        'Screenshots are blocked within the app to protect your privacy.',
  ),
  _FaqItem(
    question: 'How do I delete a habit?',
    answer:
        'Long press on a habit card to reveal the delete option. '
        'Deleted habits are permanently removed along with their progress data.',
  ),
  _FaqItem(
    question: 'Does Routina work offline?',
    answer:
        'Core habit tracking requires an internet connection to sync with the server. '
        'Offline support is planned for a future update.',
  ),
  ];

  final List<_GuideItem> _guides = const [
     _GuideItem(
    icon: Icons.rocket_launch_rounded,
    title: 'Getting Started',
    steps: [
      'Tap the + button in the bottom navigation bar',
      'Enter your habit name and choose an icon and color',
      'Select which days of the week to track it',
      'Optionally set a daily reminder time',
      'Tap Save — your habit is live!',
    ],
  ),
    _GuideItem(
      icon: Icons.notifications_active_rounded,
      title: 'Setting Up Reminders (General)',
      steps: [
        'Tap on to Profile screen to open it',
        'Tap the bell icon or to set the reminder',
        'Pick your preferred time',
        'Make sure Routina has notification permission',
        'You\'ll get a daily nudge at that time',
      ],
    ),
  
  _GuideItem(
    icon: Icons.notifications_active_rounded,
    title: 'Setting Up Reminders',
    steps: [
      'Tap the + button to open the Add Habit sheet',
      'Fill in the habit name and schedule',
      'Tap the bell icon to enable a reminder',
      'Pick your preferred hour and minute',
      'Save the habit — you\'ll get a daily notification at that time',
    ],
  ),
  _GuideItem(
    icon: Icons.edit_rounded,
    title: 'Editing a Habit',
    steps: [
      'On the Home screen, tap on any habit card',
      'Update the name, icon, color, or schedule',
      'To change the reminder, tap the bell icon',
      'The old reminder will be replaced automatically',
      'Tap Save to apply your changes',
    ],
  ),
  _GuideItem(
    icon: Icons.auto_awesome_rounded,
    title: 'Using AI Analysis',
    steps: [
      'Navigate to the Analyze tab',
      'Tap "Overall Analysis" to start',
      'The AI will review your streaks and progress',
      'Read your personalized insights and recommendations',
      'OR Long press the + button for a quick summary anywhere',
    ],
  ),
  _GuideItem(
    icon: Icons.delete_outline_rounded,
    title: 'Deleting a Habit',
    steps: [
      'On the Home screen, Swipe to the left on a habit card',
      'A delete option will appear',
      'Confirm to permanently remove the habit',
      'All progress and streak data will be deleted',
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
                  verticalSpace(8),
                  _sectionTitle('Contact Us'),
                  verticalSpace(12),

                  _contactChannels(),
                          verticalSpace(12),
                  _sectionTitle('How-to Guides'),
                  verticalSpace(12),

                  _guidesSection(),
                          verticalSpace(12),
                  _sectionTitle('FAQ'),
                  verticalSpace(12),

                  _faqSection(),
                          verticalSpace(12),
                  _sectionTitle('Report a Bug'),
                  verticalSpace(12),

                  _bugReportForm(),
                          verticalSpace(12),
                  _sectionTitle('Send a Message'),
                  verticalSpace(12),

                  _contactForm(),
                          verticalSpace(12),
                  _sectionTitle('Legal'),
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
