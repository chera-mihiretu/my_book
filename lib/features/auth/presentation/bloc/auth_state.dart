import 'package:equatable/equatable.dart';
import '../../domain/models/user_model.dart';

/// Base class for auth states
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state
class Authenticated extends AuthState {
  final UserModel user;
  const Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Error state
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

/// Registration success state
class RegistrationSuccess extends AuthState {
  final UserModel user;
  const RegistrationSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

/// Logout success state
class LogoutSuccess extends AuthState {
  const LogoutSuccess();
}

/// Password reset email sent state
class PasswordResetEmailSent extends AuthState {
  const PasswordResetEmailSent();
}

/// OTP verified state
class OtpVerified extends AuthState {
  const OtpVerified();
}

/// Email verified state
class EmailVerified extends AuthState {
  const EmailVerified();
}

/// Password updated state
class PasswordUpdated extends AuthState {
  const PasswordUpdated();
}
