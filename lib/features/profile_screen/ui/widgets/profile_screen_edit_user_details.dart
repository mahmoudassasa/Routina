import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';

class ProfileScreenEditUserDetails extends StatelessWidget {
  const ProfileScreenEditUserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.loading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state.errorMessage != null) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        }

        return Column(
          children: [
            Text(
              state.name ?? context.l10n.unknownUser,
              style: AppTextStyles.displaySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),

            verticalSpace(10),

            GestureDetector(
              onTap: () {
                context.pushNamed(
                  Routes.accountInformationScreen,
                  arguments: context.read<ProfileCubit>(),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 18.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      context.l10n.editProfile,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            verticalSpace(40),
          ],
        );
      },
    );
  }
}
