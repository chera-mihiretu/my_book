/// Base exception class for all custom exceptions
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});
}

/// Exception thrown when there's a server error
class ServerException extends AppException {
  ServerException([String message = 'Server error occurred']) : super(message);
}

/// Exception thrown when there's a network/connection error
class NetworkException extends AppException {
  NetworkException([String message = 'Network error occurred'])
    : super(message);
}

/// Exception thrown when there's a cache error
class CacheException extends AppException {
  CacheException([String message = 'Cache error occurred']) : super(message);
}

/// Exception thrown when authentication fails
class AuthenticationException extends AppException {
  AuthenticationException([String message = 'Authentication failed'])
    : super(message);
}

/// Exception thrown when authorization fails
class AuthorizationException extends AppException {
  AuthorizationException([String message = 'Authorization failed'])
    : super(message);
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException([String message = 'Validation failed', this.errors])
    : super(message);
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  NotFoundException([String message = 'Resource not found']) : super(message);
}

/// Exception thrown when there's a timeout
class TimeoutException extends AppException {
  TimeoutException([String message = 'Request timeout']) : super(message);
}
