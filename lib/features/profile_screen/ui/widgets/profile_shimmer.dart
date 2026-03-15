import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            // User Picture Shimmer
            CircleAvatar(
              radius: 60.r,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 24.h),
            // User Details Shimmer (Name & Email)
            Container(
              width: 150.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              width: 200.w,
              height: 15.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 30.h),
            // State Cards Shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Expanded(child: _buildCardSkeleton()),
                  SizedBox(width: 15.w),
                  Expanded(child: _buildCardSkeleton()),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            // Settings Options Shimmer
            _buildListTileSkeleton(context),
            _buildListTileSkeleton(context),
            _buildListTileSkeleton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSkeleton() {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }

  Widget _buildListTileSkeleton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}