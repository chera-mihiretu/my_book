import 'package:dartz/dartz.dart';
import 'package:new_project/core/models/book_model.dart';
import '../../../../core/error/failures.dart';
import '../repositories/book_detail_repository.dart';

class GetBookDetailUseCase {
  final BookDetailRepository repository;

  GetBookDetailUseCase(this.repository);

  Future<Either<Failure, BookModel>> call(String bookOLIDKey) async {
    return await repository.getBookDetail(bookOLIDKey);
  }
}
