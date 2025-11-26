# Quick Start Guide - Adding New Features

## 🚀 How to Add a New Feature

Follow this step-by-step guide to add a new feature following the clean architecture pattern.

### Example: Adding a "Reviews" Feature

---

## Step 1: Create Feature Directory Structure

```bash
lib/features/reviews/
├── data/
│   ├── datasources/
│   │   └── review_remote_data_source.dart
│   └── repositories/
│       └── review_repository_impl.dart
├── domain/
│   ├── models/
│   │   └── review_model.dart
│   └── repositories/
│       └── review_repository.dart
└── presentation/
    ├── bloc/
    │   ├── review_bloc.dart
    │   ├── review_event.dart
    │   └── review_state.dart
    └── pages/
        ├── reviews_page.dart
        └── add_review_page.dart
```

---

## Step 2: Create Domain Layer

### 2.1 Create Model (`review_model.dart`)

```dart
import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String id;
  final String bookId;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, bookId, userId, userName, rating, comment, createdAt];
}
```

### 2.2 Create Repository Interface (`review_repository.dart`)

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/review_model.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<ReviewModel>>> getReviews(String bookId);
  Future<Either<Failure, ReviewModel>> addReview({
    required String bookId,
    required int rating,
    required String comment,
  });
  Future<Either<Failure, void>> deleteReview(String reviewId);
}
```

---

## Step 3: Create Data Layer

### 3.1 Create Remote Data Source (`review_remote_data_source.dart`)

```dart
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getReviews(String bookId);
  Future<ReviewModel> addReview({
    required String bookId,
    required int rating,
    required String comment,
  });
  Future<void> deleteReview(String reviewId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiClient apiClient;

  ReviewRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ReviewModel>> getReviews(String bookId) async {
    try {
      final response = await apiClient.get('/books/$bookId/reviews');
      return (response['data'] as List)
          .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get reviews: $e');
    }
  }

  @override
  Future<ReviewModel> addReview({
    required String bookId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await apiClient.post(
        '/books/$bookId/reviews',
        body: {
          'rating': rating,
          'comment': comment,
        },
      );
      return ReviewModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ServerException('Failed to add review: $e');
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      await apiClient.delete('/reviews/$reviewId');
    } catch (e) {
      throw ServerException('Failed to delete review: $e');
    }
  }
}
```

### 3.2 Create Repository Implementation (`review_repository_impl.dart`)

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/models/review_model.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ReviewModel>>> getReviews(String bookId) async {
    try {
      final reviews = await remoteDataSource.getReviews(bookId);
      return Right(reviews);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewModel>> addReview({
    required String bookId,
    required int rating,
    required String comment,
  }) async {
    try {
      final review = await remoteDataSource.addReview(
        bookId: bookId,
        rating: rating,
        comment: comment,
      );
      return Right(review);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    try {
      await remoteDataSource.deleteReview(reviewId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
```

---

## Step 4: Create Presentation Layer

### 4.1 Create Events (`review_event.dart`)

```dart
import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();
  @override
  List<Object?> get props => [];
}

class LoadReviewsEvent extends ReviewEvent {
  final String bookId;
  const LoadReviewsEvent(this.bookId);
  @override
  List<Object?> get props => [bookId];
}

class AddReviewEvent extends ReviewEvent {
  final String bookId;
  final int rating;
  final String comment;
  
  const AddReviewEvent({
    required this.bookId,
    required this.rating,
    required this.comment,
  });
  
  @override
  List<Object?> get props => [bookId, rating, comment];
}

class DeleteReviewEvent extends ReviewEvent {
  final String reviewId;
  const DeleteReviewEvent(this.reviewId);
  @override
  List<Object?> get props => [reviewId];
}
```

### 4.2 Create States (`review_state.dart`)

```dart
import 'package:equatable/equatable.dart';
import '../../domain/models/review_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();
  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

class ReviewLoading extends ReviewState {
  const ReviewLoading();
}

class ReviewsLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  const ReviewsLoaded(this.reviews);
  @override
  List<Object?> get props => [reviews];
}

class ReviewAdded extends ReviewState {
  final ReviewModel review;
  const ReviewAdded(this.review);
  @override
  List<Object?> get props => [review];
}

class ReviewDeleted extends ReviewState {
  const ReviewDeleted();
}

class ReviewError extends ReviewState {
  final String message;
  const ReviewError(this.message);
  @override
  List<Object?> get props => [message];
}
```

### 4.3 Create BLoC (`review_bloc.dart`)

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/review_repository.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewBloc({required this.reviewRepository}) : super(const ReviewInitial()) {
    on<LoadReviewsEvent>(_onLoadReviews);
    on<AddReviewEvent>(_onAddReview);
    on<DeleteReviewEvent>(_onDeleteReview);
  }

  Future<void> _onLoadReviews(
    LoadReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(const ReviewLoading());
    final result = await reviewRepository.getReviews(event.bookId);
    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reviews) => emit(ReviewsLoaded(reviews)),
    );
  }

  Future<void> _onAddReview(
    AddReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(const ReviewLoading());
    final result = await reviewRepository.addReview(
      bookId: event.bookId,
      rating: event.rating,
      comment: event.comment,
    );
    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (review) => emit(ReviewAdded(review)),
    );
  }

  Future<void> _onDeleteReview(
    DeleteReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await reviewRepository.deleteReview(event.reviewId);
    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (_) => emit(const ReviewDeleted()),
    );
  }
}
```

---

## Step 5: Register Dependencies

Update `lib/di/injector.dart`:

```dart
// Add imports
import '../features/reviews/data/datasources/review_remote_data_source.dart';
import '../features/reviews/data/repositories/review_repository_impl.dart';
import '../features/reviews/domain/repositories/review_repository.dart';
import '../features/reviews/presentation/bloc/review_bloc.dart';

// Add to initializeDependencies()
Future<void> initializeDependencies() async {
  // ... existing code ...

  // Reviews
  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => ReviewBloc(reviewRepository: sl()));
}
```

---

## Step 6: Add BLoC Provider

Update `lib/main.dart`:

```dart
// Add import
import 'features/reviews/presentation/bloc/review_bloc.dart';

// Add to MultiBlocProvider
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => sl<AuthBloc>()),
    BlocProvider(create: (_) => sl<BookBloc>()),
    BlocProvider(create: (_) => sl<FavoriteBloc>()),
    BlocProvider(create: (_) => sl<ReadingBloc>()),
    BlocProvider(create: (_) => sl<ReviewBloc>()), // Add this
  ],
  // ... rest of the code
)
```

---

## 📋 Checklist for New Features

- [ ] Create feature directory structure
- [ ] Create domain model with JSON serialization
- [ ] Create repository interface
- [ ] Create remote data source interface and implementation
- [ ] Create repository implementation
- [ ] Create BLoC events
- [ ] Create BLoC states
- [ ] Create BLoC implementation
- [ ] Create UI pages
- [ ] Register dependencies in injector
- [ ] Add BLoC provider in main.dart
- [ ] Test the feature

---

## 🎯 Key Principles to Follow

1. **Keep layers independent** - Domain layer should not depend on data or presentation
2. **Use interfaces** - Always define repository interfaces in domain layer
3. **Handle errors properly** - Convert exceptions to failures
4. **Make models immutable** - Use `const` constructors and `final` fields
5. **Use Equatable** - For value comparison in models and states
6. **Follow naming conventions** - Consistent naming across features
7. **Document your code** - Add comments for complex logic

---

## 🔍 Common Patterns

### API Endpoint Pattern
```dart
// In constants.dart
static String reviews(String bookId) => '/books/$bookId/reviews';
static String review(String reviewId) => '/reviews/$reviewId';
```

### Error Handling Pattern
```dart
try {
  final result = await dataSource.method();
  return Right(result);
} on NetworkException catch (e) {
  return Left(NetworkFailure(e.message));
} on ServerException catch (e) {
  return Left(ServerFailure(e.message));
} catch (e) {
  return Left(UnexpectedFailure(e.toString()));
}
```

### BLoC Event Handler Pattern
```dart
Future<void> _onEvent(Event event, Emitter<State> emit) async {
  emit(const LoadingState());
  final result = await repository.method();
  result.fold(
    (failure) => emit(ErrorState(failure.message)),
    (data) => emit(SuccessState(data)),
  );
}
```

---

## 🚀 You're Ready!

Follow this guide to add new features while maintaining the clean architecture principles. Happy coding! 🎉
