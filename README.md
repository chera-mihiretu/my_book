# Flutter Clean Architecture Project

A Flutter application built with **feature-based clean architecture** following the **BLoC pattern** for state management.

## 🏗️ Architecture Overview

This project follows a clean architecture approach with clear separation of concerns:

```
UI → BLoC → Repository → RemoteDataSource → API
```

### Architecture Layers

1. **Presentation Layer** - UI components, BLoC, Events, and States
2. **Domain Layer** - Business models and repository interfaces
3. **Data Layer** - Remote data sources and repository implementations
4. **Core Layer** - Shared utilities, error handling, and common widgets
5. **DI Layer** - Dependency injection setup

## 📁 Project Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart          # Custom exception classes
│   │   └── failures.dart            # Failure classes for error handling
│   ├── network/
│   │   ├── api_client.dart          # HTTP client wrapper
│   │   └── network_info.dart        # Network connectivity checker
│   ├── utils/
│   │   └── constants.dart           # App-wide constants
│   └── widgets/
│       └── common_widgets.dart      # Reusable UI components
│
├── di/
│   └── injector.dart                # Dependency injection setup (GetIt)
│
├── features/
│   ├── auth/                        # Authentication feature
│   │   ├── presentation/
│   │   │   ├── bloc/
│   │   │   │   ├── auth_bloc.dart
│   │   │   │   ├── auth_event.dart
│   │   │   │   └── auth_state.dart
│   │   │   └── pages/
│   │   │       ├── login_page.dart
│   │   │       └── register_page.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── data/
│   │       ├── datasources/
│   │       │   └── auth_remote_data_source.dart
│   │       └── repositories/
│   │           └── auth_repository_impl.dart
│   │
│   ├── books/                       # Books feature
│   │   ├── presentation/
│   │   │   ├── bloc/
│   │   │   │   ├── book_bloc.dart
│   │   │   │   ├── book_event.dart
│   │   │   │   └── book_state.dart
│   │   │   └── pages/
│   │   │       ├── book_list_page.dart
│   │   │       └── book_detail_page.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── book_model.dart
│   │   │   └── repositories/
│   │   │       └── book_repository.dart
│   │   └── data/
│   │       ├── datasources/
│   │       │   └── book_remote_data_source.dart
│   │       └── repositories/
│   │           └── book_repository_impl.dart
│   │
│   ├── favorites/                   # Favorites feature
│   │   ├── presentation/
│   │   │   ├── bloc/
│   │   │   │   ├── favorite_bloc.dart
│   │   │   │   ├── favorite_event.dart
│   │   │   │   └── favorite_state.dart
│   │   │   └── pages/
│   │   │       └── favorites_page.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── favorite_model.dart
│   │   │   └── repositories/
│   │   │       └── favorite_repository.dart
│   │   └── data/
│   │       ├── datasources/
│   │       │   └── favorite_remote_data_source.dart
│   │       └── repositories/
│   │           └── favorite_repository_impl.dart
│   │
│   └── reading/                     # Reading feature
│       ├── presentation/
│       │   ├── bloc/
│       │   │   ├── reading_bloc.dart
│       │   │   ├── reading_event.dart
│       │   │   └── reading_state.dart
│       │   └── pages/
│       │       ├── reading_list_page.dart
│       │       └── reading_session_page.dart
│       ├── domain/
│       │   ├── models/
│       │   │   ├── reading_model.dart
│       │   │   └── reading_session_model.dart
│       │   └── repositories/
│       │       └── reading_repository.dart
│       └── data/
│           ├── datasources/
│           │   └── reading_remote_data_source.dart
│           └── repositories/
│               └── reading_repository_impl.dart
│
└── main.dart                        # App entry point
```

## 🔧 Technologies & Packages

### State Management
- **flutter_bloc** (^8.1.3) - BLoC pattern implementation
- **equatable** (^2.0.5) - Value equality for models

### Dependency Injection
- **get_it** (^7.6.4) - Service locator for dependency injection

### Networking
- **http** (^1.1.0) - HTTP client
- **connectivity_plus** (^5.0.2) - Network connectivity checking

### Functional Programming
- **dartz** (^0.10.1) - Functional programming (Either, Option, etc.)

### Local Storage
- **shared_preferences** (^2.2.2) - Key-value storage for tokens and user data

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.10.0)
- Dart SDK (^3.10.0)

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd new_project
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 🏛️ Clean Architecture Principles

### Dependency Rule
Dependencies point inward. Inner layers (domain) know nothing about outer layers (data, presentation).

### Layer Responsibilities

#### 1. Presentation Layer
- **BLoC**: Business logic and state management
- **Events**: User actions and system events
- **States**: UI states (loading, loaded, error, etc.)
- **Pages**: UI screens and widgets

#### 2. Domain Layer
- **Models**: Business entities with JSON serialization
- **Repositories**: Abstract interfaces defining data operations

#### 3. Data Layer
- **Data Sources**: API communication and data fetching
- **Repository Implementations**: Concrete implementations of domain repositories
- **Error Handling**: Converting exceptions to failures

#### 4. Core Layer
- **Error Handling**: Custom exceptions and failures
- **Network**: API client and connectivity checking
- **Utils**: Constants and helper functions
- **Widgets**: Reusable UI components

## 📱 Features

### 1. Authentication
- User login
- User registration
- Token management
- Session persistence

### 2. Books
- Browse books
- Search books
- View book details
- Filter by genre
- Featured books

### 3. Favorites
- Add books to favorites
- Remove from favorites
- View favorite books
- Check favorite status

### 4. Reading
- Start reading a book
- Track reading progress
- Update current page
- Complete reading
- Reading sessions

## 🔐 Error Handling

The app uses a comprehensive error handling system:

### Exceptions (Data Layer)
- `ServerException` - Server errors
- `NetworkException` - Network connectivity issues
- `AuthenticationException` - Authentication failures
- `ValidationException` - Validation errors
- `NotFoundException` - Resource not found
- `TimeoutException` - Request timeouts

### Failures (Domain/Presentation Layer)
- `ServerFailure`
- `NetworkFailure`
- `AuthenticationFailure`
- `ValidationFailure`
- `NotFoundFailure`
- `TimeoutFailure`
- `UnexpectedFailure`

## 🎨 UI Components

### Common Widgets
- `LoadingIndicator` - Loading state display
- `ErrorDisplay` - Error state with retry option
- `EmptyState` - Empty list state
- `CommonAppBar` - Reusable app bar
- `CommonTextField` - Styled text input
- `CommonButton` - Styled button with loading state

## 🔄 State Management Flow

```
User Action → Event → BLoC → Repository → Data Source → API
                ↓
            State Update
                ↓
            UI Rebuild
```

## 📝 API Configuration

Update the base URL in `lib/core/utils/constants.dart`:

```dart
static const String baseUrl = 'https://your-api-url.com';
```

## 🧪 Testing

The architecture makes testing easy:
- **Unit Tests**: Test BLoCs, repositories, and models
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete features

## 📄 License

This project is licensed under the MIT License.

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For support, email your-email@example.com or open an issue in the repository.
