import 'package:equatable/equatable.dart';
import '../../domain/models/reading_model.dart';

abstract class ReadingState extends Equatable {
  const ReadingState();
  @override
  List<Object?> get props => [];
}

class ReadingInitial extends ReadingState {
  const ReadingInitial();
}

class ReadingLoading extends ReadingState {
  const ReadingLoading();
}

class ReadingListLoaded extends ReadingState {
  final List<ReadingModel> readings;
  const ReadingListLoaded(this.readings);
  @override
  List<Object?> get props => [readings];
}

class ReadingError extends ReadingState {
  final String message;
  const ReadingError(this.message);
  @override
  List<Object?> get props => [message];
}
