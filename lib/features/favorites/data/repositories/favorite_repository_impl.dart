import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_remote_data_source.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl({required this.remoteDataSource});

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
    try {
      final result = await remoteDataSource.getFavorites();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Failed to load favorites'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String bookId) async {
    try {
      await remoteDataSource.removeFavorite(bookId);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure('Failed to remove favorite'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
