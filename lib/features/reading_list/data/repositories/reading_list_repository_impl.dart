import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/reading_list_repository.dart';
import '../datasources/reading_list_remote_data_source.dart';
import '../datasources/reading_list_local_data_source.dart';

class ReadingListRepositoryImpl implements ReadingListRepository {
  final ReadingListRemoteDataSource remoteDataSource;
  final ReadingListLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ReadingListRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, BookModel>> addToReadingList(BookModel book) async {
    try {
      final result = await remoteDataSource.addToReadingList(book);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Failed to add to reading list'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookModel>>> getReadingList({
    int limit = 20,
    int offset = 0,
  }) async {
    // Check network connectivity
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Try to fetch from remote
      try {
        final books = await remoteDataSource.getReadingList(
          limit: limit,
          offset: offset,
        );

        // Cache the first page (offset 0) only
        if (offset == 0 && books.isNotEmpty) {
          await localDataSource.saveReadingList(books);
        }

        return Right(books);
      } on ServerException {
        // If remote fails, try cache
        return _getFromCache();
      } catch (e) {
        return _getFromCache();
      }
    } else {
      // No network, use cache
      return _getFromCache();
    }
  }

  Future<Either<Failure, List<BookModel>>> _getFromCache() async {
    try {
      final cachedBooks = await localDataSource.getReadingList();
      if (cachedBooks.isEmpty) {
        return Left(CacheFailure('No cached data available'));
      }
      return Right(cachedBooks);
    } on CacheException {
      return Left(CacheFailure('Failed to load cached data'));
    }
  }

  @override
  Future<Either<Failure, BookModel>> updateCurrentPage(
    String bookKey,
    int newPage, {
    bool isCompleted = false,
  }) async {
    try {
      final result = await remoteDataSource.updateCurrentPage(
        bookKey,
        newPage,
        isCompleted: isCompleted,
      );
      // Optionally update cache here if needed, or just return result
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Failed to update current page'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
