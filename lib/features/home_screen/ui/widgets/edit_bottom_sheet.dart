part of 'habit_card.dart';

extension EditBottomSheet on HabitCard {
  void _showEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateHabitBottomSheet(
        habitToEdit: habit,
      ),
    );
  }
}