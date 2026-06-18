part of 'delete_account_cubit.dart';

enum DeleteAccountStatus { idle, loading, success, error }

class DeleteAccountState {
  final DeleteAccountStatus status;
  final String? errorCode;

  const DeleteAccountState({
    this.status = DeleteAccountStatus.idle,
    this.errorCode,
  });

  DeleteAccountState copyWith({
    DeleteAccountStatus? status,
    String? errorCode,
  }) {
    return DeleteAccountState(
      status: status ?? this.status,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
