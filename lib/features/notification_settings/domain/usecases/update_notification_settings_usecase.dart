import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/notification_settings_model.dart';
import '../repositories/notification_repository.dart';

class UpdateNotificationSettingsUseCase {
  final NotificationRepository repository;

  UpdateNotificationSettingsUseCase(this.repository);

  Future<Either<Failure, NotificationSettingsModel>> call(bool enabled) async {
    return await repository.updateNotificationSettings(enabled);
  }
}
