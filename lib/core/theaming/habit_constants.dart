import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HabitConstants {
  static const List<Color> presetColors = [
    Color(0xFF2563EB), // Blue — Primary
    Color(0xFF7C3AED), // Purple
    Color(0xFFDB2777), // Pink
    Color(0xFFDC2626), // Red
    Color(0xFFEA580C), // Orange
    Color(0xFFD97706), // Amber
    Color(0xFFCA8A04), // Yellow
    Color(0xFF16A34A), // Green
    Color(0xFF0F766E), // Teal
    Color(0xFF0891B2), // Cyan
    Color(0xFF4F46E5), // Indigo
    Color(0xFFBE185D), // Rose
    Color(0xFF15803D), // Dark Green
    Color(0xFF7E22CE), // Dark Purple
    Color(0xFFB45309), // Brown
    Color(0xFF475569), // Slate
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
    'star': Icons.star_rounded,
    'moon': CupertinoIcons.moon_stars_fill,
    'sun': Icons.wb_sunny_rounded,
    'health2': Icons.monitor_heart_rounded,
  };

  static IconData getIcon(String key) {
    return iconsMap[key] ?? Icons.circle;
  }
}