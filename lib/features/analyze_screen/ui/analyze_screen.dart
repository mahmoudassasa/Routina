import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/services/ad_banner_widget.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_cubit.dart';
import 'package:routina/features/analyze_screen/logic/cubit/analytics_state.dart';
import 'package:routina/features/analyze_screen/ui/widgets/advanced_stats_tab.dart';
import 'package:routina/features/analyze_screen/ui/widgets/gemini_tab.dart';
import 'package:routina/features/analyze_screen/ui/widgets/goal_optimization_tab.dart';
import 'package:routina/features/analyze_screen/ui/widgets/overall_tab.dart';
import 'package:routina/features/analyze_screen/ui/widgets/smart_suggestions_tab.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => AnalyticsCubit(
        homeCubit: context.read<HomeCubit>(),
        billingCubit: context.read<BillingCubit>(),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.darkBackgroundGradientStart,
                    AppColors.darkBackgroundGradientEnd,
                  ]
                : [
                    AppColors.backgroundGradientStart,
                    AppColors.backgroundGradientEnd,
                  ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: const AdBannerWidget(),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, isDark),
                _buildTabBar(context, isDark),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      OverallTab(),
                      AdvancedStatsTab(),
                      GeminiTab(),
                      SmartSuggestionsTab(),      
                      GoalOptimizationTab(),       
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text('🤖', style: TextStyle(fontSize: 20.sp)),
            ),
          ),
          horizontalSpace(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.aiAnalysis,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                context.l10n.poweredByGemini,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          BlocBuilder<AnalyticsCubit, AnalyticsState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 12.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    horizontalSpace(4),
                    Text(
                      '${state.remainingDailyRequests}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, bool isDark) {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: isDark ? Colors.white : Colors.black87,
      unselectedLabelColor: isDark ? Colors.grey[500] : Colors.grey[600],
      indicatorColor: AppColors.primary,
      labelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
      tabs: [
        Tab(text: context.l10n.overallAnalysis),
        Tab(text: context.l10n.advancedStats),
        Tab(text: '✨ ${context.l10n.aiInsights}'),
        Tab(text: '💡 ${context.l10n.smartSuggestions}'),
        Tab(text: '🎯 ${context.l10n.goalOptimization}'),
      ],
    );
  }
}