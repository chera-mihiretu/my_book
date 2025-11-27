import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/author_detail_model.dart';
import '../repositories/author_detail_repository.dart';

class GetAuthorDetailUseCase {
  final AuthorDetailRepository repository;

  GetAuthorDetailUseCase(this.repository);

  Future<Either<Failure, AuthorDetailModel>> call(String authorKey) async {
    return await repository.getAuthorDetail(authorKey);
  }
}
