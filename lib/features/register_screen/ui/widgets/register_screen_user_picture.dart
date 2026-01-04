import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/register_screen/logic/cubit/register_cubit.dart';
import 'package:routina/features/register_screen/logic/cubit/register_state.dart';

class RegisterScreenUserPicture extends StatelessWidget {
  const RegisterScreenUserPicture({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        if (state.imageStatus == ImageUploadStatus.uploading) {
          return Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.primary.withValues(alpha: 0.8) : AppColors.primary,
                width: 3.w,
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 40.w,
                height: 40.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3.w,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        }

        final imageWidget = _buildImageWidget(context, state, isDark);

        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              imageWidget,
              
              // Add button (+)
              Positioned(
                bottom: -4,
                right: -4,
                child: GestureDetector(
                  onTap: () => context.read<RegisterCubit>().pickImage(),
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      // Adjusted border color for dark mode
                      border: Border.all(
                        color: isDark ? const Color(0xFF1A1A1A) : Colors.white, 
                        width: 2.w,
                      ),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 22.w),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageWidget(BuildContext context, RegisterState state, bool isDark) {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Adding a subtle background color for the placeholder area
        color: isDark ? Colors.white10 : Colors.grey[100],
        border: Border.all(
          color: isDark ? AppColors.primary.withValues(alpha: 0.8) : AppColors.primary, 
          width: 3.w,
        ),
      ),
      child: ClipOval(
        child: state.localImage == null
            ? Image.asset(
                'assets/images/unknown.png', 
                fit: BoxFit.cover,
                // Apply a slight filter if needed to make the asset blend better with dark mode
                color: isDark ? Colors.white.withValues(alpha: 0.9) : null,
                colorBlendMode: isDark ? BlendMode.modulate : null,
              )
            : Image.file(state.localImage!, fit: BoxFit.cover),
      ),
    );
  }
}