import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/book_model.dart';
import '../../domain/repositories/reading_list_repository.dart';
import '../datasources/reading_list_remote_data_source.dart';

class ReadingListRepositoryImpl implements ReadingListRepository {
  final ReadingListRemoteDataSource remoteDataSource;

  ReadingListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BookModel>> addToReadingList(BookModel book) async {
    try {
      final result = await remoteDataSource.addToReadingList(book);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Failed to add to reading list'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
