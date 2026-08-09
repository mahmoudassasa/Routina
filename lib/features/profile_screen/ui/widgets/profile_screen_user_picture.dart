import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';

class ProfileScreenUserPicture extends StatelessWidget {
  const ProfileScreenUserPicture({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.loading) {
          return SizedBox(
            width: 120.w,
            height: 120.w,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3.w,
                color: AppColors.primary,
              ),
            ),
          );
        }

        return Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black12,
              width: 2.w,
            ),
          ),
          child: ClipOval(
            child: _buildImageContent(state.imageUrl, isDark),
          ),
        );
      },
    );
  }

  Widget _buildImageContent(String? imageUrl, bool isDark) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(isDark),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              color: AppColors.primary,
            ),
          );
        },
      );
    }

    return _buildFallbackIcon(isDark);
  }

  Widget _buildFallbackIcon(bool isDark) {
    return Icon(
      Icons.person_outline_rounded,
      size: 60.sp,
      color: isDark ? Colors.white30 : Colors.grey[400],
    );
  }
}