import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:routina/core/theaming/app_colors.dart';

class HabitConstants {
  static const List<Color> presetColors = [
    AppColors.primary,
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFBE0B),
    Color(0xFFA663CC),
    Color(0xFFFF9F1C),
    Color(0xFF2EC4B6),
  ];

  static const Map<String, IconData> iconsMap = {
    'sport': Icons.directions_run_rounded,
    'water': Icons.water_drop_rounded,
    'read': CupertinoIcons.book_fill,
    'sleep': CupertinoIcons.moon_fill,
    'meditate': Icons.self_improvement_rounded,
    'code': Icons.code_rounded,
    'money': Icons.attach_money_rounded,
    'study': Icons.school_rounded,
    'food': Icons.restaurant_rounded,
    'art': Icons.palette_rounded,
    'music': CupertinoIcons.music_note_2,
    'time': Icons.access_time_filled_rounded,
    'journal': Icons.edit_note_rounded,
    'idea': Icons.lightbulb_rounded,
    
    // New Icons
    'game': Icons.sports_esports_rounded,       // Gaming
    'prayer': Icons.mosque_rounded,             // Prayer/Religion
    'work': Icons.work_rounded,                 // Work
    'clean': Icons.cleaning_services_rounded,   // Chores
    'pet': Icons.pets_rounded,                  // Pet care
    'social': Icons.people_rounded,             // Socializing
  };

  static IconData getIcon(String key) {
    return iconsMap[key] ?? Icons.circle;
  }
}