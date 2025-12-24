import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/notification_settings/data/models/notification_settings_model.dart';
import '../../domain/usecases/get_notification_settings_usecase.dart';
import '../../domain/usecases/save_notification_token_usecase.dart';
import '../../domain/usecases/update_notification_settings_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationSettingsUseCase getNotificationSettingsUseCase;
  final UpdateNotificationSettingsUseCase updateNotificationSettingsUseCase;
  final SaveNotificationTokenUseCase saveNotificationTokenUseCase;

  NotificationBloc({
    required this.getNotificationSettingsUseCase,
    required this.updateNotificationSettingsUseCase,
    required this.saveNotificationTokenUseCase,
  }) : super(const NotificationInitial()) {
    on<LoadNotificationSettingsEvent>(_onLoadNotificationSettings);
    on<UpdateNotificationSettingsEvent>(_onUpdateNotificationSettings);
    on<NotificationTokenSave>(_onSaveNotificationToken);
  }

  Future<void> _onLoadNotificationSettings(
    LoadNotificationSettingsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    final result = await getNotificationSettingsUseCase();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (settings) => emit(NotificationLoaded(settings)),
    );
  }

  Future<void> _onSaveNotificationToken(
    NotificationTokenSave event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    final result = await saveNotificationTokenUseCase(event.token);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (settings) => emit(
        NotificationUpdated(settings, 'Notification token saved successfully'),
      ),
    );
  }

  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettingsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    final result = await updateNotificationSettingsUseCase(event.enabled);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (settings) => emit(
        NotificationUpdated(
          settings,
          'Notification settings updated successfully',
        ),
      ),
    );
  }
}
