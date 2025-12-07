import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/book_model.dart';

abstract class FavoriteLocalDataSource {
  Future<void> saveFavorites(List<BookModel> books);
  Future<List<BookModel>> getFavorites();
  Future<void> clearCache();
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final HiveInterface hive;
  static const String _boxName = 'favorites_cache';
  static const String _cacheKey = 'favorites';
  static const int _maxCacheSize = 10;

  FavoriteLocalDataSourceImpl({required this.hive});

  Future<Box> _openBox() async {
    if (!hive.isBoxOpen(_boxName)) {
      return await hive.openBox(_boxName);
    }
    return hive.box(_boxName);
  }

  @override
  Future<void> saveFavorites(List<BookModel> books) async {
    try {
      final box = await _openBox();
      final booksToCache = books.take(_maxCacheSize).toList();
      final jsonList = booksToCache.map((book) => book.toJson()).toList();

      await box.put(_cacheKey, {
        'books': jsonList,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<BookModel>> getFavorites() async {
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
