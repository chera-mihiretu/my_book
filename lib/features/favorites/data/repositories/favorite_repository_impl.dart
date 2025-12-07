import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_local_data_source.dart';
import '../datasources/favorite_remote_data_source.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;
  final FavoriteLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  FavoriteRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, BookModel>> addFavorite(BookModel book) async {
    try {
      final result = await remoteDataSource.addFavorite(book);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Failed to add favorite'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookModel>>> getFavorites() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getFavorites();
        // Cache the results locally
        await localDataSource.saveFavorites(result);
        return Right(result);
      } on ServerException {
        // If remote fails, try to get from cache
        try {
          final cachedFavorites = await localDataSource.getFavorites();
          if (cachedFavorites.isNotEmpty) {
            return Right(cachedFavorites);
          }
          return Left(ServerFailure('Failed to load favorites'));
        } on CacheException {
          return Left(CacheFailure('No cached favorites available'));
        }
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // No internet, get from cache
      try {
        final cachedFavorites = await localDataSource.getFavorites();
        if (cachedFavorites.isNotEmpty) {
          return Right(cachedFavorites);
        }
        return Left(CacheFailure('No cached favorites available'));
      } on CacheException {
        return Left(CacheFailure('Failed to load cached favorites'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String bookId) async {
    try {
      // await remoteDataSource.removeFavorite(bookId);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure('Failed to remove favorite'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteByKey(String bookKey) async {
    try {
      await remoteDataSource.removeFavoriteByKey(bookKey);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure('Failed to remove favorite'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
