import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/widgets/home_empty_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_state.dart';
import 'package:routina/features/home_screen/ui/widgets/habit_card.dart';

class HabitsList extends StatelessWidget {
  const HabitsList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return  BlocBuilder<HomeCubit, HomeState>(
  builder: (context, state) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().loadHabits(isRefresh: true),

      child: Builder(
        builder: (_) {
          if (state.status == HomeStatus.loading) {
            return _buildScrollableList(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: 3,
                itemBuilder: (context, index) => _buildShimmerItem(isDark),
              ),
            );
          }

        if (state.habits.isEmpty) {
  return const HomeEmptyState();
}

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: state.habits.length,
            itemBuilder: (context, index) => HabitCard(habit: state.habits[index]),
          );
        },
      ),
    );
  },
);
  }

  Widget _buildScrollableList({required Widget child}) {
    return SizedBox.expand(
      child: child is ListView ? child : ListView(physics: const AlwaysScrollableScrollPhysics(), children: [child]),
    );
  }

  Widget _buildShimmerItem(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        height: 200.h,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
      ),
    );
  }
}