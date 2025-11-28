import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_project/core/models/book_model.dart';
import '../../domain/usecases/get_book_detail_usecase.dart';

part 'book_detail_event.dart';
part 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final GetBookDetailUseCase getBookDetailUseCase;

  BookDetailBloc({required this.getBookDetailUseCase})
    : super(BookDetailInitial()) {
    on<FetchBookDetail>(_onFetchBookDetail);
    on<UpdateBookFavoriteStatus>(_onUpdateBookFavoriteStatus);
  }

  Future<void> _onFetchBookDetail(
    FetchBookDetail event,
    Emitter<BookDetailState> emit,
  ) async {
    emit(BookDetailLoading());
    final result = await getBookDetailUseCase(event.bookOLIDKey);
    result.fold(
      (failure) => emit(BookDetailError(message: failure.message)),
      (bookDetail) => emit(BookDetailLoaded(bookDetail: bookDetail)),
    );
  }

  void _onUpdateBookFavoriteStatus(
    UpdateBookFavoriteStatus event,
    Emitter<BookDetailState> emit,
  ) {
    if (state is BookDetailLoaded) {
      final currentBook = (state as BookDetailLoaded).bookDetail;
      emit(
        BookDetailLoaded(
          bookDetail: currentBook.copyWith(favorite: event.isFavorite),
        ),
      );
    }
  }
}
