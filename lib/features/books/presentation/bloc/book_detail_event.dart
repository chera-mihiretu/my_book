part of 'book_detail_bloc.dart';

abstract class BookDetailEvent extends Equatable {
  const BookDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchBookDetail extends BookDetailEvent {
  final String bookOLIDKey;

  const FetchBookDetail(this.bookOLIDKey);

  @override
  List<Object> get props => [bookOLIDKey];
}
