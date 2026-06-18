// lib/core/update/cubit/update_state.dart

part of 'update_cubit.dart';

abstract class UpdateState {}

class UpdateInitial extends UpdateState {}

class UpdateRequired extends UpdateState {
  final String minVersion;
  UpdateRequired({required this.minVersion});
}

class UpdateNotRequired extends UpdateState {}
