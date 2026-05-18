import 'package:equatable/equatable.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/data/models/auth_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// State awal
class AuthInitial extends AuthState {}

/// Sedang memproses login/register biasa
class AuthLoading extends AuthState {}

/// Sedang menunggu callback Google OAuth
class AuthGoogleLoading extends AuthState {}

/// Login/Register berhasil
class AuthSuccess extends AuthState {
  final AuthModel authModel;

  AuthSuccess({required this.authModel});

  @override
  List<Object?> get props => [authModel];
}

/// Auto-login berhasil (session tersimpan valid)
class AuthSessionRestored extends AuthState {
  final AuthModel authModel;

  AuthSessionRestored({required this.authModel});

  @override
  List<Object?> get props => [authModel];
}

/// Tidak ada session tersimpan
class AuthUnauthenticated extends AuthState {}

/// Login/Register gagal
class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
