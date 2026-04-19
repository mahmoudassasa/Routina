import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_user_picture.dart';

class ProfileHeaderSection extends StatefulWidget {
  const ProfileHeaderSection({super.key});

  @override
  State<ProfileHeaderSection> createState() => _ProfileHeaderSectionState();
}

class _ProfileHeaderSectionState extends State<ProfileHeaderSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 260.h,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  height: 170.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              Color.lerp(AppColors.darkBackground, AppColors.primaryDark, _controller.value)!,
                              Color.lerp(AppColors.darkBackgroundLight, AppColors.primary, _controller.value)!,
                            ]
                          : [
                              Color.lerp(AppColors.primaryLight, AppColors.accentLight, _controller.value)!,
                              Color.lerp(AppColors.primary, AppColors.accent, _controller.value)!,
                            ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.r),
                      bottomRight: Radius.circular(50.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.1),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Positioned.fill(
            child: CustomPaint(
              painter: WavePainter(_controller.value, isDark),
            ),
          ),

          Positioned(
            top: 120.h,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.9, end: 1.0),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppColors.primaryLight.withValues(alpha:0.3)
                            : AppColors.accent.withValues(alpha:0.7),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? AppColors.primary.withValues(alpha:0.25)
                              : AppColors.accent.withValues(alpha:0.25),
                          blurRadius: 22,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.darkBackground : Colors.white,
                      ),
                      child: const ProfileScreenUserPicture(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  final bool isDark;
  WavePainter(this.progress, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? AppColors.primary.withValues(alpha:0.08)
          : AppColors.accent.withValues(alpha:0.08)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 18.0;
    final waveLength = size.width / 1.5;

    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      double y = size.height -
          waveHeight * math.sin((x / waveLength * 2 * math.pi) + progress * 2 * math.pi);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
