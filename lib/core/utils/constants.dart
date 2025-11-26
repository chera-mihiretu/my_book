/// Application constants
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);

  // App Info
  static const String appName = 'My App';
  static const String appVersion = '1.0.0';
}

/// API Endpoints
class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Books
  static const String books = '/books';
  static String bookDetail(String id) => '/books/$id';

  // Favorites
  static const String favorites = '/favorites';
  static String addFavorite(String bookId) => '/favorites/$bookId';
  static String removeFavorite(String bookId) => '/favorites/$bookId';

  // Reading
  static const String readingList = '/reading';
  static const String readingSessions = '/reading/sessions';
  static String readingSession(String id) => '/reading/sessions/$id';
}

/// Error Messages
class ErrorMessages {
  static const String networkError = 'Please check your internet connection';
  static const String serverError =
      'Something went wrong. Please try again later';
  static const String authenticationError = 'Please login to continue';
  static const String validationError = 'Please check your input';
  static const String notFoundError = 'The requested resource was not found';
  static const String timeoutError = 'Request timeout. Please try again';
  static const String unexpectedError = 'An unexpected error occurred';
}

/// Success Messages
class SuccessMessages {
  static const String loginSuccess = 'Login successful';
  static const String registerSuccess = 'Registration successful';
  static const String logoutSuccess = 'Logout successful';
  static const String bookAddedToFavorites = 'Book added to favorites';
  static const String bookRemovedFromFavorites = 'Book removed from favorites';
  static const String readingSessionStarted = 'Reading session started';
  static const String readingSessionEnded = 'Reading session ended';
}
