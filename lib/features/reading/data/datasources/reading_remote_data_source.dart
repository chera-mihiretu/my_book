import '../../../../core/network/api_client.dart';
import '../../domain/models/reading_model.dart';
import '../../domain/models/reading_session_model.dart';

abstract class ReadingRemoteDataSource {
  Future<List<ReadingModel>> getReadingList();
  Future<ReadingModel> startReading(String bookId);
  Future<ReadingModel> updateProgress(String readingId, int currentPage);
  Future<ReadingSessionModel> startSession(String readingId);
}

class ReadingRemoteDataSourceImpl implements ReadingRemoteDataSource {
  final ApiClient apiClient;
  ReadingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ReadingModel>> getReadingList() async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<ReadingModel> startReading(String bookId) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<ReadingModel> updateProgress(String readingId, int currentPage) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<ReadingSessionModel> startSession(String readingId) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}
