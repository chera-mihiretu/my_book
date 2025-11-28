import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/book_model.dart';

abstract class ReadingListRemoteDataSource {
  Future<BookModel> addToReadingList(BookModel book);
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
}
