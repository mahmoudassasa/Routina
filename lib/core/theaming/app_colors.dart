import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (تغيير لأزرق ملكي أكثر عصرية)
  static const Color primary = Color(0xFF2563EB); // Blue 600 (أقوى من السابق)
  static const Color primaryLight = Color(0xFF60A5FA); // Blue 400
  static const Color primaryDark = Color(0xFF1E40AF); // Blue 800
  static const Color primaryLighter = Color(0xFFDBEAFE); // Blue 100 (للخلفيات الخفيفة)

  // Accent Colors (جديد: لون برتقالي مرجاني لكسر الملل وجذب الانتباه)
  static const Color accent = Color(0xFFFF7D54); 
  static const Color accentLight = Color(0xFFFFDBC8);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF); 
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50 (أهدأ من السابق)
  
  // Gradients (تعديل طفيف ليكون ناعماً)
  static const Color backgroundGradientStart = Color(0xFFF0F9FF); 
  static const Color backgroundGradientEnd = Color(0xFFE0F2FE); 

  // Text Colors (تحسين التباين للقراءة)
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900 (أسود مائل للكحلي)
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textLight = Color(0xFF94A3B8); // Slate 400
  static const Color textWhite = Color(0xFFFFFFFF); 

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF1F5F9); // Slate 100

  // Error Colors
  static const Color error = Color(0xFFDC2626); // Red 600
  static const Color errorLight = Color(0xFFFEF2F2); 
  
  // Success Colors
  static const Color success = Color(0xFF059669); // Emerald 600
  static const Color successLight = Color(0xFFECFDF5); 

  // Warning Colors
  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color warningLight = Color(0xFFFFFBEB);

  // Border Colors
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color borderFocus = Color(0xFF2563EB); // نفس لون الـ Primary
}