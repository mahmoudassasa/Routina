import 'package:flutter/material.dart';
import '../../../core/helpers/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blue25, AppColors.indigo25],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacing4),
          child: Column(
            children: [
              // Profile Header
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radius2xl),
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.spacing6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radius2xl),
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.blue400, AppColors.indigo500],
                          ),
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.white,
                        ),
                      ),
                      
                      const SizedBox(height: AppSizes.spacing4),
                      
                      const Text(
                        'Alex Johnson',
                        style: AppTextStyles.h1,
                      ),
                      
                      Text(
                        'Habit Tracker Enthusiast',
                        style: AppTextStyles.bodySm.copyWith(color: AppColors.blue600),
                      ),
                      
                      const SizedBox(height: AppSizes.spacing4),
                      
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn('Habits', '6'),
                          _buildStatColumn('Streak', '12'),
                          _buildStatColumn('Level', '3'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing6),
              
              // Settings Section
              _buildSettingsSection(
                'Account',
                [
                  _buildSettingsItem(
                    Icons.person_outline,
                    'Edit Profile',
                    'Update your personal information',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.notifications_outlined,
                    'Notifications',
                    'Manage your notification preferences',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.security,
                    'Privacy & Security',
                    'Control your privacy settings',
                    () {},
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.spacing4),
              
              _buildSettingsSection(
                'Preferences',
                [
                  _buildSettingsItem(
                    Icons.palette_outlined,
                    'Theme',
                    'Choose your app theme',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.language,
                    'Language',
                    'Select your preferred language',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.backup,
                    'Backup & Sync',
                    'Sync your data across devices',
                    () {},
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.spacing4),
              
              _buildSettingsSection(
                'Support',
                [
                  _buildSettingsItem(
                    Icons.help_outline,
                    'Help & Support',
                    'Get help and contact support',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.star_outline,
                    'Rate App',
                    'Rate us on the app store',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.info_outline,
                    'About',
                    'App version and information',
                    () {},
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.spacing6),
              
              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue500,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                    ),
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h1.copyWith(color: AppColors.blue500),
        ),
        Text(
          label,
          style: AppTextStyles.bodySm,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spacing4,
                AppSizes.spacing4,
                AppSizes.spacing4,
                AppSizes.spacing2,
              ),
              child: Text(
                title,
                style: AppTextStyles.h3,
              ),
            ),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing4,
          vertical: AppSizes.spacing3,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.spacing2),
              decoration: BoxDecoration(
                color: AppColors.blue50,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Icon(
                icon,
                color: AppColors.blue500,
                size: AppSizes.iconSize,
              ),
            ),
            const SizedBox(width: AppSizes.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyBase),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySm),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.gray600,
              size: AppSizes.iconSize,
            ),
          ],
        ),
      ),
    );
  }
}