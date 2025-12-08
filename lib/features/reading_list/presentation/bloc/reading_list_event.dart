import 'package:equatable/equatable.dart';
import '../../../../core/models/book_model.dart';

abstract class ReadingListEvent extends Equatable {
  const ReadingListEvent();
  @override
  List<Object?> get props => [];
}

class AddToReadingListEvent extends ReadingListEvent {
  final BookModel book;
  const AddToReadingListEvent(this.book);
  @override
  List<Object?> get props => [book];
}

class LoadReadingListEvent extends ReadingListEvent {
  final int limit;
  final int offset;
  const LoadReadingListEvent({this.limit = 20, this.offset = 0});
  @override
  List<Object?> get props => [limit, offset];
}

class UpdateCurrentPageEvent extends ReadingListEvent {
  final String bookKey;
  final int newPage;
  final bool isCompleted;
  const UpdateCurrentPageEvent(
    this.bookKey,
    this.newPage, {
    this.isCompleted = false,
  });
  @override
  List<Object?> get props => [bookKey, newPage, isCompleted];
}
