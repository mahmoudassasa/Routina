import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_cubit.dart';
import 'package:routina/core/widgets/logout_button/cubit/logout_state.dart';
import 'package:routina/core/widgets/logout_button/ui/logout_dialog.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_header_section.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_logout_button.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_settings_options.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_user_details.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_user_state_cards.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_shimmer.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) async {
        if (state.status == LogoutStatus.success) {
          await Future.delayed(const Duration(milliseconds: 3000));
          if (context.mounted) {
            context.pop();
            await Future.delayed(const Duration(milliseconds: 200));
            if (context.mounted) {
              context.pushNamedAndRemoveUntil(
                Routes.loginScreen,
                predicate: (route) => false,
              );
            }
          }
        } else if (state.status == LogoutStatus.error) {
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.darkBackgroundGradientStart,
                    AppColors.darkBackgroundGradientEnd,
                  ]
                : [
                    AppColors.backgroundGradientStart,
                    AppColors.backgroundGradientEnd,
                  ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                // Check the 'loading' boolean from your ProfileState
                if (state.loading) {
                  return const ProfileShimmer();
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const ProfileHeaderSection(),
                      SizedBox(
                        height: 10.h,
                      ),
                      const ProfileScreenUserDetails(),
                      const ProfileScreenUserStateCards(),
                       verticalSpace(40), 
                      const ProfileScreenSettingsOptions(),
                       verticalSpace(20), 
                      ProfileLogoutButton(
                        onTap: () => showLogoutDialog(context),
                      ),
                      verticalSpace(30), 
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
