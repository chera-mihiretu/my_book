import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/book_model.dart';
import '../../data/models/author_model.dart';
import '../../domain/usecases/search_authors_usecase.dart';
import '../../domain/usecases/search_books_usecase.dart';

// Events
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchBooks extends SearchEvent {
  final String query;
  final int page;

  const SearchBooks(this.query, {this.page = 1});

  @override
  List<Object> get props => [query, page];
}

class SearchAuthors extends SearchEvent {
  final String query;
  final int page;

  const SearchAuthors(this.query, {this.page = 1});

  @override
  List<Object> get props => [query, page];
}

// States
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<BookModel> books;
  final bool hasReachedMax;

  const SearchLoaded({required this.books, this.hasReachedMax = false});

  @override
  List<Object> get props => [books, hasReachedMax];
}

class AuthorSearchLoaded extends SearchState {
  final List<AuthorModel> authors;
  final bool hasReachedMax;

  const AuthorSearchLoaded({required this.authors, this.hasReachedMax = false});

  @override
  List<Object> get props => [authors, hasReachedMax];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchBooksUseCase searchBooksUseCase;
  final SearchAuthorsUseCase searchAuthorsUseCase;

  SearchBloc({
    required this.searchBooksUseCase,
    required this.searchAuthorsUseCase,
  }) : super(SearchInitial()) {
    on<SearchBooks>(_onSearchBooks);
    on<SearchAuthors>(_onSearchAuthors);
  }

  Future<void> _onSearchBooks(
    SearchBooks event,
    Emitter<SearchState> emit,
  ) async {
    if (event.page == 1) {
      emit(SearchLoading());
    }

    final result = await searchBooksUseCase(event.query, page: event.page);

    result.fold((failure) => emit(SearchError(failure.message)), (books) {
      if (state is SearchLoaded && event.page > 1) {
        final currentBooks = (state as SearchLoaded).books;

        emit(
          SearchLoaded(
            books: currentBooks + books,
            hasReachedMax: books.isEmpty || books.length < 10,
          ),
        );
      } else {
        emit(
          SearchLoaded(
            books: books,
            hasReachedMax: books.isEmpty || books.length < 10,
          ),
        );
      }
    });
  }

  Future<void> _onSearchAuthors(
    SearchAuthors event,
    Emitter<SearchState> emit,
  ) async {
    if (event.page == 1) {
      emit(SearchLoading());
    }

    final result = await searchAuthorsUseCase(event.query, page: event.page);

    result.fold((failure) => emit(SearchError(failure.message)), (authors) {
      if (state is AuthorSearchLoaded && event.page > 1) {
        final currentAuthors = (state as AuthorSearchLoaded).authors;

        emit(
          AuthorSearchLoaded(
            authors: currentAuthors + authors,
            hasReachedMax: authors.isEmpty || authors.length < 10,
          ),
        );
      } else {
        emit(
          AuthorSearchLoaded(
            authors: authors,
            hasReachedMax: authors.isEmpty || authors.length < 10,
          ),
        );
      }
    });
  }
}
