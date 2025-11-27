import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../../data/models/author_model.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<BookModel>>> searchBooks(
    String query, {
    int page = 1,
  });
  Future<Either<Failure, List<AuthorModel>>> searchAuthors(
    String query, {
    int page = 1,
  });
}
