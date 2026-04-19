import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';

void showAiFeatureBottomSheet({
  required BuildContext context,
  required String icon,
  required String title,
  required Future<String> Function() onAnalyze,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _AiFeatureBottomSheetContent(
      icon: icon,
      title: title,
      onAnalyze: onAnalyze,
    ),
  );
}

class _AiFeatureBottomSheetContent extends StatelessWidget {
  final String icon;
  final String title;
  final Future<String> Function() onAnalyze;

  const _AiFeatureBottomSheetContent({
    required this.icon,
    required this.title,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.8.sh),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        left: 24.w,
        right: 24.w,
        top: 16.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1C23) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          verticalSpace(24), 
          Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(icon, style: TextStyle(fontSize: 28.sp)),
                ),
              ),
              horizontalSpace(16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(24), 
          Flexible(
            child: SingleChildScrollView(
              child: FutureBuilder<String>(
                future: onAnalyze(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        const CircularProgressIndicator(color: AppColors.primary),
                        verticalSpace(16), 
                        Text(
                          'Generating insights...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    );
                  }

                  if (snapshot.hasError) {
                    return Column(
                      children: [
                        Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                        verticalSpace(16), 
                        Text(
                          'Failed to generate',
                          style: TextStyle(fontSize: 16.sp, color: Colors.red),
                        ),
                      ],
                    );
                  }

                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.grey[50],
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      snapshot.data ?? 'No insights',
                      style: TextStyle(
                        fontSize: 14.sp,
                        height: 1.6,
                        color: isDark ? Colors.grey[300] : Colors.grey[800],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}