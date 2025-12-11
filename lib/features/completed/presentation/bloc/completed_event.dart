import 'package:equatable/equatable.dart';

abstract class CompletedEvent extends Equatable {
  const CompletedEvent();
  @override
  List<Object?> get props => [];
}

class LoadCompletedBooksEvent extends CompletedEvent {
  const LoadCompletedBooksEvent();
}
