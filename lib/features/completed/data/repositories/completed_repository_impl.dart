import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/completed_repository.dart';
import '../datasources/completed_local_data_source.dart';
import '../datasources/completed_remote_data_source.dart';

class CompletedRepositoryImpl implements CompletedRepository {
  final CompletedRemoteDataSource remoteDataSource;
  final CompletedLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CompletedRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BookModel>>> getCompletedBooks() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCompletedBooks();
        // Cache the results locally
        await localDataSource.saveCompletedBooks(result);
        return Right(result);
      } on ServerException {
        // If remote fails, try to get from cache
        try {
          final cachedBooks = await localDataSource.getCompletedBooks();
          if (cachedBooks.isNotEmpty) {
            return Right(cachedBooks);
          }
          return Left(ServerFailure('Failed to load completed books'));
        } on CacheException {
          return Left(CacheFailure('No cached completed books available'));
        }
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // No internet, get from cache
      try {
        final cachedBooks = await localDataSource.getCompletedBooks();
        if (cachedBooks.isNotEmpty) {
          return Right(cachedBooks);
        }
        return Left(CacheFailure('No cached completed books available'));
      } on CacheException {
        return Left(CacheFailure('Failed to load cached completed books'));
      }
    }
  }
}
