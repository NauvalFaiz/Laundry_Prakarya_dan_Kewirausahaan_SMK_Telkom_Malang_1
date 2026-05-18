import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:prakarya_dan_kewirausahaan/core/utils/secure_storage.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final SecureStorageService storage;
  StreamSubscription<AuthState>? _authSub;

  AuthBloc({required this.authRepository, required this.storage})
      : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<SupabaseAuthChanged>(_onSupabaseAuthChanged);
    on<CheckSessionRequested>(_onCheckSession);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateProfileRequested>(_onUpdateProfile);

    // Listen ke Supabase auth state changes (untuk OAuth callback)
    _listenToSupabaseAuth();
  }

  void _listenToSupabaseAuth() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        add(SupabaseAuthChanged(session: session));
      }
    });
  }

  // ── Login Email/Phone ──
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result =
          await authRepository.login(event.identifier, event.password);

      if (result.token != null) {
        await storage.saveAccessToken(result.token!);
        await storage.saveUserInfo(
          name: result.user?.name,
          id: result.user?.id,
          email: result.user?.email,
          avatar: result.user?.avatar,
          role: result.user?.role,
        );
      }

      emit(AuthSuccess(authModel: result));
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  // ── Register ──
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

      if (result.token != null) {
        await storage.saveAccessToken(result.token!);
        await storage.saveUserInfo(
          name: result.user?.name,
          id: result.user?.id,
          email: result.user?.email,
          role: result.user?.role,
        );
      }

      emit(AuthSuccess(authModel: result));
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  // ── Google Login (Native Popup) ──
  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthGoogleLoading());
    try {
      // 1. Native login & Supabase session establishment
      final success = await authRepository.loginWithGoogle();
      
      if (success) {
        // 2. Jika berhasil, ambil session yang baru dibuat di Supabase
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          emit(AuthLoading());
          // 3. Sinkronkan dengan Laravel
          final result = await authRepository.syncGoogleUser(session.accessToken);

          if (result.token != null) {
            await storage.saveAccessToken(result.token!);
            await storage.saveUserInfo(
              name: result.user?.name,
              id: result.user?.id,
              email: result.user?.email,
              avatar: result.user?.avatar,
              role: result.user?.role,
            );
          }
          emit(AuthSuccess(authModel: result));
        } else {
          emit(AuthFailure(message: 'Sesi Supabase tidak ditemukan setelah login'));
        }
      } else {
        // User cancel atau gagal login
        emit(AuthInitial()); // Kembali ke state awal jika cancel
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  // ── Supabase Auth Listener (Optional, but useful for global state) ──
  Future<void> _onSupabaseAuthChanged(
    SupabaseAuthChanged event,
    Emitter<AuthState> emit,
  ) async {
    // Kita handle sinkronisasi secara eksplisit di _onGoogleLoginRequested
    // Namun jika ada perubahan sesi diluar flow tersebut, bisa dihandle di sini
  }

  // ── Auto-login (cek session tersimpan) ──
  Future<void> _onCheckSession(
    CheckSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await storage.isLoggedIn();
      if (!isLoggedIn) {
        emit(AuthUnauthenticated());
        return;
      }

      // Verifikasi token masih valid dengan memanggil API
      final result = await authRepository.getProfile();
      emit(AuthSessionRestored(authModel: result));
    } catch (e) {
      // Token expired atau invalid
      await storage.clearAll();
      emit(AuthUnauthenticated());
    }
  }

  // ── Logout ──
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  // ── Update Profile ──
  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.updateProfile(event.name, event.email);
      
      await storage.saveUserInfo(
        name: result.user?.name,
        id: result.user?.id,
        email: result.user?.email,
        avatar: result.user?.avatar,
        role: result.user?.role,
      );

      emit(AuthSuccess(authModel: result));
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
