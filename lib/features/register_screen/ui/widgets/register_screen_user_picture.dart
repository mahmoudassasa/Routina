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
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
      if (state.imageStatus == ImageUploadStatus.uploading) {
  return Container(
    width: 120.w,
    height: 120.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.primary, width: 3.w),
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

        final imageWidget = _buildImageWidget(state);

        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              imageWidget,

              // ------------------------
              // Add button (+)
              // ------------------------
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
                      border: Border.all(color: Colors.white, width: 2.w),
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

  Widget _buildImageWidget(RegisterState state) {
// If the user hasn't loaded yet, display the default image
    if (state.localImage == null) {
      return Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3.w),
        ),
        child: ClipOval(
          child: Image.asset('assets/images/unknown.png', fit: BoxFit.cover),
        ),
      );
    }

// If there is a picture from the device
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 3.w),
      ),
      child: ClipOval(child: Image.file(state.localImage!, fit: BoxFit.cover)),
    );
  }
}
