import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @aiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysis;

  /// No description provided for @aiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get aiInsights;

  /// No description provided for @poweredByGemini.
  ///
  /// In en, this message translates to:
  /// **'Powered by Gemini'**
  String get poweredByGemini;

  /// No description provided for @quickAiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Quick AI Analysis'**
  String get quickAiAnalysis;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis Failed'**
  String get analysisFailed;

  /// No description provided for @viewFullAnalysis.
  ///
  /// In en, this message translates to:
  /// **'View Full Analysis'**
  String get viewFullAnalysis;

  /// No description provided for @analyzeScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get personalized insights and recommendations based on your habit patterns and progress.'**
  String get analyzeScreenSubtitle;

  /// No description provided for @overallAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Overall Analysis'**
  String get overallAnalysis;

  /// No description provided for @overallAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Get a full AI breakdown of your routine'**
  String get overallAnalysisDesc;

  /// No description provided for @smartSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Smart Suggestions'**
  String get smartSuggestions;

  /// No description provided for @smartSuggestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Personalized tips to improve your habits'**
  String get smartSuggestionsDesc;

  /// No description provided for @goalOptimization.
  ///
  /// In en, this message translates to:
  /// **'Goal Optimization'**
  String get goalOptimization;

  /// No description provided for @goalOptimizationDesc.
  ///
  /// In en, this message translates to:
  /// **'AI-powered recommendations for better results'**
  String get goalOptimizationDesc;

  /// No description provided for @addHabitsFirst.
  ///
  /// In en, this message translates to:
  /// **'Add some habits first!'**
  String get addHabitsFirst;

  /// No description provided for @pullDownToRetry.
  ///
  /// In en, this message translates to:
  /// **'Pull down to retry'**
  String get pullDownToRetry;

  /// No description provided for @failedToLoadSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load suggestions'**
  String get failedToLoadSuggestions;

  /// No description provided for @failedToLoadOptimization.
  ///
  /// In en, this message translates to:
  /// **'Failed to load optimization'**
  String get failedToLoadOptimization;

  /// No description provided for @quotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'Daily AI limit reached. Try again tomorrow.'**
  String get quotaExceeded;

  /// No description provided for @aiBusy.
  ///
  /// In en, this message translates to:
  /// **'AI is busy right now. Please try again in a moment.'**
  String get aiBusy;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get networkError;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @generatingInsights.
  ///
  /// In en, this message translates to:
  /// **'Generating insights...'**
  String get generatingInsights;

  /// No description provided for @failedToGenerate.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate'**
  String get failedToGenerate;

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM FEATURE'**
  String get premiumFeature;

  /// No description provided for @whatYoullGet.
  ///
  /// In en, this message translates to:
  /// **'What you\'ll get:'**
  String get whatYoullGet;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @smartAiSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Smart AI Suggestions'**
  String get smartAiSuggestions;

  /// No description provided for @smartAiSuggestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Our AI will analyze your patterns to give you tailored advice.'**
  String get smartAiSuggestionsDesc;

  /// No description provided for @habitStacking.
  ///
  /// In en, this message translates to:
  /// **'Habit stacking strategies'**
  String get habitStacking;

  /// No description provided for @bestPerformingHours.
  ///
  /// In en, this message translates to:
  /// **'Best performing hours'**
  String get bestPerformingHours;

  /// No description provided for @routineOptimization.
  ///
  /// In en, this message translates to:
  /// **'Routine optimization'**
  String get routineOptimization;

  /// No description provided for @goalOptimizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal Optimization'**
  String get goalOptimizationTitle;

  /// No description provided for @goalOptimizationDesc2.
  ///
  /// In en, this message translates to:
  /// **'Let Gemini AI help you set smarter, more achievable goals.'**
  String get goalOptimizationDesc2;

  /// No description provided for @successForecasting.
  ///
  /// In en, this message translates to:
  /// **'Success forecasting'**
  String get successForecasting;

  /// No description provided for @dynamicDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Dynamic difficulty'**
  String get dynamicDifficulty;

  /// No description provided for @milestoneBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Milestone breakdown'**
  String get milestoneBreakdown;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// No description provided for @updateMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of Routina is available. Please update to continue.'**
  String get updateMessage;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring...'**
  String get restoring;

  /// No description provided for @unlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get unlockPremium;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get bestValue;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get perMonth;

  /// No description provided for @perYear.
  ///
  /// In en, this message translates to:
  /// **'/ year'**
  String get perYear;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @cancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime · Billed via Google Play'**
  String get cancelAnytime;

  /// No description provided for @productsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Products unavailable'**
  String get productsUnavailable;

  /// No description provided for @routinaPremium.
  ///
  /// In en, this message translates to:
  /// **'Routina+'**
  String get routinaPremium;

  /// No description provided for @unlockPotential.
  ///
  /// In en, this message translates to:
  /// **'Unlock your full potential'**
  String get unlockPotential;

  /// No description provided for @featureAiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Full AI Habit Analysis'**
  String get featureAiAnalysis;

  /// No description provided for @featureAiAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Powered by Gemini'**
  String get featureAiAnalysisDesc;

  /// No description provided for @featureUnlimitedHabits.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Habits'**
  String get featureUnlimitedHabits;

  /// No description provided for @featureUnlimitedHabitsDesc.
  ///
  /// In en, this message translates to:
  /// **'No restrictions'**
  String get featureUnlimitedHabitsDesc;

  /// No description provided for @featurePrioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority Support'**
  String get featurePrioritySupport;

  /// No description provided for @featurePrioritySupportDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ve got your back'**
  String get featurePrioritySupportDesc;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @habits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get habits;

  /// No description provided for @analyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get analyze;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @confirmEmail.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your Email'**
  String get confirmEmail;

  /// No description provided for @confirmEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification link to your email.\nPlease check your inbox.'**
  String get confirmEmailDesc;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(Object seconds);

  /// No description provided for @iVerifiedEmail.
  ///
  /// In en, this message translates to:
  /// **'I Verified My Email ✓'**
  String get iVerifiedEmail;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent again ✅'**
  String get verificationEmailSent;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email is not verified yet ❗'**
  String get emailNotVerified;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @emailVerifiedRedirect.
  ///
  /// In en, this message translates to:
  /// **'Email verified! Redirecting to login...'**
  String get emailVerifiedRedirect;

  /// No description provided for @sendEmailError.
  ///
  /// In en, this message translates to:
  /// **'Error sending verification email'**
  String get sendEmailError;

  /// No description provided for @checkVerificationError.
  ///
  /// In en, this message translates to:
  /// **'Error checking verification status'**
  String get checkVerificationError;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password'**
  String get forgotPasswordDesc;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent!'**
  String get emailSent;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @weSentResetLink.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to\n'**
  String get weSentResetLink;

  /// No description provided for @didntReceiveEmail.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email? Check your spam folder or try again in a few minutes.'**
  String get didntReceiveEmail;

  /// No description provided for @strategicGoals.
  ///
  /// In en, this message translates to:
  /// **'Strategic Goals'**
  String get strategicGoals;

  /// No description provided for @trackYourGrowth.
  ///
  /// In en, this message translates to:
  /// **'Track Your Growth'**
  String get trackYourGrowth;

  /// No description provided for @trackYourGrowthDesc.
  ///
  /// In en, this message translates to:
  /// **'Visualize your progress and unlock deep insights into your daily habits.'**
  String get trackYourGrowthDesc;

  /// No description provided for @progressCharts.
  ///
  /// In en, this message translates to:
  /// **'Progress Charts'**
  String get progressCharts;

  /// No description provided for @progressChartsDesc.
  ///
  /// In en, this message translates to:
  /// **'Interactive weekly and monthly visualizations'**
  String get progressChartsDesc;

  /// No description provided for @strategicGoalsCard.
  ///
  /// In en, this message translates to:
  /// **'Strategic Goals'**
  String get strategicGoalsCard;

  /// No description provided for @strategicGoalsCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Set milestones and track achievements'**
  String get strategicGoalsCardDesc;

  /// No description provided for @premiumAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Premium Analytics'**
  String get premiumAnalytics;

  /// No description provided for @premiumAnalyticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Advanced data for power users'**
  String get premiumAnalyticsDesc;

  /// No description provided for @noHabitsYet.
  ///
  /// In en, this message translates to:
  /// **'No habits yet'**
  String get noHabitsYet;

  /// No description provided for @noHabitsYetDesc.
  ///
  /// In en, this message translates to:
  /// **'Add habits first to set strategic goals'**
  String get noHabitsYetDesc;

  /// No description provided for @nextMilestone.
  ///
  /// In en, this message translates to:
  /// **'Next milestone: {days} days'**
  String nextMilestone(Object days);

  /// No description provided for @eliteInsights.
  ///
  /// In en, this message translates to:
  /// **'Elite Insights'**
  String get eliteInsights;

  /// No description provided for @avgCompletion.
  ///
  /// In en, this message translates to:
  /// **'Avg Completion'**
  String get avgCompletion;

  /// No description provided for @totalHabits.
  ///
  /// In en, this message translates to:
  /// **'Total Habits'**
  String get totalHabits;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get bestStreak;

  /// No description provided for @needsFocus.
  ///
  /// In en, this message translates to:
  /// **'Needs Focus'**
  String get needsFocus;

  /// No description provided for @bestPerforming.
  ///
  /// In en, this message translates to:
  /// **'🏆 Best Performing'**
  String get bestPerforming;

  /// No description provided for @completionBreakdown.
  ///
  /// In en, this message translates to:
  /// **'📈 Completion Breakdown'**
  String get completionBreakdown;

  /// No description provided for @priorityFocus.
  ///
  /// In en, this message translates to:
  /// **'🎯 Priority Focus'**
  String get priorityFocus;

  /// No description provided for @allHabitsOnTrack.
  ///
  /// In en, this message translates to:
  /// **'🎉 All habits on track!'**
  String get allHabitsOnTrack;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'{streak} day streak • {percent}% complete'**
  String dayStreak(Object streak, Object percent);

  /// No description provided for @habitTracker.
  ///
  /// In en, this message translates to:
  /// **'Habit Tracker'**
  String get habitTracker;

  /// No description provided for @habitTrackerDesc.
  ///
  /// In en, this message translates to:
  /// **'Detailed view of your progress'**
  String get habitTrackerDesc;

  /// No description provided for @upgradeToPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremiumTitle;

  /// No description provided for @smartGoalTracking.
  ///
  /// In en, this message translates to:
  /// **'Smart Goal Tracking'**
  String get smartGoalTracking;

  /// No description provided for @smartGoalTrackingDesc.
  ///
  /// In en, this message translates to:
  /// **'Go beyond daily tasks and start building long-term streaks with AI guidance.'**
  String get smartGoalTrackingDesc;

  /// No description provided for @multiStageGoalMilestones.
  ///
  /// In en, this message translates to:
  /// **'Multi-stage goal milestones'**
  String get multiStageGoalMilestones;

  /// No description provided for @predictiveStreakCounting.
  ///
  /// In en, this message translates to:
  /// **'Predictive streak counting'**
  String get predictiveStreakCounting;

  /// No description provided for @customSuccessCriteria.
  ///
  /// In en, this message translates to:
  /// **'Custom success criteria'**
  String get customSuccessCriteria;

  /// No description provided for @eliteInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Elite Insights'**
  String get eliteInsightsTitle;

  /// No description provided for @eliteInsightsDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock the full power of your data with our most advanced tracking engine.'**
  String get eliteInsightsDesc;

  /// No description provided for @behavioralPatternRecognition.
  ///
  /// In en, this message translates to:
  /// **'Behavioral pattern recognition'**
  String get behavioralPatternRecognition;

  /// No description provided for @smartTimeOfDaySuggestions.
  ///
  /// In en, this message translates to:
  /// **'Smart time-of-day suggestions'**
  String get smartTimeOfDaySuggestions;

  /// No description provided for @priorityHabitFocus.
  ///
  /// In en, this message translates to:
  /// **'Priority habit focus'**
  String get priorityHabitFocus;

  /// No description provided for @streakBadge.
  ///
  /// In en, this message translates to:
  /// **'🔥 {streak} days'**
  String streakBadge(Object streak);

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyActivity;

  /// No description provided for @avgProgress.
  ///
  /// In en, this message translates to:
  /// **'Avg. Progress'**
  String get avgProgress;

  /// No description provided for @totalStreaks.
  ///
  /// In en, this message translates to:
  /// **'Total Streaks'**
  String get totalStreaks;

  /// No description provided for @individualPerformance.
  ///
  /// In en, this message translates to:
  /// **'Individual Performance'**
  String get individualPerformance;

  /// No description provided for @totalStreaksDays.
  ///
  /// In en, this message translates to:
  /// **'{days} Days'**
  String totalStreaksDays(Object days);

  /// No description provided for @insightGreat.
  ///
  /// In en, this message translates to:
  /// **'You\'re doing great! Your consistency is above average.'**
  String get insightGreat;

  /// No description provided for @insightKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going! Small steps lead to big changes.'**
  String get insightKeepGoing;

  /// No description provided for @habitAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Habit Analytics'**
  String get habitAnalytics;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @howToGuides.
  ///
  /// In en, this message translates to:
  /// **'How-to Guides'**
  String get howToGuides;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @reportABug.
  ///
  /// In en, this message translates to:
  /// **'Report a Bug'**
  String get reportABug;

  /// No description provided for @sendAMessage.
  ///
  /// In en, this message translates to:
  /// **'Send a Message'**
  String get sendAMessage;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @somethingNotWorking.
  ///
  /// In en, this message translates to:
  /// **'Something not working?'**
  String get somethingNotWorking;

  /// No description provided for @issueTitle.
  ///
  /// In en, this message translates to:
  /// **'Issue title'**
  String get issueTitle;

  /// No description provided for @issueTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Notification not showing'**
  String get issueTitleHint;

  /// No description provided for @describeTheBug.
  ///
  /// In en, this message translates to:
  /// **'Describe the bug'**
  String get describeTheBug;

  /// No description provided for @describeTheBugHint.
  ///
  /// In en, this message translates to:
  /// **'Steps to reproduce...'**
  String get describeTheBugHint;

  /// No description provided for @sendBugReport.
  ///
  /// In en, this message translates to:
  /// **'Send Bug Report'**
  String get sendBugReport;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @yourNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get yourNameHint;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'What can we help you with?'**
  String get messageHint;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get privacyPolicySubtitle;

  /// No description provided for @privacyPolicyWeb.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy (Web)'**
  String get privacyPolicyWeb;

  /// No description provided for @privacyPolicyWebSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View on browser'**
  String get privacyPolicyWebSubtitle;

  /// No description provided for @channelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get channelEmail;

  /// No description provided for @channelWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get channelWhatsApp;

  /// No description provided for @channelTelegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get channelTelegram;

  /// No description provided for @channelDiscord.
  ///
  /// In en, this message translates to:
  /// **'Discord'**
  String get channelDiscord;

  /// No description provided for @couldNotOpenMail.
  ///
  /// In en, this message translates to:
  /// **'Could not open mail app.'**
  String get couldNotOpenMail;

  /// No description provided for @whatsAppNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp is not installed.'**
  String get whatsAppNotInstalled;

  /// No description provided for @couldNotOpenTelegram.
  ///
  /// In en, this message translates to:
  /// **'Could not open Telegram.'**
  String get couldNotOpenTelegram;

  /// No description provided for @couldNotOpenDiscord.
  ///
  /// In en, this message translates to:
  /// **'Could not open Discord.'**
  String get couldNotOpenDiscord;

  /// No description provided for @couldNotOpenBrowser.
  ///
  /// In en, this message translates to:
  /// **'Could not open browser.'**
  String get couldNotOpenBrowser;

  /// No description provided for @fillBothFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in both fields before sending.'**
  String get fillBothFields;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get fillAllFields;

  /// No description provided for @faqStreakQuestion.
  ///
  /// In en, this message translates to:
  /// **'How does the streak system work?'**
  String get faqStreakQuestion;

  /// No description provided for @faqStreakAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your streak increases each day you complete all scheduled habits. Missing a scheduled day resets your streak to zero. Rest days do not break your streak.'**
  String get faqStreakAnswer;

  /// No description provided for @faqAiQuestion.
  ///
  /// In en, this message translates to:
  /// **'What does the AI Analysis do?'**
  String get faqAiQuestion;

  /// No description provided for @faqAiAnswer.
  ///
  /// In en, this message translates to:
  /// **'The AI Analysis reviews your habit data — streaks, progress, and completion patterns — and generates a personalized summary with insights and recommendations.'**
  String get faqAiAnswer;

  /// No description provided for @faqReminderQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I set a reminder for a habit?'**
  String get faqReminderQuestion;

  /// No description provided for @faqReminderAnswer.
  ///
  /// In en, this message translates to:
  /// **'When creating a new habit, tap the notification bell icon to set a daily reminder. You can also update reminders by editing an existing habit.'**
  String get faqReminderAnswer;

  /// No description provided for @faqChangeDaysQuestion.
  ///
  /// In en, this message translates to:
  /// **'Can I change the days a habit repeats?'**
  String get faqChangeDaysQuestion;

  /// No description provided for @faqChangeDaysAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes. When creating or editing a habit, select the days of the week you want the habit to be active. Unselected days are treated as rest days.'**
  String get faqChangeDaysAnswer;

  /// No description provided for @faqProgressResetQuestion.
  ///
  /// In en, this message translates to:
  /// **'Why was my progress reset?'**
  String get faqProgressResetQuestion;

  /// No description provided for @faqProgressResetAnswer.
  ///
  /// In en, this message translates to:
  /// **'Progress resets if you missed completing a habit on a scheduled day. Routina checks for missed days automatically when you open the app.'**
  String get faqProgressResetAnswer;

  /// No description provided for @faqPrivacyQuestion.
  ///
  /// In en, this message translates to:
  /// **'Is my data private?'**
  String get faqPrivacyQuestion;

  /// No description provided for @faqPrivacyAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes. Your data is stored securely and is only accessible to your account. Screenshots are blocked within the app to protect your privacy.'**
  String get faqPrivacyAnswer;

  /// No description provided for @faqDeleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I delete a habit?'**
  String get faqDeleteQuestion;

  /// No description provided for @faqDeleteAnswer.
  ///
  /// In en, this message translates to:
  /// **'Long press on a habit card to reveal the delete option. Deleted habits are permanently removed along with their progress data.'**
  String get faqDeleteAnswer;

  /// No description provided for @faqOfflineQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does Routina work offline?'**
  String get faqOfflineQuestion;

  /// No description provided for @faqOfflineAnswer.
  ///
  /// In en, this message translates to:
  /// **'Core habit tracking requires an internet connection to sync with the server. Offline support is planned for a future update.'**
  String get faqOfflineAnswer;

  /// No description provided for @guideGettingStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get guideGettingStartedTitle;

  /// No description provided for @guideGettingStartedStep1.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button in the bottom navigation bar'**
  String get guideGettingStartedStep1;

  /// No description provided for @guideGettingStartedStep2.
  ///
  /// In en, this message translates to:
  /// **'Enter your habit name and choose an icon and color'**
  String get guideGettingStartedStep2;

  /// No description provided for @guideGettingStartedStep3.
  ///
  /// In en, this message translates to:
  /// **'Select which days of the week to track it'**
  String get guideGettingStartedStep3;

  /// No description provided for @guideGettingStartedStep4.
  ///
  /// In en, this message translates to:
  /// **'Optionally set a daily reminder time'**
  String get guideGettingStartedStep4;

  /// No description provided for @guideGettingStartedStep5.
  ///
  /// In en, this message translates to:
  /// **'Tap Save — your habit is live!'**
  String get guideGettingStartedStep5;

  /// No description provided for @guideRemindersGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'Setting Up Reminders (General)'**
  String get guideRemindersGeneralTitle;

  /// No description provided for @guideRemindersGeneralStep1.
  ///
  /// In en, this message translates to:
  /// **'Open the Profile screen'**
  String get guideRemindersGeneralStep1;

  /// No description provided for @guideRemindersGeneralStep2.
  ///
  /// In en, this message translates to:
  /// **'Tap the bell icon to set a reminder'**
  String get guideRemindersGeneralStep2;

  /// No description provided for @guideRemindersGeneralStep3.
  ///
  /// In en, this message translates to:
  /// **'Pick your preferred time'**
  String get guideRemindersGeneralStep3;

  /// No description provided for @guideRemindersGeneralStep4.
  ///
  /// In en, this message translates to:
  /// **'Make sure Routina has notification permission'**
  String get guideRemindersGeneralStep4;

  /// No description provided for @guideRemindersGeneralStep5.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get a daily nudge at that time'**
  String get guideRemindersGeneralStep5;

  /// No description provided for @guideRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Setting Up Reminders'**
  String get guideRemindersTitle;

  /// No description provided for @guideRemindersStep1.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to open the Add Habit sheet'**
  String get guideRemindersStep1;

  /// No description provided for @guideRemindersStep2.
  ///
  /// In en, this message translates to:
  /// **'Fill in the habit name and schedule'**
  String get guideRemindersStep2;

  /// No description provided for @guideRemindersStep3.
  ///
  /// In en, this message translates to:
  /// **'Tap the bell icon to enable a reminder'**
  String get guideRemindersStep3;

  /// No description provided for @guideRemindersStep4.
  ///
  /// In en, this message translates to:
  /// **'Pick your preferred hour and minute'**
  String get guideRemindersStep4;

  /// No description provided for @guideRemindersStep5.
  ///
  /// In en, this message translates to:
  /// **'Save the habit — you\'ll get a daily notification at that time'**
  String get guideRemindersStep5;

  /// No description provided for @guideEditingTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing a Habit'**
  String get guideEditingTitle;

  /// No description provided for @guideEditingStep1.
  ///
  /// In en, this message translates to:
  /// **'On the Home screen, tap on any habit card'**
  String get guideEditingStep1;

  /// No description provided for @guideEditingStep2.
  ///
  /// In en, this message translates to:
  /// **'Update the name, icon, color, or schedule'**
  String get guideEditingStep2;

  /// No description provided for @guideEditingStep3.
  ///
  /// In en, this message translates to:
  /// **'To change the reminder, tap the bell icon'**
  String get guideEditingStep3;

  /// No description provided for @guideEditingStep4.
  ///
  /// In en, this message translates to:
  /// **'The old reminder will be replaced automatically'**
  String get guideEditingStep4;

  /// No description provided for @guideEditingStep5.
  ///
  /// In en, this message translates to:
  /// **'Tap Save to apply your changes'**
  String get guideEditingStep5;

  /// No description provided for @guideAiTitle.
  ///
  /// In en, this message translates to:
  /// **'Using AI Analysis'**
  String get guideAiTitle;

  /// No description provided for @guideAiStep1.
  ///
  /// In en, this message translates to:
  /// **'Navigate to the Analyze tab'**
  String get guideAiStep1;

  /// No description provided for @guideAiStep2.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Overall Analysis\" to start'**
  String get guideAiStep2;

  /// No description provided for @guideAiStep3.
  ///
  /// In en, this message translates to:
  /// **'The AI will review your streaks and progress'**
  String get guideAiStep3;

  /// No description provided for @guideAiStep4.
  ///
  /// In en, this message translates to:
  /// **'Read your personalized insights and recommendations'**
  String get guideAiStep4;

  /// No description provided for @guideAiStep5.
  ///
  /// In en, this message translates to:
  /// **'Or long press the + button for a quick summary anywhere'**
  String get guideAiStep5;

  /// No description provided for @guideDeletingTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleting a Habit'**
  String get guideDeletingTitle;

  /// No description provided for @guideDeletingStep1.
  ///
  /// In en, this message translates to:
  /// **'On the Home screen, swipe left on a habit card'**
  String get guideDeletingStep1;

  /// No description provided for @guideDeletingStep2.
  ///
  /// In en, this message translates to:
  /// **'A delete option will appear'**
  String get guideDeletingStep2;

  /// No description provided for @guideDeletingStep3.
  ///
  /// In en, this message translates to:
  /// **'Confirm to permanently remove the habit'**
  String get guideDeletingStep3;

  /// No description provided for @guideDeletingStep4.
  ///
  /// In en, this message translates to:
  /// **'All progress and streak data will be deleted'**
  String get guideDeletingStep4;

  /// No description provided for @markAsDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as Done'**
  String get markAsDone;

  /// No description provided for @completedToday.
  ///
  /// In en, this message translates to:
  /// **'Completed Today'**
  String get completedToday;

  /// No description provided for @restDay.
  ///
  /// In en, this message translates to:
  /// **'Rest Day'**
  String get restDay;

  /// No description provided for @deleteHabit.
  ///
  /// In en, this message translates to:
  /// **'Delete Habit?'**
  String get deleteHabit;

  /// No description provided for @deleteHabitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"? This action cannot be undone.'**
  String deleteHabitConfirm(Object title);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @habitDeleted.
  ///
  /// In en, this message translates to:
  /// **'{title} deleted'**
  String habitDeleted(Object title);

  /// No description provided for @readyToBuildHabits.
  ///
  /// In en, this message translates to:
  /// **'Ready to build your habits?'**
  String get readyToBuildHabits;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning, {name}! 👋'**
  String goodMorning(Object name);

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon, {name}! ☀️'**
  String goodAfternoon(Object name);

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening, {name}! 🌙'**
  String goodEvening(Object name);

  /// No description provided for @weeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Weekly Goal'**
  String weeklyGoal(Object percent);

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login Error'**
  String get loginError;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue tracking your habits'**
  String get loginSubtitle;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @missingCredentials.
  ///
  /// In en, this message translates to:
  /// **'Missing credentials'**
  String get missingCredentials;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @pleaseVerifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email before logging in 🔒'**
  String get pleaseVerifyEmail;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed. Please try again.'**
  String get googleSignInFailed;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format 📧'**
  String get invalidEmail;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email ❗'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password 🔐'**
  String get wrongPassword;

  /// No description provided for @invalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password ⚠️'**
  String get invalidCredential;

  /// No description provided for @missingPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password 🔑'**
  String get missingPassword;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later ⏳'**
  String get tooManyRequests;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled 🚫'**
  String get userDisabled;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed, please try again.'**
  String get loginFailed;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected Error: {error}'**
  String unexpectedError(Object error);

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @noInternetDesc.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection\nand try again.'**
  String get noInternetDesc;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Routina'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Build better habits with our beautiful and intuitive tracker'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Track Your Progress'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor your daily habits and see your improvements over time'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Stay Motivated'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get AI-powered insights and personalized recommendations'**
  String get onboarding3Subtitle;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @yourPrivacyMatters.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters'**
  String get yourPrivacyMatters;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: April 2026'**
  String get lastUpdated;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Routina. All rights reserved.'**
  String get copyright;

  /// No description provided for @privacy1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get privacy1Title;

  /// No description provided for @privacy1Content.
  ///
  /// In en, this message translates to:
  /// **'Routina collects only the information necessary to provide our habit tracking service. This includes your email address for authentication, habit data you create within the app, and basic usage analytics to improve your experience.'**
  String get privacy1Content;

  /// No description provided for @privacy2Title.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Data'**
  String get privacy2Title;

  /// No description provided for @privacy2Content.
  ///
  /// In en, this message translates to:
  /// **'Your data is used solely to power the features of Routina, including habit tracking, progress analysis, and AI-powered insights. We do not sell, rent, or share your personal information with third parties for marketing purposes.'**
  String get privacy2Content;

  /// No description provided for @privacy3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Data Security'**
  String get privacy3Title;

  /// No description provided for @privacy3Content.
  ///
  /// In en, this message translates to:
  /// **'We use industry-standard security measures including Firebase Authentication and Supabase with Row Level Security (RLS) to protect your data. All data is encrypted in transit and at rest.'**
  String get privacy3Content;

  /// No description provided for @privacy4Title.
  ///
  /// In en, this message translates to:
  /// **'4. AI Features'**
  String get privacy4Title;

  /// No description provided for @privacy4Content.
  ///
  /// In en, this message translates to:
  /// **'The AI analysis feature in Routina uses Google Gemini to process your habit data. This processing is done securely and your data is not stored or used to train AI models. AI responses are generated in real-time and not retained by third parties.'**
  String get privacy4Content;

  /// No description provided for @privacy5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Your Rights'**
  String get privacy5Title;

  /// No description provided for @privacy5Content.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, correct, or delete your personal data at any time. You can delete your account and all associated data directly from the app settings. For any privacy-related requests, contact us at dev.egy01@gmail.com.'**
  String get privacy5Content;

  /// No description provided for @privacy6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Children\'s Privacy'**
  String get privacy6Title;

  /// No description provided for @privacy6Content.
  ///
  /// In en, this message translates to:
  /// **'Routina is not directed at children under the age of 13. We do not knowingly collect personal information from children. If you believe a child has provided us with personal information, please contact us immediately.'**
  String get privacy6Content;

  /// No description provided for @privacy7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Changes to This Policy'**
  String get privacy7Title;

  /// No description provided for @privacy7Content.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy from time to time. We will notify you of any significant changes through the app or via email. Continued use of Routina after changes constitutes acceptance of the updated policy.'**
  String get privacy7Content;

  /// No description provided for @privacy8Title.
  ///
  /// In en, this message translates to:
  /// **'8. Contact Us'**
  String get privacy8Title;

  /// No description provided for @privacy8Content.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy or our data practices, please contact us at dev.egy01@gmail.com. We aim to respond to all inquiries within 48 hours.'**
  String get privacy8Content;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @totalHabitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Habits'**
  String get totalHabitsLabel;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// No description provided for @bestStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get bestStreakLabel;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageReminders.
  ///
  /// In en, this message translates to:
  /// **'Manage your reminders'**
  String get manageReminders;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get darkModeEnabled;

  /// No description provided for @darkModeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get darkModeDisabled;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @downloadHabitData.
  ///
  /// In en, this message translates to:
  /// **'Download your habit data'**
  String get downloadHabitData;

  /// No description provided for @getHelpContact.
  ///
  /// In en, this message translates to:
  /// **'Get help and contact us'**
  String get getHelpContact;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @leavingSoSoon.
  ///
  /// In en, this message translates to:
  /// **'Leaving So Soon?'**
  String get leavingSoSoon;

  /// No description provided for @seeYouSoon.
  ///
  /// In en, this message translates to:
  /// **'See You Soon!'**
  String get seeYouSoon;

  /// No description provided for @logoutConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'We love having you here! Are you sure you want to sign out?'**
  String get logoutConfirmMsg;

  /// No description provided for @logoutProcessMsg.
  ///
  /// In en, this message translates to:
  /// **'We\'re making sure everything is saved for you. 💙'**
  String get logoutProcessMsg;

  /// No description provided for @stayWithUs.
  ///
  /// In en, this message translates to:
  /// **'Stay with us'**
  String get stayWithUs;

  /// No description provided for @yesLogOut.
  ///
  /// In en, this message translates to:
  /// **'Yes, Log Out'**
  String get yesLogOut;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed'**
  String get logoutFailed;

  /// No description provided for @noHabitsToExport.
  ///
  /// In en, this message translates to:
  /// **'No habits to export yet!'**
  String get noHabitsToExport;

  /// No description provided for @preparingData.
  ///
  /// In en, this message translates to:
  /// **'Preparing data...'**
  String get preparingData;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String exportError(Object error);

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No Email'**
  String get noEmail;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between Arabic and English'**
  String get languageSubtitle;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get active;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us and start building better habits'**
  String get registerSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameRequired;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get nameMinLength;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password does not meet requirements'**
  String get passwordInvalid;

  /// No description provided for @registerError.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerError;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLink;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @habitReminders.
  ///
  /// In en, this message translates to:
  /// **'Habit Reminders'**
  String get habitReminders;

  /// No description provided for @noHabitsFound.
  ///
  /// In en, this message translates to:
  /// **'No habits found to schedule'**
  String get noHabitsFound;

  /// No description provided for @reminderActive.
  ///
  /// In en, this message translates to:
  /// **'Reminder is active'**
  String get reminderActive;

  /// No description provided for @reminderOff.
  ///
  /// In en, this message translates to:
  /// **'Reminder is off'**
  String get reminderOff;

  /// No description provided for @enableNotificationsMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enable notifications from system settings'**
  String get enableNotificationsMsg;

  /// No description provided for @reminderSetFor.
  ///
  /// In en, this message translates to:
  /// **'Reminder set for {time}'**
  String reminderSetFor(Object time);

  /// No description provided for @remindMeOf.
  ///
  /// In en, this message translates to:
  /// **'Remind me of {title}'**
  String remindMeOf(Object title);

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Routina: Time for {title}! 🚀'**
  String notificationTitle(Object title);

  /// No description provided for @notificationBody.
  ///
  /// In en, this message translates to:
  /// **'Stay consistent! It is time to complete this habit.'**
  String get notificationBody;

  /// No description provided for @setDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Set daily reminder'**
  String get setDailyReminder;

  /// No description provided for @habitTitle.
  ///
  /// In en, this message translates to:
  /// **'Habit Title'**
  String get habitTitle;

  /// No description provided for @iconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get iconLabel;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @frequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequencyLabel;

  /// No description provided for @reminderAtTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder at {time}'**
  String reminderAtTime(Object time);

  /// No description provided for @setReminderOptional.
  ///
  /// In en, this message translates to:
  /// **'Set a reminder (optional)'**
  String get setReminderOptional;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @createHabit.
  ///
  /// In en, this message translates to:
  /// **'Create Habit'**
  String get createHabit;

  /// No description provided for @noHabitsYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Habits Yet'**
  String get noHabitsYetTitle;

  /// No description provided for @noHabitsYetEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Start building your first habit and track your progress every day.'**
  String get noHabitsYetEmptyDesc;

  /// No description provided for @addFirstHabit.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Habit'**
  String get addFirstHabit;

  /// No description provided for @passwordLowercase.
  ///
  /// In en, this message translates to:
  /// **'At least 1 lowercase letter'**
  String get passwordLowercase;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'At least 1 uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @passwordSpecial.
  ///
  /// In en, this message translates to:
  /// **'At least 1 special character'**
  String get passwordSpecial;

  /// No description provided for @passwordNumber.
  ///
  /// In en, this message translates to:
  /// **'At least 1 number'**
  String get passwordNumber;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @unnamedHabit.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Habit'**
  String get unnamedHabit;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Use at least 6 characters.'**
  String get weakPassword;

  /// No description provided for @wrongEmail.
  ///
  /// In en, this message translates to:
  /// **'Wrong email? Go back and try again'**
  String get wrongEmail;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(Object version);

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ by Nilient'**
  String get madeWithLove;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get rateApp;

  /// No description provided for @rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Love Routina? Leave us a review ⭐'**
  String get rateAppSubtitle;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share the App'**
  String get shareApp;

  /// No description provided for @shareAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help others build better habits'**
  String get shareAppSubtitle;

  /// No description provided for @shareAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out Routina — a beautiful habit tracker app! https://play.google.com/store/apps/details?id=com.routina.app'**
  String get shareAppMessage;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Routina'**
  String get appName;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
