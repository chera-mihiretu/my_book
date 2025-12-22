import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/author_detail_model.dart';
import '../../../../core/models/work_model.dart';

abstract class AuthorDetailRepository {
  Future<Either<Failure, AuthorDetailModel>> getAuthorDetail(String authorKey);
  Future<Either<Failure, List<WorkModel>>> getAuthorWorks(String authorKey);
}
