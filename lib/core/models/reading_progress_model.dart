import 'package:equatable/equatable.dart';

class ReadingProgressModel extends Equatable {
  final String bookKey;
  final int elapsedSeconds;
  final DateTime lastUpdated;
  final int totalDurationSeconds;

  const ReadingProgressModel({
    required this.bookKey,
    required this.elapsedSeconds,
    required this.lastUpdated,
    required this.totalDurationSeconds,
  });

  factory ReadingProgressModel.fromJson(Map<String, dynamic> json) {
    return ReadingProgressModel(
      bookKey: json['book_key'] as String,
      elapsedSeconds: json['elapsed_seconds'] as int,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      totalDurationSeconds: json['total_duration_seconds'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_key': bookKey,
      'elapsed_seconds': elapsedSeconds,
      'last_updated': lastUpdated.toIso8601String(),
      'total_duration_seconds': totalDurationSeconds,
    };
  }

  int get remainingSeconds => totalDurationSeconds - elapsedSeconds;

  ReadingProgressModel copyWith({
    String? bookKey,
    int? elapsedSeconds,
    DateTime? lastUpdated,
    int? totalDurationSeconds,
  }) {
    return ReadingProgressModel(
      bookKey: bookKey ?? this.bookKey,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
    );
  }

  @override
  List<Object?> get props => [
    bookKey,
    elapsedSeconds,
    lastUpdated,
    totalDurationSeconds,
  ];
}
