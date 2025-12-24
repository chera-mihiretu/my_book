import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/notification_settings_model.dart';

abstract class NotificationRepository {
  Future<Either<Failure, NotificationSettingsModel>> getNotificationSettings();
  Future<Either<Failure, NotificationSettingsModel>> updateNotificationSettings(
    bool enabled,
  );
  Future<Either<Failure, NotificationSettingsModel>> saveToken(String token);
}
