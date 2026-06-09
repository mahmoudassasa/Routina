import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
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
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.8)
                    : AppColors.primary,
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
                  onTap: () => _showImagePickerSheet(context, isDark),
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

  Widget _buildImageWidget(
    BuildContext context,
    RegisterState state,
    bool isDark,
  ) {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Adding a subtle background color for the placeholder area
        color: isDark ? Colors.white10 : Colors.grey[100],
        border: Border.all(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.8)
              : AppColors.primary,
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

  void _showImagePickerSheet(BuildContext context, bool isDark) {
    final cubit = context.read<RegisterCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              _tile(
                context,
                icon: Icons.camera_alt_rounded,
                title: context.l10n.takePhoto,
                isDark: isDark,
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImage(source: ImageSource.camera);
                },
              ),
              SizedBox(height: 12.h),
              _tile(
                context,
                icon: Icons.photo_library_outlined,
                title: context.l10n.chooseFromGallery,
                isDark: isDark,
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImage(source: ImageSource.gallery);
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.07),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22.sp),
            SizedBox(width: 14.w),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
