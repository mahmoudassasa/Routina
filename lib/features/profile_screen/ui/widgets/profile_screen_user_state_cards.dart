import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_state_card.dart';

class ProfileScreenUserStateCards extends StatelessWidget {
  const ProfileScreenUserStateCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // We can show dummy data while loading or use specific values from state
        // Assuming your ProfileState will eventually have these fields
        final currentStreak = state.currentStreak ?? "0 days";
        final totalHabits = state.totalHabits ?? "0 active";
        final completionRate = state.completionRate ?? "0%";
        final bestStreak = state.bestStreak ?? "0 days";

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                // Column is internal because of the spaces between the rows
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: '🔥',
                          title: 'Current Streak',
                          value: currentStreak,
                        ),
                      ),
                      horizontalSpace(16),
                      Expanded(
                        child: StatCard(
                          icon: '🎯',
                          title: 'Total Habits',
                          value: totalHabits,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(16),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: '📊',
                          title: 'Completion Rate',
                          value: completionRate,
                        ),
                      ),
                      horizontalSpace(16),
                      Expanded(
                        child: StatCard(
                          icon: '🏆',
                          title: 'Best Streak',
                          value: bestStreak,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
