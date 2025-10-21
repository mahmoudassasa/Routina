import 'package:flutter/material.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_logout_button.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_settings_options.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_user_details.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_user_picture.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_user_state_cards.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:   Color(0xFFF8FAFC),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      
      ),
      body: Container(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
