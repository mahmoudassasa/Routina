part of 'habit_card.dart';

extension EditBottomSheet on HabitCard {
  void _showEditBottomSheet(BuildContext context, Map<String, dynamic> habit) {
    final homeCubit = context.read<HomeCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: homeCubit,
        child: CreateHabitBottomSheet(habitToEdit: habit),
      ),
    );
  }
}