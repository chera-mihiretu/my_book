import 'package:equatable/equatable.dart';

abstract class ReadingEvent extends Equatable {
  const ReadingEvent();
  @override
  List<Object?> get props => [];
}

class LoadReadingListEvent extends ReadingEvent {
  const LoadReadingListEvent();
}

class StartReadingEvent extends ReadingEvent {
  final String bookId;
  const StartReadingEvent(this.bookId);
  @override
  List<Object?> get props => [bookId];
}

class UpdateProgressEvent extends ReadingEvent {
  final String readingId;
  final int currentPage;
  const UpdateProgressEvent(this.readingId, this.currentPage);
  @override
  List<Object?> get props => [readingId, currentPage];
}
