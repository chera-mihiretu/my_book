import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';

import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';
import '../models/author_model.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BookModel>>> searchBooks(
    String query, {
    int page = 1,
  }) async {
    try {
      final remoteBooks = await remoteDataSource.searchBooks(query, page: page);
      return Right(remoteBooks);
    } on ServerException {
      return const Left(
        ServerFailure('Server error occurred while searching books'),
      );
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<AuthorModel>>> searchAuthors(
    String query, {
    int page = 1,
  }) async {
    try {
      final remoteAuthors = await remoteDataSource.searchAuthors(
        query,
        page: page,
      );
      return Right(remoteAuthors);
    } on ServerException {
      return const Left(
        ServerFailure('Server error occurred while searching authors'),
      );
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
