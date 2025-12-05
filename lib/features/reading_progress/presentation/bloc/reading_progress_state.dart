import 'package:equatable/equatable.dart';
import '../../../../core/models/reading_progress_model.dart';

abstract class ReadingProgressState extends Equatable {
  const ReadingProgressState();

  @override
  List<Object?> get props => [];
}

class ReadingProgressInitial extends ReadingProgressState {}

class ReadingProgressLoading extends ReadingProgressState {}

class ReadingProgressLoaded extends ReadingProgressState {
  final ReadingProgressModel? progress;
  final bool showDialog;

  const ReadingProgressLoaded({this.progress, this.showDialog = true});

  @override
  List<Object?> get props => [progress, showDialog];

  ReadingProgressLoaded copyWith({
    ReadingProgressModel? progress,
    bool? showDialog,
  }) {
    return ReadingProgressLoaded(
      progress: progress ?? this.progress,
      showDialog: showDialog ?? this.showDialog,
    );
  }
}

class ReadingProgressSaved extends ReadingProgressState {}

class ReadingProgressError extends ReadingProgressState {
  final String message;

  const ReadingProgressError(this.message);

  @override
  List<Object?> get props => [message];
}

class DialogPreferenceLoaded extends ReadingProgressState {
  final bool showDialog;

  const DialogPreferenceLoaded(this.showDialog);

  @override
  List<Object?> get props => [showDialog];
}
