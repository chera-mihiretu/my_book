import 'package:dartz/dartz.dart';
import 'package:new_project/core/models/book_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/book_detail_repository.dart';
import '../datasources/book_detail_remote_data_source.dart';
import '../../../favorites/data/datasources/favorite_remote_data_source.dart';

class BookDetailRepositoryImpl implements BookDetailRepository {
  final BookDetailRemoteDataSource remoteDataSource;
  final FavoriteRemoteDataSource favoriteRemoteDataSource;

  BookDetailRepositoryImpl({
    required this.remoteDataSource,
    required this.favoriteRemoteDataSource,
  });

  @override
  Future<Either<Failure, BookModel>> getBookDetail(String bookOLIDKey) async {
    try {
      final remoteBookDetail = await remoteDataSource.getBookDetail(
        bookOLIDKey,
      );

      // Check if the book is in favorites
      final isFavorite = await favoriteRemoteDataSource.checkIsFavorite(
        remoteBookDetail.bookKey ?? '',
      );

      // Return book with updated favorite status
      return Right(remoteBookDetail.copyWith(favorite: isFavorite));
    } on ServerException {
      return Left(ServerFailure('Server Failure'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
