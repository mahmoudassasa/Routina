part of '../email_confirmation_screen.dart';

class _Background extends StatelessWidget {
  final bool isDark;

  const _Background({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? const Color(0xFF1A1A1A) : AppColors.backgroundGradientStart,
            isDark ? Colors.black : AppColors.backgroundGradientEnd,
          ],
        ),
      ),
    );
  }
}