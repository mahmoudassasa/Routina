
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/services/export_service.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

void exportData(BuildContext context) async {
  final homeCubit = context.read<HomeCubit>();
  final habits = homeCubit.state.habits;
  final messenger = ScaffoldMessenger.of(context); 

  try {
    if (habits.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text("No habits to export yet!")),
      );
      return;
    }

    messenger.showSnackBar(
      const SnackBar(content: Text("Preparing data...")),
    );

    await ExportService.exportHabitsToCSV(habits);
    
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}