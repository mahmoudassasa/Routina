import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/billing_service/ui/widgets/paywall_screen.dart';
import '../../../../../core/theaming/app_colors.dart';
import '../../../../../core/theaming/app_text_styles.dart';

class PremiumGate extends StatelessWidget {
  final Widget child;
  final String reason;

  const PremiumGate({
    super.key,
    required this.child,
    this.reason = 'Upgrade to Premium to unlock this feature',
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillingCubit, BillingState>(
      builder: (context, state) {
        if (state.isPremium) return child;
        return _LockedOverlay(reason: reason);
      },
    );
  }
}

class _LockedOverlay extends StatelessWidget {
  final String reason;
  const _LockedOverlay({required this.reason});

  @override
  Widget build(BuildContext context) {
     
    return GestureDetector(
      onTap: () => _openPaywall(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
                size: 28.r,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              context.l10n.premiumFeature,
              style: AppTextStyles.font16WhiteMedium,
            ),
            SizedBox(height: 6.h),
            Text(
              reason,
              style: AppTextStyles.font14WhiteRegular
                  .copyWith(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 18.h),
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton(
                onPressed: () => _openPaywall(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child:
                    Text(context.l10n.upgradeToPremium, style: AppTextStyles.font14WhiteRegular),
              ),
            ),
          ],
        ),
      ),
    );
  }

void _openPaywall(BuildContext context) {
  context.push(
    BlocProvider(
      create: (_) => BillingCubit()..init(),
      child: const PaywallScreen(),
    ),
  );
}
}