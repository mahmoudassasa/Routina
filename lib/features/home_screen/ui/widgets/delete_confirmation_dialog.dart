part of 'habit_card.dart';

extension DeleteConfirmationDialog on HabitCard {
  Future<bool?> _showDeleteConfirmationDialog(
    BuildContext context,
    String habitTitle,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1A1C23) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            context.l10n.deleteHabit,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          content: Text(
            context.l10n.deleteHabitConfirm(habitTitle),
            style: TextStyle(
              fontSize: 15.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(
                context.l10n.cancel,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                context.l10n.delete,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
