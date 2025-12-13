import 'package:equatable/equatable.dart';
import '../../data/models/notification_settings_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final NotificationSettingsModel settings;
  const NotificationLoaded(this.settings);
  @override
  List<Object?> get props => [settings];
}

class NotificationUpdated extends NotificationState {
  final NotificationSettingsModel settings;
  final String message;
  const NotificationUpdated(this.settings, this.message);
  @override
  List<Object?> get props => [settings, message];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}
