import 'package:dartz/dartz.dart';
import 'package:new_project/core/models/book_model.dart';
import '../../../../core/error/failures.dart';

abstract class BookDetailRepository {
  Future<Either<Failure, BookModel>> getBookDetail(String bookOLIDKey);
}
