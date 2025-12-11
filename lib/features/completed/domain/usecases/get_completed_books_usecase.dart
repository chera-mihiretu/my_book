import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../repositories/completed_repository.dart';

class GetCompletedBooksUseCase {
  final CompletedRepository repository;

  GetCompletedBooksUseCase(this.repository);

  Future<Either<Failure, List<BookModel>>> call() async {
    return await repository.getCompletedBooks();
  }
}
