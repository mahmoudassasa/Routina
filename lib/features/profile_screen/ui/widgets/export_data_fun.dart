import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/features/export_service/ui/export_service.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';

void exportData(BuildContext context) async {
  final homeCubit = context.read<HomeCubit>();
  final habits = homeCubit.state.habits;
  final messenger = ScaffoldMessenger.of(context);
  final noHabitsMsg = context.l10n.noHabitsToExport;
  final preparingMsg = context.l10n.preparingData;

  try {
    if (habits.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(noHabitsMsg)));
      return;
    }
    messenger.showSnackBar(SnackBar(content: Text(preparingMsg)));
    await ExportService.exportHabitsToCSV(habits);
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  }
}
