import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../repositories/reading_list_repository.dart';

class UpdateCurrentPageUseCase {
  final ReadingListRepository repository;

  UpdateCurrentPageUseCase(this.repository);

  Future<Either<Failure, BookModel>> call(
    String bookKey,
    int newPage, {
    bool isCompleted = false,
  }) async {
    return await repository.updateCurrentPage(
      bookKey,
      newPage,
      isCompleted: isCompleted,
    );
  }
}
