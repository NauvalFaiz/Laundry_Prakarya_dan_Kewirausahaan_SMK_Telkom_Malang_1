import 'package:equatable/equatable.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/data/models/auth_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthModel authModel;

  AuthSuccess({required this.authModel});

  @override
  List<Object?> get props => [authModel];
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
