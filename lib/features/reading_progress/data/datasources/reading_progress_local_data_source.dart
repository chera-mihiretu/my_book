import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/reading_progress_model.dart';

abstract class ReadingProgressLocalDataSource {
  /// Save reading progress for a book
  Future<void> saveProgress(ReadingProgressModel progress);

  /// Get reading progress for a specific book
  Future<ReadingProgressModel?> getProgress(String bookKey);

  /// Clear progress for a specific book
  Future<void> clearProgress(String bookKey);

  /// Save dialog preference (whether to show timer info dialog)
  Future<void> saveDialogPreference(bool showDialog);

  /// Get dialog preference
  Future<bool> getDialogPreference();
}

class ReadingProgressLocalDataSourceImpl
    implements ReadingProgressLocalDataSource {
  final HiveInterface hive;
  static const String _boxName = 'reading_progress';
  static const String _dialogPreferenceKey = 'show_timer_dialog';
  static const String _progressKeyPrefix = 'progress_';

  ReadingProgressLocalDataSourceImpl({required this.hive});

  Future<Box> _openBox() async {
    if (!hive.isBoxOpen(_boxName)) {
      return await hive.openBox(_boxName);
    }
    return hive.box(_boxName);
  }

  String _getProgressKey(String bookKey) => '$_progressKeyPrefix$bookKey';

  @override
  Future<void> saveProgress(ReadingProgressModel progress) async {
    try {
      final box = await _openBox();
      final key = _getProgressKey(progress.bookKey);
      await box.put(key, progress.toJson());
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<ReadingProgressModel?> getProgress(String bookKey) async {
    try {
      final box = await _openBox();
      final key = _getProgressKey(bookKey);
      final data = box.get(key);

      if (data == null) {
        return null;
      }

      return ReadingProgressModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearProgress(String bookKey) async {
    try {
      final box = await _openBox();
      final key = _getProgressKey(bookKey);
      await box.delete(key);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveDialogPreference(bool showDialog) async {
    try {
      final box = await _openBox();
      await box.put(_dialogPreferenceKey, showDialog);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> getDialogPreference() async {
    try {
      final box = await _openBox();
      // Default to true (show dialog) if not set
      return box.get(_dialogPreferenceKey, defaultValue: true) as bool;
    } catch (e) {
      throw CacheException();
    }
  }
}
