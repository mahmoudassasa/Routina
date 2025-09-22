import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_colors.dart';


class PageIndicators extends StatefulWidget {
  final int currentPage;
  final List<Map<String, String>> pages;

  const PageIndicators({
    super.key,
    required this.currentPage,
    required this.pages,
  });

  @override
  State<PageIndicators> createState() => _PageIndicatorsState();
}

class _PageIndicatorsState extends State<PageIndicators> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.pages.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: widget.currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.currentPage == index
                ? AppColors.primary
                : AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}