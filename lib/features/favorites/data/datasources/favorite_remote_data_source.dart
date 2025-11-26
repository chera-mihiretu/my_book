import '../../../../core/network/api_client.dart';
import '../../domain/models/favorite_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<List<FavoriteModel>> getFavorites();
  Future<FavoriteModel> addFavorite(String bookId);
  Future<void> removeFavorite(String bookId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final ApiClient apiClient;
  FavoriteRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<FavoriteModel> addFavorite(String bookId) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<void> removeFavorite(String bookId) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}
