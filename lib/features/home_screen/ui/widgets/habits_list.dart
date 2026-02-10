import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_state.dart';
import 'package:routina/features/home_screen/ui/widgets/habit_card.dart';

class HabitsList extends StatelessWidget {
  const HabitsList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              );
            },
          );
        }

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
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          physics: const BouncingScrollPhysics(),
          itemCount: state.habits.length,
          itemBuilder: (context, index) {
            return HabitCard(
              habit: state.habits[index],
            );
          },
        );
      },
    );
  }
}