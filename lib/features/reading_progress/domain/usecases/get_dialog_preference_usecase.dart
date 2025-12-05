import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/reading_progress_repository.dart';

class GetDialogPreferenceUseCase {
  final ReadingProgressRepository repository;

  GetDialogPreferenceUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.getDialogPreference();
  }
}
