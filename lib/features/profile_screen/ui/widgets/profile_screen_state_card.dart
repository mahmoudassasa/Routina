import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/theaming/app_colors.dart';

class StatCard extends StatelessWidget { 
final String icon; 
final String title; 
final String value; 

const StatCard({ 
super.key, 
required this.icon, 
required this.title, 
required this.value, 
}); 

@override 
Widget build(BuildContext context) { 
final isDark = Theme.of(context).brightness == Brightness.dark; 

return Container(
padding: EdgeInsets.all(16.w), // Use .w
decoration: BoxDecoration(
color: isDark ? AppColors.darkSurface : AppColors.surface,
borderRadius: BorderRadius.circular(16.r), // Use .r

// ...The Shadow and Border are as they are...

),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Text(icon, style: TextStyle(fontSize: 24.sp)), // Use .sp
SizedBox(height: 8.h),
Text(
value,
style: TextStyle(
fontSize: 16.sp, // I made it a little smaller in case the number is too large
fontWeight: FontWeight.bold,
color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, 
), 
), 
SizedBox(height: 4.h), 
Text( 
title, 
style:TextStyle( 
fontSize: 11.sp, 
color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, 
), 
textAlign: TextAlign.center, 
), 
], 
), 
); 
}
}