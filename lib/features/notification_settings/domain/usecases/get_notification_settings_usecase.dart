import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/notification_settings_model.dart';
import '../repositories/notification_repository.dart';

class GetNotificationSettingsUseCase {
  final NotificationRepository repository;

  GetNotificationSettingsUseCase(this.repository);

  Future<Either<Failure, NotificationSettingsModel>> call() async {
    return await repository.getNotificationSettings();
  }
}
