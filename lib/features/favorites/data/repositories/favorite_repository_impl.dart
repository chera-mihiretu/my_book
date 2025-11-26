import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/models/favorite_model.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_remote_data_source.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;
  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FavoriteModel>>> getFavorites() async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, FavoriteModel>> addFavorite(String bookId) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String bookId) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}
