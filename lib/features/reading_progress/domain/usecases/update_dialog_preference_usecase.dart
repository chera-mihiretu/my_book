import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/reading_progress_repository.dart';

class UpdateDialogPreferenceUseCase {
  final ReadingProgressRepository repository;

  UpdateDialogPreferenceUseCase(this.repository);

  Future<Either<Failure, void>> call(bool showDialog) async {
    return await repository.saveDialogPreference(showDialog);
  }
}
