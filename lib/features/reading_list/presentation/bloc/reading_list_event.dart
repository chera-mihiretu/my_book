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
