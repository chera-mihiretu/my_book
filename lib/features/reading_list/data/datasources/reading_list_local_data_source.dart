import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/book_model.dart';

abstract class ReadingListLocalDataSource {
  Future<void> saveReadingList(List<BookModel> books);
  Future<List<BookModel>> getReadingList();
  Future<void> clearCache();
}

class ReadingListLocalDataSourceImpl implements ReadingListLocalDataSource {
  final HiveInterface hive;
  static const String _boxName = 'reading_list_cache';
  static const String _cacheKey = 'reading_list';
  static const int _maxCacheSize = 20;

  ReadingListLocalDataSourceImpl({required this.hive});

  Future<Box> _openBox() async {
    if (!hive.isBoxOpen(_boxName)) {
      return await hive.openBox(_boxName);
    }
    return hive.box(_boxName);
  }

  @override
  Future<void> saveReadingList(List<BookModel> books) async {
    try {
      final box = await _openBox();

      // Take only first 20 books (LRU - keep most recent)
      final booksToCache = books.take(_maxCacheSize).toList();

      // Convert to JSON
      final jsonList = booksToCache.map((book) => book.toJson()).toList();

      // Save with timestamp
      await box.put(_cacheKey, {
        'books': jsonList,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<BookModel>> getReadingList() async {
    try {
      final box = await _openBox();
      final cached = box.get(_cacheKey);

      if (cached == null) {
        return [];
      }

      final booksJson = cached['books'] as List;
      return booksJson
          .map((json) => BookModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await _openBox();
      await box.delete(_cacheKey);
    } catch (e) {
      throw CacheException();
    }
  }
}
