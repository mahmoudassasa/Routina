import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';

class ProfileHeaderImage extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onTap;

  const ProfileHeaderImage({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
              child: hasImage
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFallbackIcon(isDark);
                      },
                    )
                  : _buildFallbackIcon(isDark),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
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
  }

  Widget _buildFallbackIcon(bool isDark) {
    return Icon(
      Icons.person_outline_rounded,
      size: 60.sp,
      color: isDark ? Colors.white30 : Colors.grey[400],
    );
  }
}