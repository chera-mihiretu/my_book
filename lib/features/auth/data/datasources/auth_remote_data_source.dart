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
  Future<void> resetPassword({required String email});
  Future<void> verifyOtp({required String email, required String token});
  Future<void> verifyEmail({required String email, required String token});
  Future<void> updatePassword({required String password});
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
      throw ServerException(_getFriendlyErrorMessage(e.message));
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
      throw ServerException(_getFriendlyErrorMessage(e.message));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabase.client.auth.signOut();
    } on AuthException catch (e) {
      throw ServerException(_getFriendlyErrorMessage(e.message));
    } catch (e) {
      throw ServerException(e.toString());
    }
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

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await supabase.client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw ServerException(_getFriendlyErrorMessage(e.message));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> verifyOtp({required String email, required String token}) async {
    try {
      await supabase.client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );
    } on AuthException catch (e) {
      throw ServerException(_getFriendlyErrorMessage(e.message));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updatePassword({required String password}) async {
    try {
      await supabase.client.auth.updateUser(UserAttributes(password: password));
    } on AuthException catch (e) {
      throw ServerException(_getFriendlyErrorMessage(e.message));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> verifyEmail({
    required String email,
    required String token,
  }) async {
    try {
      await supabase.client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );
    } on AuthException catch (e) {
      throw ServerException(_getFriendlyErrorMessage(e.message));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  String _getFriendlyErrorMessage(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Incorrect email or password.';
    }
    if (message.contains('User already registered')) {
      return 'Account with this email already exists.';
    }
    if (message.contains('Password should be at least')) {
      return 'Password must be at least 6 characters long.';
    }
    if (message.contains('Email not confirmed')) {
      return 'Please verify your email address before logging in.';
    }
    if (message.contains('Signups not allowed for this instance')) {
      return 'Registration is currently disabled.';
    }
    return message;
  }
}
