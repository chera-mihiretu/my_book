import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/book_model.dart';

abstract class CompletedRemoteDataSource {
  Future<List<BookModel>> getCompletedBooks({int limit = 20, int offset = 0});
}

class CompletedRemoteDataSourceImpl implements CompletedRemoteDataSource {
  final Supabase supabase;

  CompletedRemoteDataSourceImpl({required this.supabase});

  @override
  Future<List<BookModel>> getCompletedBooks({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException();
      }

      final response = await supabase.client
          .from('books')
          .select()
          .eq('user_id', userId)
          .eq('completed', true)
          .range(offset, offset + limit - 1);

      return (response as List).map((e) => BookModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException();
    }
  }
}
