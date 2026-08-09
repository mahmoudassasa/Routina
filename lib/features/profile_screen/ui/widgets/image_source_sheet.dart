import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

Future<void> showImageSourceSheet(
  BuildContext context, {
  required VoidCallback onCamera,
  required VoidCallback onGallery,
  required VoidCallback onRemove,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
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
            _tile(context, Icons.camera_alt_rounded, context.l10n.takePhoto, isDark, () {
              Navigator.pop(context);
              onCamera();
            }),
            verticalSpace(12),
            _tile(context, Icons.photo_library_outlined, context.l10n.chooseFromGallery, isDark, () {
              Navigator.pop(context);
              onGallery();
            }),
            verticalSpace(12),
            _tile(context, Icons.delete_outline_rounded, context.l10n.removePhoto, isDark, () {
              Navigator.pop(context);
              onRemove();
            }, isDestructive: true),
          ],
        ),
      ),
    ),
  );
}

Widget _tile(
  BuildContext context,
  IconData icon,
  String title,
  bool isDark,
  VoidCallback onTap, {
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
          Text(title, style: AppTextStyles.titleMedium.copyWith(color: color)),
        ],
      ),
    ),
  );
}