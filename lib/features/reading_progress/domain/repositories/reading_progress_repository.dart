import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/reading_progress_model.dart';

abstract class ReadingProgressRepository {
  Future<Either<Failure, void>> saveProgress(ReadingProgressModel progress);
  Future<Either<Failure, ReadingProgressModel?>> getProgress(String bookKey);
  Future<Either<Failure, void>> clearProgress(String bookKey);
  Future<Either<Failure, void>> saveDialogPreference(bool showDialog);
  Future<Either<Failure, bool>> getDialogPreference();
}
