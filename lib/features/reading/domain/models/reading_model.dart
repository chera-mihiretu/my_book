import 'package:equatable/equatable.dart';
import '../../../books/domain/models/book_model.dart';

class ReadingModel extends Equatable {
  final String id;
  final String userId;
  final BookModel book;
  final int currentPage;
  final int totalPages;

  const ReadingModel({
    required this.id,
    required this.userId,
    required this.book,
    required this.currentPage,
    required this.totalPages,
  });

  factory ReadingModel.fromJson(Map<String, dynamic> json) {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [id, userId, book, currentPage, totalPages];
}
