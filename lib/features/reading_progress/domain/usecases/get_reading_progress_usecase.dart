import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/reading_progress_model.dart';
import '../repositories/reading_progress_repository.dart';

class GetReadingProgressUseCase {
  final ReadingProgressRepository repository;

  GetReadingProgressUseCase(this.repository);

  Future<Either<Failure, ReadingProgressModel?>> call(String bookKey) async {
    return await repository.getProgress(bookKey);
  }
}
