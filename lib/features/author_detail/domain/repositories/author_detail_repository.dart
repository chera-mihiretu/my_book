import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/author_detail_model.dart';

abstract class AuthorDetailRepository {
  Future<Either<Failure, AuthorDetailModel>> getAuthorDetail(String authorKey);
}
