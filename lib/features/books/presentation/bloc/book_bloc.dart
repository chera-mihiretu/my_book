import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/book_repository.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository bookRepository;

  BookBloc({required this.bookRepository}) : super(const BookInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<LoadBookDetailEvent>(_onLoadBookDetail);
  }

  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    // TODO: Implement
  }

  Future<void> _onLoadBookDetail(
    LoadBookDetailEvent event,
    Emitter<BookState> emit,
  ) async {
    // TODO: Implement
  }
}
