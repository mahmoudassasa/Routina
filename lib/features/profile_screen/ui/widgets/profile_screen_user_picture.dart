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
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state.imageUrl != null && state.imageUrl!.isNotEmpty) {
          return _buildImage(state.imageUrl!, isDark);
        }

        // Fallback to local asset
        return _buildImage('assets/images/unknown.png', isDark, isLocal: true);
      },
    );
  }

  Widget _buildImage(String source, bool isDark, {bool isLocal = false}) {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.darkBackground : Colors.white,
          width: 4.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12.w,
            offset: Offset(0, 4.h),
          ),
        ],
      ),

      child: ClipOval(
        child: isLocal
            ? Image.asset(source, fit: BoxFit.cover)
            : Image.network(
                source,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/unknown.png', fit: BoxFit.cover),
              ),
      ),
    );
  }
}
