import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../repositories/reading_list_repository.dart';

class AddToReadingListUseCase {
  final ReadingListRepository repository;

  AddToReadingListUseCase(this.repository);

  Future<Either<Failure, BookModel>> call(BookModel book) async {
    return await repository.addToReadingList(book);
  }
}
