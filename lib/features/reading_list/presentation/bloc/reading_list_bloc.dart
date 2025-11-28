import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/add_to_reading_list_usecase.dart';
import '../../domain/usecases/get_reading_list_usecase.dart';
import 'reading_list_event.dart';
import 'reading_list_state.dart';

class ReadingListBloc extends Bloc<ReadingListEvent, ReadingListState> {
  final AddToReadingListUseCase addToReadingListUseCase;
  final GetReadingListUseCase getReadingListUseCase;

  ReadingListBloc({
    required this.addToReadingListUseCase,
    required this.getReadingListUseCase,
  }) : super(const ReadingListInitial()) {
    on<AddToReadingListEvent>(_onAddToReadingList);
    on<LoadReadingListEvent>(_onLoadReadingList);
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
