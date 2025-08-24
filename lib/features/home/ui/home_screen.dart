import 'package:flutter/material.dart';
import '../../../core/helpers/app_constants.dart';
import 'widgets/build_action_card.dart';
import 'widgets/header_widget.dart';
import 'widgets/recent_activity_card.dart';
import 'widgets/state_overview.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blue25, AppColors.indigo25],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const HeaderWidget(userName: 'Alex'),
              // Stats Overview
              const StateOverview(),
              const SizedBox(height: AppSizes.spacing6),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: AppSizes.spacing4),
              Row(
                children: [
                  Expanded(
                    child: BuildActionCard(
                      title: 'Add Habit',
                      icon: Icons.add_circle,
                      color: AppColors.blue500,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing3),
                  Expanded(
                    child: BuildActionCard(
                      title: 'View Progress',
                      icon: Icons.analytics,
                      color: AppColors.indigo500,
                      onTap: () {
                        },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing6),
              // Recent Activity
              const RecentActivityCard(),
            ],
          ),
        ),
      ),
    );
  }
}
