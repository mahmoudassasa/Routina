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
          return SizedBox(
            width: 100.w,
            height: 100.w,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3.w,
                color: AppColors.primary,
              ),
            ),
          );
        }

        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildImageContainer(context, state, isDark),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImagePickerSheet(context, isDark),
                  child: Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      border: Border.all(
                        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                        width: 3.w,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageContainer(
    BuildContext context,
    RegisterState state,
    bool isDark,
  ) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
          width: 2.w,
        ),
      ),
      child: ClipOval(
        child: state.localImage == null
            ? Icon(
                Icons.person_outline_rounded,
                size: 50.sp,
                color: isDark ? Colors.white30 : Colors.grey[400],
              )
            : Image.file(
                state.localImage!,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  void _showImagePickerSheet(BuildContext context, bool isDark) {
    final cubit = context.read<RegisterCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 24.h),
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
          ],
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
          color: AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.05),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24.sp),
            SizedBox(width: 14.w),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}