import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../repositories/reading_list_repository.dart';

class GetReadingListUseCase {
  final ReadingListRepository repository;

  GetReadingListUseCase(this.repository);

  Future<Either<Failure, List<BookModel>>> call({
    int limit = 20,
    int offset = 0,
  }) async {
    return await repository.getReadingList(limit: limit, offset: offset);
  }
}
