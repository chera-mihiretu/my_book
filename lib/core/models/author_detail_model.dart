import 'package:equatable/equatable.dart';

class AuthorDetailModel extends Equatable {
  final String? key;
  final String name;
  final String? birthDate;
  final List<String>? alternateNames;
  final String? personalName;
  final String? bio;
  final List<int>? photos;
  final String? fullerName;
  final String? deathDate;
  final List<Map<String, dynamic>>? links;

  const AuthorDetailModel({
    this.key,
    required this.name,
    this.birthDate,
    this.alternateNames,
    this.personalName,
    this.bio,
    this.photos,
    this.fullerName,
    this.deathDate,
    this.links,
  });

  factory AuthorDetailModel.fromJson(Map<String, dynamic> json) {
    // Handle bio which can be a String or a Map with 'value'
    String? bioText;
    if (json['bio'] != null) {
      if (json['bio'] is Map) {
        bioText = json['bio']['value'] as String?;
      } else if (json['bio'] is String) {
        bioText = json['bio'] as String;
      }
    }

    return AuthorDetailModel(
      key: json['key'] as String?,
      name: json['name'] as String? ?? 'Unknown Author',
      birthDate: json['birth_date'] as String?,
      alternateNames: (json['alternate_names'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      personalName: json['personal_name'] as String?,
      bio: bioText,
      photos: (json['photos'] as List<dynamic>?)?.map((e) => e as int).toList(),
      fullerName: json['fuller_name'] as String?,
      deathDate: json['death_date'] as String?,
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'birth_date': birthDate,
      'alternate_names': alternateNames,
      'personal_name': personalName,
      'bio': bio,
      'photos': photos,
      'fuller_name': fullerName,
      'death_date': deathDate,
      'links': links,
    };
  }

  @override
  List<Object?> get props => [
    key,
    name,
    birthDate,
    alternateNames,
    personalName,
    bio,
    photos,
    fullerName,
    deathDate,
    links,
  ];
}
