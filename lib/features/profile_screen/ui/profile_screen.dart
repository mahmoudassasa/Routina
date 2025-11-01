import 'package:flutter/material.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_logout_button.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_settings_options.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_user_details.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_user_picture.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_user_state_cards.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8FAFC), // very light blue
            Color(0xFFE0E7FF), // light indigo
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Profile Picture
              const ProfileScreenUserPicture(),
              const SizedBox(height: 24),
              // User Details
              const ProfileScreenUserDetails(),
              // Stats Cards
              const ProfileScreenUserStateCards(),
              const SizedBox(height: 40),
              // Settings Options
              const ProfileScreenSettingsOptions(),
              const SizedBox(height: 20),
              // Logout Button
              const ProfileScreenLogoutButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
