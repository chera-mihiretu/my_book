import 'package:equatable/equatable.dart';
import '../../../books/domain/models/book_model.dart';

class FavoriteModel extends Equatable {
  final String id;
  final String userId;
  final BookModel book;

  const FavoriteModel({
    required this.id,
    required this.userId,
    required this.book,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [id, userId, book];
}
