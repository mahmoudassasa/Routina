import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/create_habit/ui/create_habit_bottom_sheet.dart';
import 'package:routina/features/analyze_screen/logic/cubit/ai_analysis_cubit.dart';
import 'package:routina/features/analyze_screen/ui/widgets/ai_analysis_full_screen.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

class FloatingHomeButtons extends StatelessWidget {
  const FloatingHomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_buildAiButton(context), _buildAddButton(context)],
      ),
    );
  }

 Widget _buildAiButton(BuildContext context) {
  return Container(
    height: 65.w,
    width: 65.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.4),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: FloatingActionButton(
      heroTag: 'ai_button',
      onPressed: () {
        final habits = context.read<HomeCubit>().state.habits;
        
        if (habits.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add some habits first!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => AiAnalysisCubit()..analyzeHabits(habits),
              child: const AiAnalysisFullScreen(),
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const CircleBorder(),
      child: Text('🤖', style: TextStyle(fontSize: 30.sp)),
    ),
  );
}

  Widget _buildAddButton(BuildContext context) {
    return Container(
      height: 65.w,
      width: 65.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: 'add_button',
        onPressed: () {
          final homeCubit = context.read<HomeCubit>();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => BlocProvider.value(
              value: homeCubit,
              child: const CreateHabitBottomSheet(),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: Icon(Icons.add_rounded, color: Colors.white, size: 34.sp),
      ),
    );
  }
}
