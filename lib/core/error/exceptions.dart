/// Base exception class for all custom exceptions
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});
}

/// Exception thrown when there's a server error
class ServerException extends AppException {
  ServerException([super.message = 'Server error occurred']);
}

/// Exception thrown when there's a network/connection error
class NetworkException extends AppException {
  NetworkException([super.message = 'Network error occurred']);
}

/// Exception thrown when there's a cache error
class CacheException extends AppException {
  CacheException([super.message = 'Cache error occurred']);
}

/// Exception thrown when authentication fails
class AuthenticationException extends AppException {
  AuthenticationException([super.message = 'Authentication failed']);
}

/// Exception thrown when authorization fails
class AuthorizationException extends AppException {
  AuthorizationException([super.message = 'Authorization failed']);
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException([super.message = 'Validation failed', this.errors]);
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  NotFoundException([super.message = 'Resource not found']);
}

/// Exception thrown when there's a timeout
class TimeoutException extends AppException {
  TimeoutException([super.message = 'Request timeout']);
}
