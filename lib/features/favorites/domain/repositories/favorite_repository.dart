import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/favorite_model.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<FavoriteModel>>> getFavorites();
  Future<Either<Failure, FavoriteModel>> addFavorite(String bookId);
  Future<Either<Failure, void>> removeFavorite(String bookId);
}
