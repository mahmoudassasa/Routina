import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool loading;
  final String? name;
  final String? email;
  final String? imageUrl;
  final String? errorMessage;

  const ProfileState({
    this.loading = false,
    this.name,
    this.email,
    this.imageUrl,
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? loading,
    String? name,
    String? email,
    String? imageUrl,
    String? errorMessage,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [loading, name, email, imageUrl, errorMessage];
}
