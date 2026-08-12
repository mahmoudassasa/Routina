import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/features/app_update_service/ui/app_update_service.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit(this._service) : super(UpdateInitial());

  final AppUpdateService _service;

  Future<void> checkForUpdate(String currentVersion) async {
    try {
      final minVersion = await _service.getMinVersion();
      if (minVersion == null || minVersion.trim().isEmpty) return;

      if (_isOutdated(currentVersion, minVersion)) {
        emit(UpdateRequired(minVersion: minVersion));
      } else {
        emit(UpdateNotRequired());
      }
    } catch (_) {
      emit(UpdateNotRequired()); // Fail silently on network or unexpected errors
    }
  }

  bool _isOutdated(String current, String min) {
    try {
      // Clean build numbers (e.g., "1.0.1+5" -> "1.0.1") and spaces
      final cleanCurrent = current.split('+').first.trim();
      final cleanMin = min.split('+').first.trim();

      // Safely parse integers
      final cParts = cleanCurrent
          .split('.')
          .map((e) => int.tryParse(e.trim()) ?? 0)
          .toList();
      final mParts = cleanMin
          .split('.')
          .map((e) => int.tryParse(e.trim()) ?? 0)
          .toList();

      final maxLength = cParts.length > mParts.length ? cParts.length : mParts.length;

      for (int i = 0; i < maxLength; i++) {
        final cVal = i < cParts.length ? cParts[i] : 0;
        final mVal = i < mParts.length ? mParts[i] : 0;

        if (cVal < mVal) return true;
        if (cVal > mVal) return false;
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}