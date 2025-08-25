import 'package:hive/hive.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 0)
class ChatSession extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime lastMessageAt;

  @HiveField(4)
  final int messageCount;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastMessageAt,
    this.messageCount = 0,
  });

  ChatSession copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    int? messageCount,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'messageCount': messageCount,
    };
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      lastMessageAt: DateTime.parse(json['lastMessageAt']),
      messageCount: json['messageCount'] ?? 0,
    );
  }
}
