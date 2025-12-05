import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/reading_progress_model.dart';
import '../../domain/usecases/clear_reading_progress_usecase.dart';
import '../../domain/usecases/get_dialog_preference_usecase.dart';
import '../../domain/usecases/get_reading_progress_usecase.dart';
import '../../domain/usecases/save_reading_progress_usecase.dart';
import '../../domain/usecases/update_dialog_preference_usecase.dart';
import 'reading_progress_event.dart';
import 'reading_progress_state.dart';

class ReadingProgressBloc
    extends Bloc<ReadingProgressEvent, ReadingProgressState> {
  final GetReadingProgressUseCase getReadingProgressUseCase;
  final SaveReadingProgressUseCase saveReadingProgressUseCase;
  final ClearReadingProgressUseCase clearReadingProgressUseCase;
  final GetDialogPreferenceUseCase getDialogPreferenceUseCase;
  final UpdateDialogPreferenceUseCase updateDialogPreferenceUseCase;

  ReadingProgressBloc({
    required this.getReadingProgressUseCase,
    required this.saveReadingProgressUseCase,
    required this.clearReadingProgressUseCase,
    required this.getDialogPreferenceUseCase,
    required this.updateDialogPreferenceUseCase,
  }) : super(ReadingProgressInitial()) {
    on<LoadReadingProgressEvent>(_onLoadReadingProgress);
    on<SaveReadingProgressEvent>(_onSaveReadingProgress);
    on<ClearReadingProgressEvent>(_onClearReadingProgress);
    on<CheckDialogPreferenceEvent>(_onCheckDialogPreference);
    on<UpdateDialogPreferenceEvent>(_onUpdateDialogPreference);
  }

  Future<void> _onLoadReadingProgress(
    LoadReadingProgressEvent event,
    Emitter<ReadingProgressState> emit,
  ) async {
    emit(ReadingProgressLoading());

    // Load progress
    final progressResult = await getReadingProgressUseCase(event.bookKey);

    // Load dialog preference
    final dialogResult = await getDialogPreferenceUseCase();

    progressResult.fold(
      (failure) {
        // No progress or error, emit loaded with null progress
        dialogResult.fold(
          (dialogFailure) => emit(
            const ReadingProgressLoaded(progress: null, showDialog: true),
          ),
          (showDialog) => emit(
            ReadingProgressLoaded(progress: null, showDialog: showDialog),
          ),
        );
      },
      (progress) {
        dialogResult.fold(
          (dialogFailure) =>
              emit(ReadingProgressLoaded(progress: progress, showDialog: true)),
          (showDialog) => emit(
            ReadingProgressLoaded(progress: progress, showDialog: showDialog),
          ),
        );
      },
    );
  }

  Future<void> _onSaveReadingProgress(
    SaveReadingProgressEvent event,
    Emitter<ReadingProgressState> emit,
  ) async {
    final progress = ReadingProgressModel(
      bookKey: event.bookKey,
      elapsedSeconds: event.elapsedSeconds,
      lastUpdated: DateTime.now(),
      totalDurationSeconds: event.totalDurationSeconds,
    );

    final result = await saveReadingProgressUseCase(progress);

    result.fold(
      (failure) => emit(const ReadingProgressError('Failed to save progress')),
      (_) {
        // Don't emit saved state, just keep current state
        // This prevents UI flickering during auto-save
      },
    );
  }

  Future<void> _onClearReadingProgress(
    ClearReadingProgressEvent event,
    Emitter<ReadingProgressState> emit,
  ) async {
    final result = await clearReadingProgressUseCase(event.bookKey);

    result.fold(
      (failure) => emit(const ReadingProgressError('Failed to clear progress')),
      (_) => emit(const ReadingProgressLoaded(progress: null)),
    );
  }

  Future<void> _onCheckDialogPreference(
    CheckDialogPreferenceEvent event,
    Emitter<ReadingProgressState> emit,
  ) async {
    final result = await getDialogPreferenceUseCase();

    result.fold(
      (failure) => emit(const DialogPreferenceLoaded(true)),
      (showDialog) => emit(DialogPreferenceLoaded(showDialog)),
    );
  }

  Future<void> _onUpdateDialogPreference(
    UpdateDialogPreferenceEvent event,
    Emitter<ReadingProgressState> emit,
  ) async {
    final result = await updateDialogPreferenceUseCase(event.showDialog);

    result.fold(
      (failure) =>
          emit(const ReadingProgressError('Failed to update preference')),
      (_) {
        // Update the current state with new preference
        if (state is ReadingProgressLoaded) {
          final currentState = state as ReadingProgressLoaded;
          emit(currentState.copyWith(showDialog: event.showDialog));
        }
      },
    );
  }
}
