import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/book_model.dart';

abstract class BookRepository {
  Future<Either<Failure, List<BookModel>>> getBooks({
    int page = 1,
    int limit = 20,
    String? search,
  });
  Future<Either<Failure, BookModel>> getBookById(String id);
  Future<Either<Failure, List<BookModel>>> searchBooks(String query);
}
