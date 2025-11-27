import 'package:dartz/dartz.dart';
import 'package:new_project/core/models/book_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/book_detail_repository.dart';
import '../datasources/book_detail_remote_data_source.dart';

class BookDetailRepositoryImpl implements BookDetailRepository {
  final BookDetailRemoteDataSource remoteDataSource;

  BookDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BookModel>> getBookDetail(String bookOLIDKey) async {
    try {
      final remoteBookDetail = await remoteDataSource.getBookDetail(
        bookOLIDKey,
      );
      return Right(remoteBookDetail);
    } on ServerException {
      return Left(ServerFailure('Server Failure'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
