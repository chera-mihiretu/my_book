import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/add_to_reading_list_usecase.dart';
import '../../domain/usecases/get_reading_list_usecase.dart';
import '../../domain/usecases/update_current_page_usecase.dart';
import 'reading_list_event.dart';
import 'reading_list_state.dart';

class ReadingListBloc extends Bloc<ReadingListEvent, ReadingListState> {
  final AddToReadingListUseCase addToReadingListUseCase;
  final GetReadingListUseCase getReadingListUseCase;
  final UpdateCurrentPageUseCase updateCurrentPageUseCase;

  ReadingListBloc({
    required this.addToReadingListUseCase,
    required this.getReadingListUseCase,
    required this.updateCurrentPageUseCase,
  }) : super(const ReadingListInitial()) {
    on<AddToReadingListEvent>(_onAddToReadingList);
    on<LoadReadingListEvent>(_onLoadReadingList);
    on<UpdateCurrentPageEvent>(_onUpdateCurrentPage);
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

  Future<void> _onLoadReadingList(
    LoadReadingListEvent event,
    Emitter<ReadingListState> emit,
  ) async {
    emit(const ReadingListLoading());
    final result = await getReadingListUseCase(
      limit: event.limit,
      offset: event.offset,
    );
    result.fold((failure) => emit(ReadingListError(failure.message)), (books) {
      // Sort books by upcoming read time
      final sortedBooks = _sortByUpcomingReadTime(books);
      emit(
        ReadingListLoaded(sortedBooks, hasMore: books.length >= event.limit),
      );
    });
  }

  Future<void> _onUpdateCurrentPage(
    UpdateCurrentPageEvent event,
    Emitter<ReadingListState> emit,
  ) async {
    // We don't want to show full loading screen for this action, maybe
    // But for now let's keep it simple. If we emit loading, the UI might flicker if it listens to it.
    // However, the detail page should probably only listen for Success/error for this specific event.
    // Ideally, we yield a specific "updating" state, but Loading is fine if generic.
    // Let's create a custom "Updating" state? Or just rely on Future.
    // For now, emit nothing (optimistic) or emit Loading.
    // Given the request, celebration follows submission.
    // We can emit ReadingListUpdateSuccess(book) when done.

    final result = await updateCurrentPageUseCase(
      event.bookKey,
      event.newPage,
      isCompleted: event.isCompleted,
    );
    result.fold(
      (failure) => emit(ReadingListError(failure.message)),
      (book) => emit(ReadingListUpdateSuccess(book)),
    );
  }

  List<T> _sortByUpcomingReadTime<T>(List<T> books) {
    final now = DateTime.now();
    final currentDay = now.weekday % 7; // Convert to 0-6 (M-Su)
    final currentTime = TimeOfDay.fromDateTime(now);

    return List<T>.from(books)..sort((a, b) {
      final aBook = a as dynamic;
      final bBook = b as dynamic;

      final aNextTime = _getNextReadTime(
        aBook.whenToRead,
        currentDay,
        currentTime,
      );
      final bNextTime = _getNextReadTime(
        bBook.whenToRead,
        currentDay,
        currentTime,
      );

      if (aNextTime == null && bNextTime == null) return 0;
      if (aNextTime == null) return 1;
      if (bNextTime == null) return -1;

      return aNextTime.compareTo(bNextTime);
    });
  }

  int? _getNextReadTime(
    List<TimeOfDay>? whenToRead,
    int currentDay,
    TimeOfDay currentTime,
  ) {
    if (whenToRead == null || whenToRead.isEmpty) return null;

    int? nearestMinutes;

    for (int i = 0; i < 7; i++) {
      final dayIndex = (currentDay + i) % 7;
      if (dayIndex >= whenToRead.length) continue;

      final readTime = whenToRead[dayIndex];

      final minutesFromNow =
          i * 24 * 60 +
          (readTime.hour * 60 + readTime.minute) -
          (currentTime.hour * 60 + currentTime.minute);

      if (minutesFromNow > 0 &&
          (nearestMinutes == null || minutesFromNow < nearestMinutes)) {
        nearestMinutes = minutesFromNow;
      }
    }

    return nearestMinutes;
  }
}
