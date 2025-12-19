import 'package:equatable/equatable.dart';

/// Base class for auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Event to login
class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

/// Event to register
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  const RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
  });
  @override
  List<Object?> get props => [email, password, name];
}

/// Event to logout
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Event to check authentication status
class CheckAuthEvent extends AuthEvent {
  const CheckAuthEvent();
}

/// Event to refresh token
class RefreshTokenEvent extends AuthEvent {
  const RefreshTokenEvent();
}

/// Event to request password reset
class ForgotPasswordRequested extends AuthEvent {
  final String email;
  const ForgotPasswordRequested({required this.email});
  @override
  List<Object?> get props => [email];
}

/// Event to verify OTP
class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String token;
  const VerifyOtpRequested({required this.email, required this.token});
  @override
  List<Object?> get props => [email, token];
}

/// Event to verify Email
class VerifyEmailRequested extends AuthEvent {
  final String email;
  final String token;
  const VerifyEmailRequested({required this.email, required this.token});
  @override
  List<Object?> get props => [email, token];
}

/// Event to update password
class UpdatePasswordRequested extends AuthEvent {
  final String password;
  const UpdatePasswordRequested({required this.password});
  @override
  List<Object?> get props => [password];
}
