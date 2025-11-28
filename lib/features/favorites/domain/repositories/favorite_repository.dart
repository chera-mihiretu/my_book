import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, BookModel>> addFavorite(BookModel book);
  Future<Either<Failure, List<BookModel>>> getFavorites();
  Future<Either<Failure, void>> removeFavorite(String bookId);
  Future<Either<Failure, void>> removeFavoriteByKey(String bookKey);
}
