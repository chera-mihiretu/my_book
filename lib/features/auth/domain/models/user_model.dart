import 'package:equatable/equatable.dart';

/// User model
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // TODO: Implement fromJson
    throw UnimplementedError();
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    // TODO: Implement toJson
    throw UnimplementedError();
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    // TODO: Implement copyWith
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [id, email, name, avatar, createdAt, updatedAt];
}
