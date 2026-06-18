import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/billing_service/ui/widgets/paywall_screen.dart';

part 'drag_handle.dart';
part 'feature_icon.dart';
part 'premium_badge.dart';
part 'features_list.dart';
part 'upgrade_button.dart';
part 'maybe_later_button.dart';

void showPremiumFeatureBottomSheet({
  required BuildContext context,
  required String icon,
  required String title,
  required String description,
  required List<String> features,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _PremiumFeatureBottomSheetContent(
      icon: icon,
      title: title,
      description: description,
      features: features,
    ),
  );
}

class _PremiumFeatureBottomSheetContent extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final List<String> features;

  const _PremiumFeatureBottomSheetContent({
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.85.sh),
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
          const _DragHandle(),
          verticalSpace(24),

          _FeatureIcon(icon: icon),

          verticalSpace(24),

          const _PremiumBadge(),

          verticalSpace(16),

          Text(
            title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          verticalSpace(12),

          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              height: 1.5.h,
            ),
            textAlign: TextAlign.center,
          ),

          verticalSpace(24),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _FeaturesList(features: features),

                  verticalSpace(24),

                  const _UpgradeButton(),

                  verticalSpace(16),

                  const _MaybeLaterButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
