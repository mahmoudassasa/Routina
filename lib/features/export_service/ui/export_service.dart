import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:routina/core/helpers/habit_keys.dart';

class ExportService {
  static Future<void> exportHabitsToCSV(
    List<Map<String, dynamic>> habits,
  ) async {
    try {
      List<List<dynamic>> rows = [];

      // 1. Add Headers for the Excel file
      rows.add([
        "Habit Title",
        "Progress (%)",
        "Current Streak",
        "Scheduled Days Count",
        "Completed Days Count",
      ]);

      // 2. Add the data dynamically
      for (var habit in habits) {
        final progress = (habit[HabitKeys.progress] ?? 0.0) as double;
        final progressPercentage = (progress * 100).toStringAsFixed(1);

        rows.add([
          habit[HabitKeys.title] ?? "Unknown",
          "$progressPercentage%",
          habit[HabitKeys.streak] ?? 0,
          _countActiveDays(habit[HabitKeys.frequency]),
          _countActiveDays(habit[HabitKeys.weekProgress]),
        ]);
      }

      // 3. Convert rows to CSV format
      String csvData = const ListToCsvConverter().convert(rows);

      // 4. Save to a temporary directory
      final directory = await getExternalStorageDirectory();
      final path = '${directory!.path}/routina_habits_data.csv';
      final file = File(path);
      await file.writeAsString(csvData);

      // 5. Trigger the native share dialog
      await Share.shareXFiles([
        XFile(path),
      ], text: 'Here is my habit tracking data from Routina!');
    } catch (e) {
      throw Exception("Failed to export data: $e");
    }
  }

  // Helper method to count true values in a boolean list
  static String _countActiveDays(dynamic list) {
    if (list is! List) return "0";
    int count = list.where((day) => day == true).length;
    return count.toString();
  }
}
