import '../../../../core/network/api_client.dart';
import '../../domain/models/book_model.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> getBooks({int page = 1, int limit = 20});
  Future<BookModel> getBookById(String id);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final ApiClient apiClient;
  BookRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<BookModel>> getBooks({int page = 1, int limit = 20}) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<BookModel> getBookById(String id) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}
