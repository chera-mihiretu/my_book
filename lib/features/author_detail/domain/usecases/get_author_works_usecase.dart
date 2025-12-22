import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/work_model.dart';
import '../repositories/author_detail_repository.dart';

class GetAuthorWorksUseCase {
  final AuthorDetailRepository repository;

  GetAuthorWorksUseCase(this.repository);

  Future<Either<Failure, List<WorkModel>>> call(String authorKey) async {
    return await repository.getAuthorWorks(authorKey);
  }
}
