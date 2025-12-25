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
  final bool isFetchingMore;

  const SearchLoaded({
    required this.books,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });

  @override
  List<Object> get props => [books, hasReachedMax, isFetchingMore];
}

class AuthorSearchLoaded extends SearchState {
  final List<AuthorModel> authors;
  final bool hasReachedMax;
  final bool isFetchingMore;

  const AuthorSearchLoaded({
    required this.authors,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });

  @override
  List<Object> get props => [authors, hasReachedMax, isFetchingMore];
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
    } else {
      // If we are already loading more, ignore this event
      if (state is SearchLoaded && (state as SearchLoaded).isFetchingMore) {
        return;
      }

      // Emit state with isFetchingMore = true
      if (state is SearchLoaded) {
        final currentLoaded = state as SearchLoaded;
        emit(
          SearchLoaded(
            books: currentLoaded.books,
            hasReachedMax: currentLoaded.hasReachedMax,
            isFetchingMore: true,
          ),
        );
      }
    }

    final result = await searchBooksUseCase(event.query, page: event.page);

    result.fold(
      (failure) {
        // If it was a pagination error, we might want to keep the old data and show a snackbar (UI handle)
        // For now, if it's page 1, show full error. If page > 1, maybe just revert isFetchingMore?
        // The current implementation replaces everything with SearchError which clears the list.
        // Ideally we would want to keep the list and just show an error.
        // But adhering to existing pattern for now (or improving slightly):

        if (event.page > 1 && state is SearchLoaded) {
          // Revert isFetchingMore but keep data
          final currentLoaded = state as SearchLoaded;
          emit(
            SearchLoaded(
              books: currentLoaded.books,
              hasReachedMax: currentLoaded.hasReachedMax,
              isFetchingMore: false,
            ),
          );
          // We could emit a side-effect or a transient error here if needed,
          // but for now let's just log or ignore to prevent list disappearance on pagination fail.
          // Or if we must show error:
          emit(SearchError(failure.message));
        } else {
          emit(SearchError(failure.message));
        }
      },
      (books) {
        if (state is SearchLoaded && event.page > 1) {
          final currentBooks = (state as SearchLoaded).books;

          emit(
            SearchLoaded(
              books: currentBooks + books,
              hasReachedMax: books.isEmpty || books.length < 10,
              isFetchingMore: false,
            ),
          );
        } else {
          emit(
            SearchLoaded(
              books: books,
              hasReachedMax: books.isEmpty || books.length < 10,
              isFetchingMore: false,
            ),
          );
        }
      },
    );
  }

  Future<void> _onSearchAuthors(
    SearchAuthors event,
    Emitter<SearchState> emit,
  ) async {
    if (event.page == 1) {
      emit(SearchLoading());
    } else {
      // If we are already loading more, ignore this event
      if (state is AuthorSearchLoaded &&
          (state as AuthorSearchLoaded).isFetchingMore) {
        return;
      }
      // Emit state with isFetchingMore = true
      if (state is AuthorSearchLoaded) {
        final currentLoaded = state as AuthorSearchLoaded;
        emit(
          AuthorSearchLoaded(
            authors: currentLoaded.authors,
            hasReachedMax: currentLoaded.hasReachedMax,
            isFetchingMore: true,
          ),
        );
      }
    }

    final result = await searchAuthorsUseCase(event.query, page: event.page);

    result.fold(
      (failure) {
        if (event.page > 1 && state is AuthorSearchLoaded) {
          final currentLoaded = state as AuthorSearchLoaded;
          emit(
            AuthorSearchLoaded(
              authors: currentLoaded.authors,
              hasReachedMax: currentLoaded.hasReachedMax,
              isFetchingMore: false,
            ),
          );
          emit(SearchError(failure.message));
        } else {
          emit(SearchError(failure.message));
        }
      },
      (authors) {
        if (state is AuthorSearchLoaded && event.page > 1) {
          final currentAuthors = (state as AuthorSearchLoaded).authors;

          emit(
            AuthorSearchLoaded(
              authors: currentAuthors + authors,
              hasReachedMax: authors.isEmpty || authors.length < 10,
              isFetchingMore: false,
            ),
          );
        } else {
          emit(
            AuthorSearchLoaded(
              authors: authors,
              hasReachedMax: authors.isEmpty || authors.length < 10,
              isFetchingMore: false,
            ),
          );
        }
      },
    );
  }
}
