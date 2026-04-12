import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_state.dart';
import 'package:routina/features/home_screen/ui/widgets/habit_card.dart';

class HabitsList extends StatelessWidget {
  const HabitsList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(

      onRefresh: () async{await Future.wait([
      context.read<HomeCubit>().loadHabits(isRefresh: true),
      Future.delayed(const Duration(seconds: 2)),
    ]);},
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          
        
          if (state.status == HomeStatus.loading) {
            return _buildScrollableList(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: 3,
                itemBuilder: (context, index) => _buildShimmerItem(isDark),
              ),
            );
          }

          // حالة الـ Empty
          if (state.habits.isEmpty) {
            return _buildScrollableList(
              child: ListView( // حولناها لـ ListView عشان تقبل السحب
                children: [
                  SizedBox(height: 200.h), 
                  Center(child: Text("🚀 No habits yet!", style: TextStyle(fontSize: 16.sp))),
                ],
              ),
            );
          }

          // حالة الـ Loaded (البيانات موجودة)
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            // "AlwaysScrollable" دي هي اللي بتضمن إن الأندرويد يحس بالسحبة حتى لو الليستة مش طويلة
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: state.habits.length,
            itemBuilder: (context, index) => HabitCard(habit: state.habits[index]),
          );
        },
      ),
    );
  }

  // دالة مساعدة عشان نضمن إن أي حالة بتدعم السكرول
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