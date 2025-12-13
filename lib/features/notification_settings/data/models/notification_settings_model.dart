import 'package:equatable/equatable.dart';

class NotificationSettingsModel extends Equatable {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool notification;

  const NotificationSettingsModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.notification,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      notification: json['notification'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'notification': notification,
    };
  }

  /// Converts to JSON without id field for Supabase insert operations
  /// Allows Supabase to auto-generate UUID for id
  Map<String, dynamic> toJsonForInsert() {
    return {
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'notification': notification,
    };
  }

  NotificationSettingsModel copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? notification,
  }) {
    return NotificationSettingsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notification: notification ?? this.notification,
    );
  }

  @override
  List<Object?> get props => [id, userId, createdAt, updatedAt, notification];
}
