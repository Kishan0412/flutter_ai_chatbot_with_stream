import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String? chatId;

  @HiveField(5)
  final String? attachmentPath;

  @HiveField(6)
  final String? attachmentType;

  @HiveField(7)
  final String? attachmentName;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.chatId,
    this.attachmentPath,
    this.attachmentType,
    this.attachmentName,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    String? chatId,
    String? attachmentPath,
    String? attachmentType,
    String? attachmentName,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      chatId: chatId ?? this.chatId,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      attachmentType: attachmentType ?? this.attachmentType,
      attachmentName: attachmentName ?? this.attachmentName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'chatId': chatId,
      'attachmentPath': attachmentPath,
      'attachmentType': attachmentType,
      'attachmentName': attachmentName,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      chatId: json['chatId'],
      attachmentPath: json['attachmentPath'],
      attachmentType: json['attachmentType'],
      attachmentName: json['attachmentName'],
    );
  }
}
