import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notification_settings_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NotificationSettingsModel>>
  getNotificationSettings() async {
    try {
      final result = await remoteDataSource.getNotificationSettings();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Failed to load notification settings'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettingsModel>> updateNotificationSettings(
    bool enabled,
  ) async {
    try {
      final result = await remoteDataSource.updateNotificationSettings(enabled);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Failed to update notification settings'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettingsModel>> saveToken(
    String token,
  ) async {
    try {
      final result = await remoteDataSource.saveToken(token);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure('Failed to save notification token'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
