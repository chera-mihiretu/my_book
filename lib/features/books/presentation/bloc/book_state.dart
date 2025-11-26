import 'package:equatable/equatable.dart';
import '../../domain/models/book_model.dart';

abstract class BookState extends Equatable {
  const BookState();
  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {
  const BookInitial();
}

class BookLoading extends BookState {
  const BookLoading();
}

class BooksLoaded extends BookState {
  final List<BookModel> books;
  const BooksLoaded(this.books);
  @override
  List<Object?> get props => [books];
}

class BookError extends BookState {
  final String message;
  const BookError(this.message);
  @override
  List<Object?> get props => [message];
}
