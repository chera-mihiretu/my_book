import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/models/reading_model.dart';
import '../../domain/models/reading_session_model.dart';
import '../../domain/repositories/reading_repository.dart';
import '../datasources/reading_remote_data_source.dart';

class ReadingRepositoryImpl implements ReadingRepository {
  final ReadingRemoteDataSource remoteDataSource;
  ReadingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ReadingModel>>> getReadingList() async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ReadingModel>> startReading(String bookId) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ReadingModel>> updateProgress(
    String readingId,
    int currentPage,
  ) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ReadingSessionModel>> startSession(
    String readingId,
  ) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}
