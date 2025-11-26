import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    // TODO: Implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // TODO: Implement register
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> logout() async {
    // TODO: Implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    // TODO: Implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<bool> isAuthenticated() async {
    // TODO: Implement isAuthenticated
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    // TODO: Implement refreshToken
    throw UnimplementedError();
  }
}
