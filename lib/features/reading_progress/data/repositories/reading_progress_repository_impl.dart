import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/reading_progress_model.dart';
import '../../domain/repositories/reading_progress_repository.dart';
import '../datasources/reading_progress_local_data_source.dart';

class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  final ReadingProgressLocalDataSource localDataSource;

  ReadingProgressRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveProgress(
    ReadingProgressModel progress,
  ) async {
    try {
      await localDataSource.saveProgress(progress);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ReadingProgressModel?>> getProgress(
    String bookKey,
  ) async {
    try {
      final progress = await localDataSource.getProgress(bookKey);
      return Right(progress);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearProgress(String bookKey) async {
    try {
      await localDataSource.clearProgress(bookKey);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveDialogPreference(bool showDialog) async {
    try {
      await localDataSource.saveDialogPreference(showDialog);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getDialogPreference() async {
    try {
      final preference = await localDataSource.getDialogPreference();
      return Right(preference);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
