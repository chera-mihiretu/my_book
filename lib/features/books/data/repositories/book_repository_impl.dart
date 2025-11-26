import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/models/book_model.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;
  BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BookModel>>> getBooks({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BookModel>> getBookById(String id) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<BookModel>>> searchBooks(String query) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}
