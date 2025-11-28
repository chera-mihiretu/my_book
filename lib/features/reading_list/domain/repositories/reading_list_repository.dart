import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';

abstract class ReadingListRepository {
  Future<Either<Failure, BookModel>> addToReadingList(BookModel book);
  Future<Either<Failure, List<BookModel>>> getReadingList({
    int limit,
    int offset,
  });
}
