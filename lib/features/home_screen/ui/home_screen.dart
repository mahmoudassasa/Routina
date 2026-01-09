import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/widgets/create_habit/ui/create_habit_bottom_sheet.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/ui/widgets/ai_analyze_button.dart';
import 'package:routina/features/home_screen/ui/widgets/habits_list.dart';
import 'package:routina/features/home_screen/ui/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackgroundGradientStart,
                  AppColors.darkBackgroundGradientEnd,
                ]
              : [
                  AppColors.backgroundGradientStart,
                  AppColors.backgroundGradientEnd,
                ],
        ),
      ),
      child: Scaffold(
        // Add this inside the Scaffold in HomeScreen
        floatingActionButton: Container(
          height: 60.w,
          width: 60.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              // بنحفظ الـ cubit في متغير قبل ما نفتح الشيت
              final homeCubit = context.read<HomeCubit>();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => BlocProvider.value(
                  value:
                      homeCubit, // بنقول للـ Bottom Sheet: خد الـ Cubit ده معاك
                  child: const CreateHabitBottomSheet(),
                ),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: CircleBorder(),
            child: Icon(Icons.add_rounded, color: Colors.white, size: 32.sp),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              HomeHeader(),
              Expanded(child: HabitsList()),
              AiAnalyzeButton(),
            ],
          ),
        ),
      ),
    );
  }
}
