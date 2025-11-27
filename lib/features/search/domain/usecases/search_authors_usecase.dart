import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/author_model.dart';
import '../repositories/search_repository.dart';

class SearchAuthorsUseCase {
  final SearchRepository repository;

  SearchAuthorsUseCase(this.repository);

  Future<Either<Failure, List<AuthorModel>>> call(
    String query, {
    int page = 1,
  }) async {
    return await repository.searchAuthors(query, page: page);
  }
}
