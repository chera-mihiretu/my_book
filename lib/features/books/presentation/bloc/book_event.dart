import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();
  @override
  List<Object?> get props => [];
}

class LoadBooksEvent extends BookEvent {
  const LoadBooksEvent();
}

class LoadBookDetailEvent extends BookEvent {
  final String bookId;
  const LoadBookDetailEvent(this.bookId);
  @override
  List<Object?> get props => [bookId];
}
