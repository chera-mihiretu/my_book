import 'package:equatable/equatable.dart';
import '../../../../core/models/book_model.dart';

abstract class ReadingListState extends Equatable {
  const ReadingListState();
  @override
  List<Object?> get props => [];
}

class ReadingListInitial extends ReadingListState {
  const ReadingListInitial();
}

class ReadingListLoading extends ReadingListState {
  const ReadingListLoading();
}

class ReadingListLoaded extends ReadingListState {
  final List<BookModel> books;
  final bool hasMore;
  const ReadingListLoaded(this.books, {this.hasMore = true});
  @override
  List<Object?> get props => [books, hasMore];
}

class ReadingListSuccess extends ReadingListState {
  final String message;
  const ReadingListSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ReadingListUpdateSuccess extends ReadingListState {
  final BookModel book;
  const ReadingListUpdateSuccess(this.book);
  @override
  List<Object?> get props => [book];
}

class ReadingListError extends ReadingListState {
  final String message;
  const ReadingListError(this.message);
  @override
  List<Object?> get props => [message];
}
