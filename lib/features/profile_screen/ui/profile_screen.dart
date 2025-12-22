import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_cubit.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_state.dart';
import 'package:routina/core/widgets/logout_button/ui/logout_dialog.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
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
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadUserData();
  }

  @override
  Widget build(BuildContext context) {
  return BlocListener<LogoutCubit, LogoutState>(
  listener: (context, state) async {
    if (state.status == LogoutStatus.success) {
      // 1. استنى ثانية أو ثانية ونص والدايلوج لسه مفتوح عشان المستخدم يشوف الرسالة
      await Future.delayed(const Duration(milliseconds: 3000));

      if (context.mounted) {
        // 2. اقفل الدايلوج
        context.pop();

        // 3. استنى 200 مللي ثانية كمان عشان الدايلوج يلحق يختفي بسلاسة (Fade out)
        await Future.delayed(const Duration(milliseconds: 200));

        // 4. روح لصفحة اللوجن
        if (context.mounted) {
          context.pushNamedAndRemoveUntil(
            Routes.loginScreen,
            predicate: (route) => false,
          );
        }
      }
    } else if (state.status == LogoutStatus.error) {
      // لو حصل خطأ، اقفل الدايلوج فوراً وطلع الـ SnackBar
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'Logout failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
      child: Container(
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
                ProfileLogoutButton(
                  onTap: () {
                    // لا نحتاج await أو results لأن الدايلوج والـ BlocListener سيتصرفان
                    showLogoutDialog(context);
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
