import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:routina/core/theaming/app_colors.dart';

class HabitConstants {
  static const List<Color> presetColors = [
    AppColors.primary,
    Color(0xFFE11D48), // Rose Red أنعم
    Color(0xFF4ECDC4), // Teal
    Color(0xFFFFE066), // Pastel Yellow
    Color(0xFFA663CC), // Purple
    Color(0xFF3B82F6), // Blue Accent (بدل البرتقالي)
    Color(0xFF2EC4B6), // Aqua
    Color(0xFF6C5CE7), // Indigo
    Color(0xFF00D2FF), // Sky Blue
    Color(0xFF55EFC4), // Mint
    Color(0xFFFD79A8), // Pink
    Color(0xFFFDCB6E), // Soft Orange
    Color(0xFFE17055), // Coral
    Color(0xFF74B9FF), // Light Blue
    Color(0xFFA29BFE), // Lavender
    Color(0xFF00B894), // Green
    Color(0xFFE84393), // Magenta
    Color(0xFF0984E3), // Deep Blue
    Color(0xFF00CEC9), // Cyan
    Color(0xFFFF6B81), // Soft Red بدل الأحمر الفاقع
    Color(0xFFFF9F1C), // Warm Orange
    Color(0xFFFED330), // Soft Yellow
    Color(0xFF16A085), // Dark Teal
    Color(0xFF27AE60), // Emerald
    Color(0xFF2980B9), // Navy Blue
    Color(0xFF8E44AD), // Deep Purple
    Color(0xFFBB8FCE), // Lilac
    Color(0xFFF4D03F), // Gold
    Color(0xFF73C6B6), // Aqua Pastel
    Color(0xFF566573), // Grayish Blue
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
    'game': Icons.sports_esports_rounded,
    'prayer': Icons.mosque_rounded,
    'work': Icons.work_rounded,
    'clean': Icons.cleaning_services_rounded,
    'pet': Icons.pets_rounded,
    'social': Icons.people_rounded,
    'exercise': Icons.fitness_center_rounded,
    'yoga': Icons.self_improvement_rounded,
    'walk': Icons.directions_walk_rounded,
    'bike': Icons.directions_bike_rounded,
    'swim': Icons.pool_rounded,
    'gym': Icons.sports_gymnastics_rounded,
    'coffee': Icons.local_cafe_rounded,
    'tea': Icons.emoji_food_beverage_rounded,
    'vitamin': Icons.medication_rounded,
    'health': Icons.favorite_rounded,
    'doctor': Icons.local_hospital_rounded,
    'therapy': Icons.healing_rounded,
    'mindfulness': Icons.psychology_rounded,
    'gratitude': Icons.favorite_border_rounded,
    'affirmation': Icons.format_quote_rounded,
    'stretch': Icons.accessibility_new_rounded,
    'dance': Icons.music_note_rounded,
    'sing': Icons.mic_rounded,
    'guitar': Icons.piano_rounded,
    'piano': Icons.piano_rounded,
    'write': Icons.create_rounded,
    'blog': Icons.article_rounded,
    'podcast': Icons.headphones_rounded,
    'language': Icons.language_rounded,
    'course': Icons.menu_book_rounded,
    'skill': Icons.build_rounded,
    'project': Icons.folder_rounded,
    'meeting': Icons.groups_rounded,
    'call': Icons.phone_rounded,
    'email': Icons.email_rounded,
    'social_media': Icons.share_rounded,
    'family': Icons.family_restroom_rounded,
    'friend': Icons.person_add_rounded,
    'date': Icons.favorite_rounded,
    'cooking': Icons.restaurant_menu_rounded,
    'baking': Icons.cake_rounded,
    'grocery': Icons.shopping_cart_rounded,
    'budget': Icons.account_balance_wallet_rounded,
    'save': Icons.savings_rounded,
    'invest': Icons.trending_up_rounded,
    'garden': Icons.local_florist_rounded,
    'plant': Icons.eco_rounded,
    'nature': Icons.park_rounded,
    'photography': Icons.camera_alt_rounded,
    'video': Icons.videocam_rounded,
    'draw': Icons.brush_rounded,
    'paint': Icons.format_paint_rounded,
    'craft': Icons.build_circle_rounded,
    'organize': Icons.inventory_2_rounded,
    'declutter': Icons.delete_outline_rounded,
    'laundry': Icons.local_laundry_service_rounded,
    'shopping': Icons.shopping_bag_rounded,
    'car': Icons.directions_car_rounded,
    'commute': Icons.train_rounded,
    'travel': Icons.flight_rounded,
    'explore': Icons.explore_rounded,
    'adventure': Icons.terrain_rounded,
    'hiking': Icons.landscape_rounded,
    'camping': Icons.cabin_rounded,
    'beach': Icons.beach_access_rounded,
    'sunset': Icons.wb_twilight_rounded,
    'sunrise': Icons.wb_sunny_rounded,
    'weather': Icons.wb_cloudy_rounded,
    'star': Icons.star_rounded,
    'moon': CupertinoIcons.moon_stars_fill,
    'sun': Icons.wb_sunny_rounded,
    'cloud': Icons.cloud_rounded,
    'rain': Icons.grain_rounded,
    'snow': Icons.ac_unit_rounded,
  };

  static IconData getIcon(String key) {
    return iconsMap[key] ?? Icons.circle;
  }
}
