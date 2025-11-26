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
