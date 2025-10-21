import 'package:flutter/material.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_settings_tile.dart';

class ProfileScreenSettingsOptions extends StatefulWidget {
  const ProfileScreenSettingsOptions({super.key});

  @override
  State<ProfileScreenSettingsOptions> createState() =>
      _ProfileScreenSettingsOptionsState();
}

class _ProfileScreenSettingsOptionsState
    extends State<ProfileScreenSettingsOptions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Material(
            child: SettingsTile(
              icon: '🔔',
              title: 'Notifications',
              subtitle: 'Manage your reminders',
              onTap: () {},
            ),
          ),
    
          Material(
            child: SettingsTile(
              icon: '🌙',
              title: 'Dark Mode',
              subtitle: 'Switch app theme',
              onTap: () {},
            ),
          ),
    
          Material(
            child: SettingsTile(
              icon: '📱',
              title: 'Export Data',
              subtitle: 'Download your habit data',
              onTap: () {},
            ),
          ),
    
          Material(
            child: SettingsTile(
              icon: '❓',
              title: 'Help & Support',
              subtitle: 'Get help and contact us',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
