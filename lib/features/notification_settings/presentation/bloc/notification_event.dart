import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotificationSettingsEvent extends NotificationEvent {
  const LoadNotificationSettingsEvent();
}

class UpdateNotificationSettingsEvent extends NotificationEvent {
  final bool enabled;
  const UpdateNotificationSettingsEvent(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class NotificationTokenSave extends NotificationEvent {
  final String token;
  const NotificationTokenSave(this.token);
  @override
  List<Object?> get props => [token];
}
