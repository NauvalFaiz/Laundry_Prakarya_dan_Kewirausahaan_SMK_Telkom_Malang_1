import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.login(event.identifier, event.password);
      emit(AuthSuccess(authModel: result));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.register(
        event.name,
        event.identifier,
        event.password,
      );
      emit(AuthSuccess(authModel: result));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
