import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/widgets/language_bottom_sheet.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/locale/logic/locale_cubit.dart';
import 'package:routina/features/profile_screen/ui/widgets/delete_account_sheet.dart';
import 'package:routina/features/profile_screen/ui/widgets/export_data_fun.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_settings_tile.dart';

class ProfileScreenSettingsOptions extends StatelessWidget {
  const ProfileScreenSettingsOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          //Notifications Settings
          SettingsTile(
            icon: '🔔',
            title: context.l10n.notifications,
            subtitle: context.l10n.manageReminders,
            onTap: () {
              context.pushNamed(
                Routes.notificationScreen,
                arguments: context.read<HomeCubit>(),
              );
            },
          ),
          // Theme Settings
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final isDark = state.isDarkMode;
              return SettingsTile(
                icon: isDark ? '🌙' : '☀️',
                title: context.l10n.darkMode,
                subtitle: isDark
                    ? context.l10n.darkModeEnabled
                    : context.l10n.darkModeDisabled,
                onTap: () {
                  // Fixed: toggleTheme() usually takes no arguments in your implementation
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          //Exporting Settings
          SettingsTile(
            icon: '📱',
            title: context.l10n.exportData,
            subtitle: context.l10n.downloadHabitData,
            onTap: () {
              exportData(context);
            },
          ),
          //Help & Support Settings
          SettingsTile(
            icon: '❓',
            title: context.l10n.helpAndSupport,
            subtitle: context.l10n.getHelpContact,
            onTap: () {
              context.pushNamed(Routes.helpSupportScreen);
            },
          ),
          SettingsTile(
            icon: '🌐',
            title: context.l10n.language,
            subtitle: context.l10n.languageSubtitle,
            onTap: () {
              final localeCubit = context.read<LocaleCubit>();
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider.value(
                  value: localeCubit,
                  child: LanguageBottomSheet(),
                ),
              );
            },
          ),
          SettingsTile(
            icon: 'ℹ️',
            title: context.l10n.about,
            subtitle: context.l10n.madeWithLove,
            onTap: () {
              context.pushNamed(Routes.aboutScreen);
            },
          ),
          SettingsTile(
            icon: '🗑️',
            title: context.l10n.deleteAccount,
            subtitle: context.l10n.deleteAccountSubtitle,
            onTap: () => showDeleteAccountSheet(context),
          ),
        ],
      ),
    );
  }
}
