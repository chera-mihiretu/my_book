import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/reading_progress_model.dart';
import '../repositories/reading_progress_repository.dart';

class SaveReadingProgressUseCase {
  final ReadingProgressRepository repository;

  SaveReadingProgressUseCase(this.repository);

  Future<Either<Failure, void>> call(ReadingProgressModel progress) async {
    return await repository.saveProgress(progress);
  }
}
