import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Auth BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final ResetPasswordUseCase resetPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;

  AuthBloc({
    required this.authRepository,
    required this.resetPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.verifyEmailUseCase,
    required this.updatePasswordUseCase,
  }) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<VerifyEmailRequested>(_onVerifyEmailRequested);
    on<UpdatePasswordRequested>(_onUpdatePasswordRequested);
  }

  /// Handle login event
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await authRepository.login(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  /// Handle register event
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await authRepository.register(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(RegistrationSuccess(user)),
    );
  }

  /// Handle logout event
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await authRepository.logout();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  /// Handle check auth event
  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: Implement check auth handler
  }

  /// Handle refresh token event
  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: Implement refresh token handler
  }

  /// Handle forgot password requested event
  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await resetPasswordUseCase(email: event.email);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const PasswordResetEmailSent()),
    );
  }

  /// Handle verify otp requested event
  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await verifyOtpUseCase(
      email: event.email,
      token: event.token,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const OtpVerified()),
    );
  }

  /// Handle verify email requested event
  Future<void> _onVerifyEmailRequested(
    VerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await verifyEmailUseCase(
      email: event.email,
      token: event.token,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const EmailVerified()),
    );
  }

  /// Handle update password requested event
  Future<void> _onUpdatePasswordRequested(
    UpdatePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await updatePasswordUseCase(password: event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const PasswordUpdated()),
    );
  }
}
