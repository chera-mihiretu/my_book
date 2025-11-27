import 'package:equatable/equatable.dart';

class AuthorModel extends Equatable {
  final String key;
  final String name;
  final List<String>? topSubjects;
  final String? type;
  final String? topWork;
  final int? workCount;
  final String? birthDate;
  final String? deathDate;

  const AuthorModel({
    required this.key,
    required this.name,
    this.topSubjects,
    this.type,
    this.topWork,
    this.workCount,
    this.birthDate,
    this.deathDate,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Author',
      topSubjects: (json['top_subjects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      type: json['type'] as String?,
      topWork: json['top_work'] as String?,
      workCount: json['work_count'] as int?,
      birthDate: json['birth_date'] as String?,
      deathDate: json['death_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'top_subjects': topSubjects,
      'type': type,
      'top_work': topWork,
      'work_count': workCount,
      'birth_date': birthDate,
      'death_date': deathDate,
    };
  }

  @override
  List<Object?> get props => [
    key,
    name,
    topSubjects,
    type,
    topWork,
    workCount,
    birthDate,
    deathDate,
  ];
}
