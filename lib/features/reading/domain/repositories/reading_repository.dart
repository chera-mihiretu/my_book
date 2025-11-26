import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/reading_model.dart';
import '../models/reading_session_model.dart';

abstract class ReadingRepository {
  Future<Either<Failure, List<ReadingModel>>> getReadingList();
  Future<Either<Failure, ReadingModel>> startReading(String bookId);
  Future<Either<Failure, ReadingModel>> updateProgress(
    String readingId,
    int currentPage,
  );
  Future<Either<Failure, ReadingSessionModel>> startSession(String readingId);
}
