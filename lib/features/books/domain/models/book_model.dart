import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final String id;
  final String title;
  final String author;
  final String? description;
  final String? coverImage;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.coverImage,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    // TODO: Implement fromJson
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    // TODO: Implement toJson
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [id, title, author, description, coverImage];
}
