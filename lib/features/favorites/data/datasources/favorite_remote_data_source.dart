import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/book_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<BookModel> addFavorite(BookModel book);
  Future<List<BookModel>> getFavorites();
  Future<void> removeFavorite(String bookId);
  Future<bool> checkIsFavorite(String bookKey);
  Future<void> removeFavoriteByKey(String bookKey);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final Supabase supabase;

  FavoriteRemoteDataSourceImpl({required this.supabase});

  @override
  Future<BookModel> addFavorite(BookModel book) async {
    try {
      // Get current user ID
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException();
      }

      // Check if any book record with the same book_key already exists
      final existingBooks = await supabase.client
          .from('books')
          .select()
          .eq('user_id', userId)
          .eq('book_key', book.bookKey ?? '-----');

      if (existingBooks.isNotEmpty) {
        // If record exists, update favorite to true
        final existingBook = existingBooks.first;
        final response = await supabase.client
            .from('books')
            .update({'favorite': true})
            .eq('id', existingBook['id'])
            .select()
            .single();

        return BookModel.fromJson(response);
      }

      // Create a copy of the book with favorite = true and userId set
      final favoriteBook = book.copyWith(favorite: true, userId: userId);

      // Convert to JSON for Supabase
      final bookJson = favoriteBook.toJson();

      // Insert the new favorite
      final response = await supabase.client
          .from('books')
          .insert(bookJson)
          .select()
          .single();

      return BookModel.fromJson(response);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<BookModel>> getFavorites() async {
    try {
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException();
      }

      final response = await supabase.client
          .from('books')
          .select()
          .eq('user_id', userId)
          .eq('favorite', true);

      return (response as List)
          .map((json) => BookModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> removeFavorite(String bookId) async {
    try {
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException();
      }

      await supabase.client
          .from('books')
          .update({'favorite': false})
          .eq('id', bookId)
          .eq('user_id', userId);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<bool> checkIsFavorite(String bookKey) async {
    try {
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) {
        return false;
      }

      final response = await supabase.client
          .from('books')
          .select()
          .eq('user_id', userId)
          .eq('book_key', bookKey)
          .eq('favorite', true);

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> removeFavoriteByKey(String bookKey) async {
    try {
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException();
      }

      await supabase.client
          .from('books')
          .update({'favorite': false})
          .eq('book_key', bookKey)
          .eq('user_id', userId);
    } catch (e) {
      throw ServerException();
    }
  }
}
