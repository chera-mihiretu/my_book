import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/reading_progress_repository.dart';

class ClearReadingProgressUseCase {
  final ReadingProgressRepository repository;

  ClearReadingProgressUseCase(this.repository);

  Future<Either<Failure, void>> call(String bookKey) async {
    return await repository.clearProgress(bookKey);
  }
}
