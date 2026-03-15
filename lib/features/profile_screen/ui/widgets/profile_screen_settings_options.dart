import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_settings_tile.dart';

class ProfileScreenSettingsOptions extends StatelessWidget {
  const ProfileScreenSettingsOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
        SettingsTile(
  icon: '🔔',
  title: 'Notifications',
  subtitle: 'Manage your reminders',
onTap: () {
  context.pushNamed(
    Routes.notificationScreen,
    arguments: context.read<HomeCubit>(), // بنبعت الـ instance اللي شغال حالياً
  );
},
),

          // Fixed: Using ThemeState instead of ThemeMode
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final isDark = state.isDarkMode;
              return SettingsTile(
                icon: isDark ? '🌙' : '☀️',
                title: 'Dark Mode',
                subtitle: isDark ? 'Enabled' : 'Disabled',
                onTap: () {
                  // Fixed: toggleTheme() usually takes no arguments in your implementation
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),

          SettingsTile(
            icon: '📱',
            title: 'Export Data',
            subtitle: 'Download your habit data',
            onTap: () {},
          ),

          SettingsTile(
            icon: '❓',
            title: 'Help & Support',
            subtitle: 'Get help and contact us',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
