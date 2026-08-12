import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
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
        final currentStreak =
            "${state.currentStreakCount} ${context.l10n.days}";
        final totalHabits = "${state.totalHabitsCount} ${context.l10n.active}";
        final completionRate = state.completionRate;
        final bestStreak = "${state.bestStreakCount} ${context.l10n.days}";

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: '🔥',
                          title: context.l10n.currentStreak,
                          value: currentStreak,
                        ),
                      ),
                      horizontalSpace(16),
                      Expanded(
                        child: StatCard(
                          icon: '🎯',
                          title: context.l10n.totalHabitsLabel,
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
                          title: context.l10n.completionRate,
                          value: completionRate,
                        ),
                      ),
                      horizontalSpace(16),
                      Expanded(
                        child: StatCard(
                          icon: '🏆',
                          title: context.l10n.bestStreakLabel,
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
