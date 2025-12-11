import 'package:equatable/equatable.dart';
import '../../../../core/models/book_model.dart';

abstract class CompletedState extends Equatable {
  const CompletedState();
  @override
  List<Object?> get props => [];
}

class CompletedInitial extends CompletedState {
  const CompletedInitial();
}

class CompletedLoading extends CompletedState {
  const CompletedLoading();
}

class CompletedBooksLoaded extends CompletedState {
  final List<BookModel> books;
  const CompletedBooksLoaded(this.books);
  @override
  List<Object?> get props => [books];
}

class CompletedError extends CompletedState {
  final String message;
  const CompletedError(this.message);
  @override
  List<Object?> get props => [message];
}
