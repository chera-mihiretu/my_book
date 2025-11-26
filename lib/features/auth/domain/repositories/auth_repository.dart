import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/user_model.dart';

/// Auth repository interface
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current user
  Future<Either<Failure, UserModel>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Refresh authentication token
  Future<Either<Failure, void>> refreshToken();
}
