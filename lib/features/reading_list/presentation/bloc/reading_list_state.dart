import 'package:equatable/equatable.dart';

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

class ReadingListSuccess extends ReadingListState {
  final String message;
  const ReadingListSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ReadingListError extends ReadingListState {
  final String message;
  const ReadingListError(this.message);
  @override
  List<Object?> get props => [message];
}
