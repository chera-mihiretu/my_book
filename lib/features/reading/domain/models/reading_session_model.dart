import 'package:equatable/equatable.dart';

class ReadingSessionModel extends Equatable {
  final String id;
  final String readingId;
  final int pagesRead;
  final Duration duration;

  const ReadingSessionModel({
    required this.id,
    required this.readingId,
    required this.pagesRead,
    required this.duration,
  });

  factory ReadingSessionModel.fromJson(Map<String, dynamic> json) {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [id, readingId, pagesRead, duration];
}
