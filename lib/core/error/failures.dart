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
  const ServerFailure([String message = 'Server error occurred', String? code])
    : super(message, code: code);
}

/// Failure when there's a network/connection error
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred'])
    : super(message);
}

/// Failure when there's a cache error
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred'])
    : super(message);
}

/// Failure when authentication fails
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Authentication failed'])
    : super(message);
}

/// Failure when authorization fails
class AuthorizationFailure extends Failure {
  const AuthorizationFailure([String message = 'Authorization failed'])
    : super(message);
}

/// Failure when validation fails
class ValidationFailure extends Failure {
  final Map<String, String>? errors;
  const ValidationFailure([String message = 'Validation failed', this.errors])
    : super(message);
  @override
  List<Object?> get props => [message, code, errors];
}

/// Failure when a resource is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found'])
    : super(message);
}

/// Failure when there's a timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure([String message = 'Request timeout']) : super(message);
}

/// Failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'An unexpected error occurred'])
    : super(message);
}
