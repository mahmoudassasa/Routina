import 'dart:io';

enum RegisterStatus { initial, loading, success, error }
enum ImageUploadStatus { initial, picking, uploading, success, error }

class RegisterState {
  final RegisterStatus status;
  final String? errorMessage;
  final File? localImage;//Chosen image from device
  final String? imageUrl; //Upload link from  Supabase
  final ImageUploadStatus imageStatus;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.localImage,
    this.imageUrl,
    this.imageStatus = ImageUploadStatus.initial,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    File? localImage,
    String? imageUrl,
    ImageUploadStatus? imageStatus,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      localImage: localImage ?? this.localImage,
      imageUrl: imageUrl ?? this.imageUrl,
      imageStatus: imageStatus ?? this.imageStatus,
    );
  }
}
