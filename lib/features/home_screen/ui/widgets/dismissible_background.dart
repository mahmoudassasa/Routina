part of 'habit_card.dart';

extension DismissibleBackground on HabitCard {
  Widget _buildDismissibleBackground(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(24.r),
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline, color: Colors.white, size: 32.sp),
          verticalSpace(8),
          Text(
            context.l10n.delete,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
