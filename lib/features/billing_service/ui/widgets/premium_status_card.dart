import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/billing_service/ui/widgets/paywall_screen.dart';

// Assuming verticalSpace and horizontalSpace are imported or defined globally, 
// they are utilized below instead of raw SizedBoxes.

class PremiumStatusCard extends StatelessWidget {
  const PremiumStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BillingCubit()..init(),
      child: const _PremiumStatusCardContent(),
    );
  }
}

class _PremiumStatusCardContent extends StatefulWidget {
  const _PremiumStatusCardContent();

  @override
  State<_PremiumStatusCardContent> createState() =>
      _PremiumStatusCardContentState();
}

class _PremiumStatusCardContentState extends State<_PremiumStatusCardContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _openPaywall(BuildContext context) {
    context.push(
      BlocProvider(
        create: (_) => BillingCubit()..init(),
        child: const PaywallScreen(),
      ),
    );
  }

  void _openPlanDetails(BuildContext context, BillingState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlanDetailsSheet(state: state),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillingCubit, BillingState>(
      builder: (context, state) {
        if (state.status == BillingStatus.loading) {
          return _buildShimmer(context);
        }
        if (state.isPremium) {
          return _buildPremiumCard(context, state);
        }
        return _buildFreeCard(context);
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        height: 72.h,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
        ),
      ),
    );
  }

  Widget _buildFreeCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTap: () => _openPaywall(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: borderColor, width: 1.w),
          ),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_outlined,
                  color: AppColors.primary,
                  size: 22.r,
                ),
              ),
              horizontalSpace(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.freePlan,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    verticalSpace(2),
                    Text(
                      context.l10n.upgradeToPremium,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context, BillingState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTap: () => _openPlanDetails(context, state),
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [
                    Color(0xFFB8860B),
                    Color(0xFFFFD700),
                    Color(0xFFB8860B),
                  ],
                  stops: [
                    (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                    _shimmerController.value,
                    (_shimmerController.value + 0.3).clamp(0.0, 1.0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 24.r,
                ),
              ),
              horizontalSpace(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.routinaPremium,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontFamily: 'Inter',
                      ),
                    ),
                    verticalSpace(2),
                    Text(
                      state.premiumUntil != null
                          ? context.l10n.expiresOn(
                              DateFormat.yMMMd(
                                context.l10n.localeName,
                              ).format(state.premiumUntil!),
                            )
                          : context.l10n.activeMember,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanDetailsSheet extends StatelessWidget {
  final BillingState state;

  const _PlanDetailsSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          verticalSpace(24),
          Container(
            width: 64.r,
            height: 64.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB8860B), Color(0xFFFFD700)],
              ),
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 32.r,
            ),
          ),
          verticalSpace(16),
          Text(
            context.l10n.routinaPremium,
            style: AppTextStyles.titleMedium.copyWith(color: textPrimary),
          ),
          verticalSpace(8),
          Text(
            state.premiumUntil != null
                ? context.l10n.planRenewsOn(
                    DateFormat.yMMMd(
                      context.l10n.localeName,
                    ).format(state.premiumUntil!),
                  )
                : context.l10n.activeMember,
            style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
            textAlign: TextAlign.center,
          ),
          verticalSpace(24),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton(
              onPressed: () => context.read<BillingCubit>().restore(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                context.l10n.restore,
                style: AppTextStyles.titleMedium.copyWith(color: textPrimary),
              ),
            ),
          ),
          verticalSpace(12),
        ],
      ),
    );
  }
}