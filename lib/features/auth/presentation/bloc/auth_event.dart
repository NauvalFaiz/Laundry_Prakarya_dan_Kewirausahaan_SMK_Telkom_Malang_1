import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Session;

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Login dengan email/phone + password
class LoginRequested extends AuthEvent {
  final String identifier;
  final String password;

  LoginRequested({required this.identifier, required this.password});

  @override
  List<Object?> get props => [identifier, password];
}

/// Register akun baru
class RegisterRequested extends AuthEvent {
  final String name;
  final String identifier;
  final String password;

  RegisterRequested({
    required this.name,
    required this.identifier,
    required this.password,
  });

  @override
  List<Object?> get props => [name, identifier, password];
}

/// Login dengan Google OAuth via Supabase
class GoogleLoginRequested extends AuthEvent {}

/// Dipanggil saat Supabase auth state berubah (callback dari OAuth)
class SupabaseAuthChanged extends AuthEvent {
  final Session? session;

  SupabaseAuthChanged({this.session});

  @override
  List<Object?> get props => [session];
}

/// Cek session tersimpan saat app dibuka (auto-login)
class CheckSessionRequested extends AuthEvent {}

/// Logout
class LogoutRequested extends AuthEvent {}

/// Update Profile
class UpdateProfileRequested extends AuthEvent {
  final String name;
  final String email;

  UpdateProfileRequested({required this.name, required this.email});

  @override
  List<Object?> get props => [name, email];
}

