import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        title: Text(
          context.l10n.accountInformation,
          style: AppTextStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // ── Profile Photo ──────────────────────────
                Center(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3.w,
                          ),
                        ),
                        child: ClipOval(
                          child:
                              state.imageUrl != null &&
                                  state.imageUrl!.isNotEmpty
                              ? Image.network(
                                  state.imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/unknown.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showImagePickerBottomSheet(context),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBackground
                                  : AppColors.background,
                              width: 2.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                verticalSpace(48),

                // ── Information Cards ──────────────────────
                _buildInfoTile(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: context.l10n.name,
                  value: state.name ?? context.l10n.unknownUser,
                  editable: true,
                  onTap: () => _showEditNameSheet(context, state.name ?? ''),
                ),
                verticalSpace(14),

                _buildInfoTile(
                  context,
                  icon: Icons.email_outlined,
                  title: context.l10n.email,
                  value: state.email ?? context.l10n.noEmail,
                  editable: false,
                  isEmail: true,
                ),
                verticalSpace(14),

                _buildInfoTile(
                  context,
                  icon: Icons.phone_outlined,
                  title: context.l10n.phoneNumber,
                  value: context.l10n.notAdded,
                  editable: true,
                  onTap: () {},
                ),
                verticalSpace(14),

                _buildInfoTile(
                  context,
                  icon: Icons.cake_outlined,
                  title: context.l10n.dateOfBirth,
                  value: context.l10n.notAdded,
                  editable: true,
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required bool editable,
    bool isEmail = false,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: editable ? onTap : null,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: isDark
              ? (isEmail
                    ? AppColors.darkSurface.withValues(alpha: 0.5)
                    : AppColors.darkSurface)
              : (isEmail ? Colors.grey[100]! : Colors.white),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22.sp),
            ),
            horizontalSpace(14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  verticalSpace(4),
                  Text(
                    value,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                      fontSize: isEmail ? 14.sp : null,
                    ),
                    overflow: isEmail ? TextOverflow.ellipsis : null,
                    maxLines: isEmail ? 1 : null,
                  ),
                ],
              ),
            ),

            if (editable) ...[
              horizontalSpace(8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              _bottomSheetTile(
                context,
                icon: Icons.camera_alt_rounded,
                title: context.l10n.takePhoto,
                isDark: isDark,
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileCubit>().updateProfileImage(
                    source: ImageSource.camera,
                  );
                },
              ),
              verticalSpace(12),
              _bottomSheetTile(
                context,
                icon: Icons.photo_library_outlined,
                title: context.l10n.chooseFromGallery,
                isDark: isDark,
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileCubit>().updateProfileImage(
                    source: ImageSource.gallery,
                  );
                },
              ),
              verticalSpace(12),
              _bottomSheetTile(
                context,
                icon: Icons.delete_outline_rounded,
                title: context.l10n.removePhoto,
                isDark: isDark,
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileCubit>().deleteProfileImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomSheetTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: color.withValues(alpha: isDark ? 0.12 : 0.07),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22.sp),
            horizontalSpace(14),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNameSheet(BuildContext context, String currentName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = TextEditingController(text: currentName);
    final cubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              Text(
                context.l10n.editName,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              verticalSpace(16),
              TextField(
                controller: controller,
                autofocus: true,
                onTap: () {
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length),
                  );
                },
                style: AppTextStyles.titleLarge.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: context.l10n.enterFullName,
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              verticalSpace(20),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () {
                    final newName = controller.text.trim();
                    if (newName.isEmpty) return;
                    Navigator.pop(sheetContext);
                    cubit.updateName(newName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    context.l10n.saveChanges,
                    style: AppTextStyles.font16WhiteMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
