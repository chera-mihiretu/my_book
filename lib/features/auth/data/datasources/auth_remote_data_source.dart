import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/models/user_model.dart';

/// Auth remote data source interface
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> refreshToken();
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Supabase supabase;

  AuthRemoteDataSourceImpl({required this.supabase});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw ServerException('Login failed: User is null');
      }

      return UserModel(
        id: user.id,
        email: user.email!,
        name: user.userMetadata?['name'] ?? '',
        createdAt: DateTime.parse(user.createdAt),
        updatedAt: user.updatedAt != null
            ? DateTime.parse(user.updatedAt!)
            : null,
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await supabase.client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final user = response.user;
      if (user == null) {
        throw ServerException('Registration failed: User is null');
      }

      return UserModel(
        id: user.id,
        email: user.email!,
        name: user.userMetadata?['name'] ?? name,
        createdAt: DateTime.parse(user.createdAt),
        updatedAt: user.updatedAt != null
            ? DateTime.parse(user.updatedAt!)
            : null,
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    // TODO: Implement logout
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // TODO: Implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<void> refreshToken() async {
    // TODO: Implement refreshToken
    throw UnimplementedError();
  }
}
