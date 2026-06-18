import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routina/features/app_update_service/ui/app_update_service.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit(this._service) : super(UpdateInitial());

  final AppUpdateService _service;

  Future<void> checkForUpdate(String currentVersion) async {
    try {
      final minVersion = await _service.getMinVersion();
      if (minVersion == null) return;

      if (_isOutdated(currentVersion, minVersion)) {
        emit(UpdateRequired(minVersion: minVersion));
      } else {
        emit(UpdateNotRequired());
      }
    } catch (_) {
      emit(UpdateNotRequired()); // fail silently
    }
  }

  bool _isOutdated(String current, String min) {
    final c = current.split('.').map(int.parse).toList();
    final m = min.split('.').map(int.parse).toList();
    for (int i = 0; i < 3; i++) {
      if (c[i] < m[i]) return true;
      if (c[i] > m[i]) return false;
    }
    return false;
  }
}
