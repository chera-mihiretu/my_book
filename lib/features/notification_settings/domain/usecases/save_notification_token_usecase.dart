import 'package:dartz/dartz.dart';
import 'package:new_project/features/notification_settings/data/models/notification_settings_model.dart';
import '../../../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

class SaveNotificationTokenUseCase {
  final NotificationRepository repository;

  SaveNotificationTokenUseCase(this.repository);

  Future<Either<Failure, NotificationSettingsModel>> call(String token) async {
    return await repository.saveToken(token);
  }
}
