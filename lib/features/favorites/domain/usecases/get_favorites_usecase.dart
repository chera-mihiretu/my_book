import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../repositories/favorite_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<BookModel>>> call({
    int limit = 20,
    int offset = 0,
  }) async {
    return await repository.getFavorites();
  }
}
