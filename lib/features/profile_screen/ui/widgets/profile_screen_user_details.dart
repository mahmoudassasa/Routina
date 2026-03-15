import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';

class ProfileScreenUserDetails extends StatelessWidget {
  const ProfileScreenUserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.loading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        if (state.errorMessage != null) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Text(
              "Error: ${state.errorMessage}",
              style: const TextStyle(color: AppColors.error),
            ),
          );
        }

        return Column(
          children: [
            Text(
              state.name ?? "Unknown User",
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              state.email ?? "No Email",
              style: TextStyle(
                fontSize: 16.sp, // Reduced slightly for better hierarchy
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 40.h),
          ],
        );
      },
    );
  }
}