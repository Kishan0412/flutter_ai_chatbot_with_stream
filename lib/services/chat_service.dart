import 'dart:io';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../models/chat_session.dart';
import 'api_service.dart';

class ChatService {
  static const String _messagesBoxName = 'messages';
  static const String _sessionsBoxName = 'sessions';

  late Box<ChatMessage> _messagesBox;
  late Box<ChatSession> _sessionsBox;
  final Uuid _uuid = Uuid();
  final ApiService _apiService = ApiService();

  Future<void> initialize() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatSessionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ChatMessageAdapter());
    }

    _messagesBox = await Hive.openBox<ChatMessage>(_messagesBoxName);
    _sessionsBox = await Hive.openBox<ChatSession>(_sessionsBoxName);
  }

  // Chat Session Management
  Future<ChatSession> createNewSession() async {
    final session = ChatSession(
      id: _uuid.v4(),
      title: 'New Chat',
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
    );

    await _sessionsBox.put(session.id, session);
    return session;
  }

  Future<List<ChatSession>> getAllSessions() async {
    final sessions = _sessionsBox.values.toList();
    sessions.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    return sessions;
  }

  Future<void> updateSession(ChatSession session) async {
    await _sessionsBox.put(session.id, session);
  }

  Future<void> deleteSession(String sessionId) async {
    // Delete all messages in the session
    final messages = _messagesBox.values
        .where((message) => message.chatId == sessionId)
        .toList();

    for (final message in messages) {
      await _messagesBox.delete(message.id);
    }

    await _sessionsBox.delete(sessionId);
  }

  // Message Management
  Future<ChatMessage> addMessage({
    required String content,
    required bool isUser,
    required String chatId,
    String? attachmentPath,
    String? attachmentType,
    String? attachmentName,
  }) async {
    final message = ChatMessage(
      id: _uuid.v4(),
      content: content,
      isUser: isUser,
      timestamp: DateTime.now(),
      chatId: chatId,
      attachmentPath: attachmentPath,
      attachmentType: attachmentType,
      attachmentName: attachmentName,
    );

    await _messagesBox.put(message.id, message);

    // Update session
    final session = _sessionsBox.get(chatId);
    if (session != null) {
      final updatedSession = session.copyWith(
        lastMessageAt: DateTime.now(),
        messageCount: session.messageCount + 1,
        title: isUser && session.title == 'New Chat'
            ? _generateTitle(content)
            : session.title,
      );
      await updateSession(updatedSession);
    }

    return message;
  }

  Future<List<ChatMessage>> getMessagesForSession(String sessionId) async {
    final messages = _messagesBox.values
        .where((message) => message.chatId == sessionId)
        .toList();

    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  Future<void> deleteMessage(String messageId) async {
    await _messagesBox.delete(messageId);
  }

  // Streaming AI Response
  Stream<String> streamAIResponse(
    String userMessage, List<Map<String,String>> conversation, [
    String? attachmentType,
  ]) {
    return _apiService.streamAIResponse(userMessage, conversation,attachmentType);
  }

  // Non-streaming AI Response (fallback)
  Future<String?> getAIResponse(
    String userMessage,
    String? attachmentType,
  ) async {
    return await _apiService.getAIResponse(userMessage);
  }

  // File Handling
  Future<String?> saveFile(File file, String chatId) async {
    try {
      final fileName = '${_uuid.v4()}_${file.path.split('/').last}';
      final savedPath =
          '/tmp/$fileName'; // In production, use proper file storage

      // Copy file to saved location
      await file.copy(savedPath);
      return savedPath;
    } catch (e) {
      return null;
    }
  }

  // Extract text content from files (basic implementation)
  Future<String?> extractFileContent(File file) async {
    try {
      if (file.path.endsWith('.txt')) {
        return await file.readAsString();
      }
      // Add more file type handlers as needed
      return null;
    } catch (e) {
      return null;
    }
  }

  String _generateTitle(String content) {
    if (content.length <= 30) return content;
    return '${content.substring(0, 30)}...';
  }

  // Update API configuration
  void updateApiKey(String apiKey) {
    // _apiService.updateApiKey(apiKey);
  }

  void updateApiBaseUrl(String baseUrl) {
    // _apiService.updateBaseUrl(baseUrl);
  }

  void dispose() {
    _messagesBox.close();
    _sessionsBox.close();
    // _apiService.dispose();
  }
}
