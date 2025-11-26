import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/reading_repository.dart';
import 'reading_event.dart';
import 'reading_state.dart';

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  final ReadingRepository readingRepository;

  ReadingBloc({required this.readingRepository})
    : super(const ReadingInitial()) {
    on<LoadReadingListEvent>(_onLoadReadingList);
    on<StartReadingEvent>(_onStartReading);
    on<UpdateProgressEvent>(_onUpdateProgress);
  }

  Future<void> _onLoadReadingList(
    LoadReadingListEvent event,
    Emitter<ReadingState> emit,
  ) async {
    // TODO: Implement
  }

  Future<void> _onStartReading(
    StartReadingEvent event,
    Emitter<ReadingState> emit,
  ) async {
    // TODO: Implement
  }

  Future<void> _onUpdateProgress(
    UpdateProgressEvent event,
    Emitter<ReadingState> emit,
  ) async {
    // TODO: Implement
  }
}
