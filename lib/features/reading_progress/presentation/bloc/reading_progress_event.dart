import 'package:equatable/equatable.dart';

abstract class ReadingProgressEvent extends Equatable {
  const ReadingProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadReadingProgressEvent extends ReadingProgressEvent {
  final String bookKey;

  const LoadReadingProgressEvent(this.bookKey);

  @override
  List<Object?> get props => [bookKey];
}

class SaveReadingProgressEvent extends ReadingProgressEvent {
  final String bookKey;
  final int elapsedSeconds;
  final int totalDurationSeconds;

  const SaveReadingProgressEvent({
    required this.bookKey,
    required this.elapsedSeconds,
    required this.totalDurationSeconds,
  });

  @override
  List<Object?> get props => [bookKey, elapsedSeconds, totalDurationSeconds];
}

class CheckDialogPreferenceEvent extends ReadingProgressEvent {
  const CheckDialogPreferenceEvent();
}

class UpdateDialogPreferenceEvent extends ReadingProgressEvent {
  final bool showDialog;

  const UpdateDialogPreferenceEvent(this.showDialog);

  @override
  List<Object?> get props => [showDialog];
}

class ClearReadingProgressEvent extends ReadingProgressEvent {
  final String bookKey;

  const ClearReadingProgressEvent(this.bookKey);

  @override
  List<Object?> get props => [bookKey];
}
