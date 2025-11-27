import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  const Failure(this.message, {this.code});
  @override
  List<Object?> get props => [message, code];
}

/// Failure when there's a server error
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred', String? code])
    : super(code: code);
}

/// Failure when there's a network/connection error
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

/// Failure when there's a cache error
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Failure when authentication fails
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Authentication failed']);
}

/// Failure when authorization fails
class AuthorizationFailure extends Failure {
  const AuthorizationFailure([super.message = 'Authorization failed']);
}

/// Failure when validation fails
class ValidationFailure extends Failure {
  final Map<String, String>? errors;
  const ValidationFailure([super.message = 'Validation failed', this.errors]);
  @override
  List<Object?> get props => [message, code, errors];
}

/// Failure when a resource is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Failure when there's a timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']);
}

/// Failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
