part of 'feature_bottom_sheet.dart';

class _MaybeLaterButton extends StatelessWidget {
  const _MaybeLaterButton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextButton(
      onPressed: () => context.pop(),
      child: Text(
        context.l10n.maybeLater,
        style: TextStyle(
          fontSize: 14.sp,
          color: isDark ? Colors.grey[500] : Colors.grey[600],
        ),
      ),
    );
  }
}
