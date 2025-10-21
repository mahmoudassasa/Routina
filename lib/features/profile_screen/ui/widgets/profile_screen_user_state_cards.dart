import 'package:flutter/material.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_screen_state_card.dart';

class ProfileScreenUserStateCards extends StatefulWidget {
  const ProfileScreenUserStateCards({super.key});

  @override
  State<ProfileScreenUserStateCards> createState() =>
      _ProfileScreenUserStateCardsState();
}

class _ProfileScreenUserStateCardsState
    extends State<ProfileScreenUserStateCards> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: '🔥',
                    title: 'Current Streak',
                    value: '12 days',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    icon: '🎯',
                    title: 'Total Habits',
                    value: '5 active',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: '📊',
                    title: 'Completion Rate',
                    value: '78%',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    icon: '🏆',
                    title: 'Best Streak',
                    value: '21 days',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
