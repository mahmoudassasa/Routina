import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_state.dart';
import 'package:routina/features/home_screen/ui/widgets/habit_card.dart';

class HabitsList extends StatelessWidget {
  const HabitsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.habits.length,
            itemBuilder: (context, index) {
              final habit = state.habits[index];
              return HabitCard(
                habit: habit,
                onTap: () {
                  context.read<HomeCubit>().toggleHabit(habit['id']);
                },
              );
            },
          );
        },
      ),
    );
  }
}
