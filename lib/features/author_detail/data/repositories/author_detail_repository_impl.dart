import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/author_detail_model.dart';
import '../../../../core/models/work_model.dart';
import '../../domain/repositories/author_detail_repository.dart';
import '../datasources/author_detail_remote_data_source.dart';

class AuthorDetailRepositoryImpl implements AuthorDetailRepository {
  final AuthorDetailRemoteDataSource remoteDataSource;

  AuthorDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthorDetailModel>> getAuthorDetail(
    String authorKey,
  ) async {
    try {
      final authorDetail = await remoteDataSource.getAuthorDetail(authorKey);
      return Right(authorDetail);
    } on ServerException {
      return const Left(ServerFailure('Failed to fetch author details'));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<WorkModel>>> getAuthorWorks(
    String authorKey,
  ) async {
    try {
      final works = await remoteDataSource.getAuthorWorks(authorKey);
      return Right(works);
    } on ServerException {
      return const Left(ServerFailure('Failed to fetch author works'));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
