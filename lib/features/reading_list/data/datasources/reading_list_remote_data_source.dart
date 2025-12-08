import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/book_model.dart';

abstract class ReadingListRemoteDataSource {
  Future<BookModel> addToReadingList(BookModel book);
  Future<bool> checkIsInReadingList(String bookKey);
  Future<List<BookModel>> getReadingList({int limit = 20, int offset = 0});
  Future<BookModel> updateCurrentPage(
    String bookKey,
    int newPage, {
    bool isCompleted = false,
  });
}

class ReadingListRemoteDataSourceImpl implements ReadingListRemoteDataSource {
  final Supabase supabase;

  ReadingListRemoteDataSourceImpl({required this.supabase});

  @override
  Future<BookModel> addToReadingList(BookModel book) async {
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

      // Convert whenToRead (List<TimeOfDay>) to TIME[] format for PostgreSQL
      List<String>? whenToReadTimes;
      if (book.whenToRead != null && book.whenToRead!.isNotEmpty) {
        whenToReadTimes = book.whenToRead!.map((timeOfDay) {
          final hour = timeOfDay.hour.toString().padLeft(2, '0');
          final minute = timeOfDay.minute.toString().padLeft(2, '0');
          return '$hour:$minute:00';
        }).toList();
      }

      // Prepare reading list data
      final readingListData = {
        'started_time': book.startedTime?.toIso8601String(),
        'completed': false,
        'end_date': null,
        'when_to_read': whenToReadTimes,
        'duration_to_read': book.durationToRead,
        'current_page': book.currentPage,
      };

      if (existingBooks.isNotEmpty) {
        // If record exists, update it with reading list data
        final existingBook = existingBooks.first;
        final response = await supabase.client
            .from('books')
            .update(readingListData)
            .eq('id', existingBook['id'])
            .select()
            .single();

        return BookModel.fromJson(response);
      }

      // Create a copy of the book with reading list data and userId set
      final bookWithReadingData = book.copyWith(
        userId: userId,
        completed: false,
        endDate: null,
        lastRead: DateTime.now(),
      );

      // Convert to JSON and merge with reading list data
      final bookJson = bookWithReadingData.toJson();
      bookJson.addAll(readingListData);

      // Insert the new book
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
  Future<bool> checkIsInReadingList(String bookKey) async {
    try {
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await supabase.client
          .from('books')
          .select('started_time, when_to_read, duration_to_read')
          .eq('user_id', userId)
          .eq('book_key', bookKey)
          .maybeSingle();

      if (response == null) return false;

      // Check if any of the reading list fields are not null
      return response['started_time'] != null ||
          response['when_to_read'] != null ||
          response['duration_to_read'] != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BookModel>> getReadingList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await supabase.client
          .from('books')
          .select()
          .eq('user_id', userId)
          .eq('completed', false)
          .not('started_time', 'is', null)
          .not('when_to_read', 'is', null)
          .not('duration_to_read', 'is', null)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => BookModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<BookModel> updateCurrentPage(
    String bookKey,
    int newPage, {
    bool isCompleted = false,
  }) async {
    try {
      final userId = supabase.client.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException();
      }

      final updates = {
        'current_page': newPage,
        'last_read': DateTime.now().toIso8601String(),
      };

      if (isCompleted) {
        updates['completed'] = true;
        updates['end_date'] = DateTime.now().toIso8601String();
      }

      final response = await supabase.client
          .from('books')
          .update(updates)
          .eq('user_id', userId)
          .eq('book_key', bookKey)
          .select()
          .single();

      return BookModel.fromJson(response);
    } catch (e) {
      throw ServerException();
    }
  }
}
