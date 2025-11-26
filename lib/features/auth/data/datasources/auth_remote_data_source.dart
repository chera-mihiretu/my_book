import 'package:supabase_flutter/supabase_flutter.dart';
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
    // TODO: Implement login
    throw UnimplementedError();
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // TODO: Implement register
    throw UnimplementedError();
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
