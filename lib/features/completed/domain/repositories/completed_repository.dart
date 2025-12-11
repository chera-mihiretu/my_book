import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';

abstract class CompletedRepository {
  Future<Either<Failure, List<BookModel>>> getCompletedBooks();
}
