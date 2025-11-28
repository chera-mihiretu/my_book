import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_to_reading_list_usecase.dart';
import 'reading_list_event.dart';
import 'reading_list_state.dart';

class ReadingListBloc extends Bloc<ReadingListEvent, ReadingListState> {
  final AddToReadingListUseCase addToReadingListUseCase;

  ReadingListBloc({required this.addToReadingListUseCase})
    : super(const ReadingListInitial()) {
    on<AddToReadingListEvent>(_onAddToReadingList);
  }

  Future<void> _onAddToReadingList(
    AddToReadingListEvent event,
    Emitter<ReadingListState> emit,
  ) async {
    emit(const ReadingListLoading());
    final result = await addToReadingListUseCase(event.book);
    result.fold(
      (failure) => emit(ReadingListError(failure.message)),
      (book) => emit(const ReadingListSuccess('Added to reading list!')),
    );
  }
}
