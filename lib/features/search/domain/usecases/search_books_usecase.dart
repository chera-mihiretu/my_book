import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../repositories/search_repository.dart';

class SearchBooksUseCase {
  final SearchRepository repository;

  SearchBooksUseCase(this.repository);

  Future<Either<Failure, List<BookModel>>> call(
    String query, {
    int page = 1,
  }) async {
    return await repository.searchBooks(query, page: page);
  }
}
