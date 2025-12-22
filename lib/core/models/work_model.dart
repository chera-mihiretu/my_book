import 'package:equatable/equatable.dart';

class WorkModel extends Equatable {
  final String title;
  final String key;
  final String? coverId;
  final String? created;
  final String? lastModified;

  const WorkModel({
    required this.title,
    required this.key,
    this.coverId,
    this.created,
    this.lastModified,
  });

  factory WorkModel.fromJson(Map<String, dynamic> json) {
    // Extract cover ID if available (check covers array)
    String? cover;
    if (json['covers'] != null && (json['covers'] as List).isNotEmpty) {
      cover = (json['covers'] as List).first.toString();
    }

    return WorkModel(
      title: json['title'] ?? 'Unknown Title',
      key: json['key'] ?? '',
      coverId: cover,
      created: json['created'] is Map
          ? json['created']['value']
          : json['created'] as String?,
      lastModified: json['last_modified'] is Map
          ? json['last_modified']['value']
          : json['last_modified'] as String?,
    );
  }

  @override
  List<Object?> get props => [title, key, coverId, created, lastModified];
}
