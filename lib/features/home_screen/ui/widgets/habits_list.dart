import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_state.dart';
import 'package:routina/features/home_screen/ui/widgets/habit_card.dart';

class HabitsList extends StatelessWidget {
  const HabitsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // 1. Loading State
        if (state.status == HomeStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        // 2. Empty State
        if (state.habits.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "🚀",
                  style: TextStyle(fontSize: 40.sp),
                ),
                SizedBox(height: 12.h),
                Text(
                  "No habits yet. Start your journey!",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        // 3. Success State (List of Cards)
        return ListView.builder(
          // Using padding to avoid cards touching the screen edges
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          physics: const BouncingScrollPhysics(),
          itemCount: state.habits.length,
          itemBuilder: (context, index) {
            final habit = state.habits[index];
            
            return HabitCard(
              habit: habit,
              // Note: Internal toggling of days is handled inside HabitCard 
              // using context.read<HomeCubit>().toggleDay(...)
            );
          },
        );
      },
    );
  }
}