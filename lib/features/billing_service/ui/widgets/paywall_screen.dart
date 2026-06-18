import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/billing_service/ui/billing_service.dart';
import '../../../../core/theaming/app_colors.dart';
import '../../../../core/theaming/app_text_styles.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  List<ProductDetails> _products = [];
  bool _loadingProducts = true;
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final service = BillingService();
    final products = await service.fetchProducts();
    products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
    if (mounted) {
      setState(() {
        _products = products;
        _selectedId = products.isNotEmpty ? products.last.id : null;
        _loadingProducts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildContent()),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(Icons.close, color: Colors.white54, size: 24.r),
          ),
          BlocBuilder<BillingCubit, BillingState>(
            builder: (context, state) => GestureDetector(
              onTap: state.isRestoring
                  ? null
                  : () => context.read<BillingCubit>().restore(),
              child: Text(
                state.isRestoring
                    ? context.l10n.restoring
                    : context.l10n.restore,
                style: AppTextStyles.font14WhiteRegular.copyWith(
                  color: AppColors.primaryLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          _buildCrownIcon(),
          SizedBox(height: 20.h),
          Text(
            context.l10n.routinaPremium,

            style: AppTextStyles.font24WhiteBold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            context.l10n.unlockPotential,

            style: AppTextStyles.font14WhiteRegular.copyWith(
              color: Colors.white54,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          _buildFeatureList(),
          SizedBox(height: 32.h),
          _loadingProducts ? _buildProductShimmer() : _buildProductCards(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildCrownIcon() {
    return Container(
      width: 72.r,
      height: 72.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.darkSurface,
        border: Border.all(color: AppColors.primary, width: 2.w),
      ),
      child: Icon(
        Icons.workspace_premium,
        color: AppColors.primary,
        size: 36.r,
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      (
        Icons.analytics_outlined,
        context.l10n.featureAiAnalysis,
        context.l10n.featureAiAnalysisDesc,
      ),
      (
        Icons.all_inclusive,
        context.l10n.featureUnlimitedHabits,
        context.l10n.featureUnlimitedHabitsDesc,
      ),
      (
        Icons.support_agent_outlined,
        context.l10n.featurePrioritySupport,
        context.l10n.featurePrioritySupportDesc,
      ),
    ];
    return Column(
      children: features.map((f) => _featureRow(f.$1, f.$2, f.$3)).toList(),
    );
  }

  Widget _featureRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22.r),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.font16WhiteMedium),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: AppTextStyles.font14WhiteRegular.copyWith(
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductShimmer() {
    return Column(
      children: List.generate(
        2,
        (_) => Container(
          margin: EdgeInsets.only(bottom: 12.h),
          height: 76.h,
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCards() {
    if (_products.isEmpty) {
      return Text(
        context.l10n.productsUnavailable,
        style: AppTextStyles.font14WhiteRegular.copyWith(color: Colors.white38),
      );
    }
    return Column(children: _products.map((p) => _productCard(p)).toList());
  }

  Widget _productCard(ProductDetails product) {
    final isSelected = _selectedId == product.id;
    final isYearly = product.id == BillingService.yearlyId;

    return GestureDetector(
      onTap: () => setState(() => _selectedId = product.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.white38,
                  width: 2.w,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 14.r)
                  : null,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isYearly ? context.l10n.yearly : context.l10n.monthly,
                        style: AppTextStyles.font16WhiteMedium,
                      ),
                      if (isYearly) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            context.l10n.bestValue,
                            style: AppTextStyles.font12WhiteRegular,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    isYearly
                        ? '${product.price} ${context.l10n.perYear}'
                        : '${product.price} ${context.l10n.perMonth}',
                    style: AppTextStyles.font14WhiteRegular.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      child: Column(
        children: [
          BlocConsumer<BillingCubit, BillingState>(
            listener: (context, state) {
              if (state.status == BillingStatus.active) {
                Navigator.pop(context);
              } else if (state.status == BillingStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? context.l10n.somethingWentWrong,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final loading = state.status == BillingStatus.loading;
              return SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: loading || _selectedId == null
                      ? null
                      : () {
                          final product = _products.firstWhere(
                            (p) => p.id == _selectedId,
                          );
                          context.read<BillingCubit>().subscribe(product);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.darkSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: loading
                      ? SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          context.l10n.continueText,
                          style: AppTextStyles.font16WhiteMedium,
                        ),
                ),
              );
            },
          ),
          SizedBox(height: 12.h),
          Text(
            context.l10n.cancelAnytime,
            style: AppTextStyles.font12WhiteRegular.copyWith(
              color: Colors.white30,
            ),
          ),
        ],
      ),
    );
  }
}
