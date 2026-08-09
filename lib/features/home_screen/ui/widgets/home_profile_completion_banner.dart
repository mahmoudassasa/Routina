import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/routing/routes.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';

class HomeProfileCompletionBanner extends StatefulWidget {
  const HomeProfileCompletionBanner({super.key});

  @override
  State<HomeProfileCompletionBanner> createState() =>
      _HomeProfileCompletionBannerState();
}

class _HomeProfileCompletionBannerState
    extends State<HomeProfileCompletionBanner> {
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.profileCompleted) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: Colors.amber.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.amber.shade700,
                size: 18.sp,
              ),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  context.l10n.completeProfileToGetBadge,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pushNamed(
                    Routes.accountInformationScreen,
                    arguments: context.read<ProfileCubit>(),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  context.l10n.completeNow,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              horizontalSpace(4),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDismissed = true;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.close,
                    size: 16.sp,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}