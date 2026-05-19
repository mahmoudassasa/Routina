import 'package:flutter/material.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';

class NextGetStartedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int currentPage;
  final List<Map<String, String>> pages;

  const NextGetStartedButton({
    super.key,
    required this.onPressed,
    required this.currentPage,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isLastPage = currentPage == pages.length - 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        // Premium Gradient effect
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isDark
              ? [AppColors.primary, AppColors.primary.withBlue(255)]
              : [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        // Glow effect in dark mode, normal shadow in light mode
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Text(
                isLastPage ? context.l10n.getStarted : context.l10n.next,
                key: ValueKey<bool>(isLastPage),
                style: AppTextStyles.labelLarge.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white, // White text looks better on gradients
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
