import 'package:flutter/material.dart';
import '../../../../core/helpers/app_constants.dart';

class HeaderWidget extends StatelessWidget {
  final String userName;
  
  const HeaderWidget({
    super.key,
    required this.userName,
  });
  
  @override
  Widget build(BuildContext context) {
    final List<String> motivationalQuotes = [
      "Small steps lead to big changes.",
      "Progress, not perfection.",
      "Every day is a new beginning.",
      "Consistency is the key to success.",
      "You are capable of amazing things."
    ];
    
    final todayQuote = motivationalQuotes[DateTime.now().weekday % motivationalQuotes.length];
    
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blue50, AppColors.indigo50],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius2xl),
      ),
      padding: const EdgeInsets.all(AppSizes.spacing6),
      margin: const EdgeInsets.only(bottom: AppSizes.spacing6),
      child: Column(
        
        children: [

          Text(
            'Good morning, $userName! 👋',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacing2),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha:0.5),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing4,
              vertical: AppSizes.spacing2,
            ),
            child: Text(
              '"$todayQuote"',
              style: AppTextStyles.quote,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}