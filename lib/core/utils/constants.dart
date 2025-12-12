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
  static String searchBook(String book, {int page = 1, int limit = 10}) {
    String url = Uri.encodeComponent(book);

    return "https://openlibrary.org/search.json?q=$url&page=$page&limit=$limit";
  }

  static String authorWorks(String authorKey) {
    return "https://openlibrary.org/authors/$authorKey/works.json?limit=100";
  }

  static String searchAuthor(String author, {int page = 1, int limit = 10}) {
    String url = Uri.encodeComponent(author);

    return "https://openlibrary.org/search/authors.json?q=$url&offset=$page&limit=$limit";
  }

  static String getAuthorDetail(String authorKey) {
    return "https://openlibrary.org/authors/$authorKey.json";
  }

  static String getBookDetail(String bookOLIDKey) {
    return "https://openlibrary.org/api/books?bibkeys=OLID:$bookOLIDKey&format=json&jscmd=data";
  }

  static String authorPhotoUrl(String authorPhotoKey) {
    return "https://covers.openlibrary.org/a/id/$authorPhotoKey-M.jpg";
  }

  static String bookPhotoUrl(String bookPhotoKey) {
    if (bookPhotoKey.startsWith('/books/')) {
      bookPhotoKey = bookPhotoKey.substring(7, bookPhotoKey.length);
    }
    return "https://covers.openlibrary.org/b/olid/$bookPhotoKey-M.jpg";
  }

  static String coverUrl(String coverId) {
    return "https://covers.openlibrary.org/b/id/$coverId-M.jpg";
  }
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
