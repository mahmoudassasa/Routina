import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            currentPage < pages.length - 1 ? 'Next' : 'Get Started',
          ),
        ),
      ),
    );
  }
}