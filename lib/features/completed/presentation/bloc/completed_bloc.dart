import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_completed_books_usecase.dart';
import 'completed_event.dart';
import 'completed_state.dart';

class CompletedBloc extends Bloc<CompletedEvent, CompletedState> {
  final GetCompletedBooksUseCase getCompletedBooksUseCase;

  CompletedBloc({required this.getCompletedBooksUseCase})
    : super(const CompletedInitial()) {
    on<LoadCompletedBooksEvent>(_onLoadCompletedBooks);
  }

  Future<void> _onLoadCompletedBooks(
    LoadCompletedBooksEvent event,
    Emitter<CompletedState> emit,
  ) async {
    emit(const CompletedLoading());

    final result = await getCompletedBooksUseCase();

    result.fold(
      (failure) => emit(CompletedError(failure.message)),
      (books) => emit(CompletedBooksLoaded(books)),
    );
  }
}
