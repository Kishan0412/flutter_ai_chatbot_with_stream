import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/chat_session.dart';
import '../services/chat_service.dart';
import '../services/file_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/attachment_preview.dart';

class ChatScreen extends StatefulWidget {
  final ChatSession? session;

  const ChatScreen({super.key, this.session});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final FileService _fileService = FileService();

  ChatSession? _currentSession;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  File? _selectedFile;
  String? _selectedFileType;
  String? _selectedFileName;

  // Streaming variables
  StreamSubscription<String>? _streamSubscription;
  String _currentStreamingMessage = '';
  bool _isStreaming = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _chatService.initialize();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final args = ModalRoute.of(context)?.settings.arguments;
      final ChatSession? session = args is ChatSession ? args : widget.session;

      if (session != null) {
        _currentSession = session;
        await _loadMessages(_currentSession!.id);
      } else {
        _currentSession = await _chatService.createNewSession();
      }
    });
  }

  Future<void> _loadMessages(String sessionId) async {
    if (_currentSession != null) {
      final messages = await _chatService.getMessagesForSession(
        _currentSession!.id,
      );

      setState(() {
        _messages = messages;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty && _selectedFile == null) {
      return;
    }

    final message = _messageController.text.trim();
    final file = _selectedFile;

    // Clear input
    _messageController.clear();
    setState(() {
      _selectedFile = null;
      _selectedFileType = null;
      _selectedFileName = null;
    });

    if (_currentSession != null) {
      // Add user message
      final userMessage = await _chatService.addMessage(
        content: message,
        isUser: true,
        chatId: _currentSession!.id,
        attachmentPath: file?.path,
        attachmentType: _selectedFileType,
        attachmentName: _selectedFileName,
      );

      setState(() {
        _messages.add(userMessage);
      });
      _scrollToBottom();
      List<Map<String, String>> conversations = [];
      for (ChatMessage message in _messages) {
        conversations.add({
          "role": message.isUser ? "user" : "assistant",
          "content": message.content,
        });
      }

      // Start streaming AI response
      await _startStreamingResponse(message, conversations);
    }
  }

  Future<void> _startStreamingResponse(
    String userMessage,
    List<Map<String, String>> conversations,
  ) async {
    setState(() {
      _isStreaming = true;
      _currentStreamingMessage = '';
      _isLoading = true;
    });

    try {
      final tempMessage = ChatMessage(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        content: '',
        isUser: false,
        timestamp: DateTime.now(),
        chatId: _currentSession!.id,
      );

      setState(() {
        _messages.add(tempMessage);
      });
      _scrollToBottom();

      // Start streaming
      final stream = _chatService.streamAIResponse(
        userMessage,
        conversations,
        _selectedFileType,
      );

      bool firstTokenArrived = false;

      _streamSubscription = stream.listen(
        (chunk) {
          setState(() {
            if (!firstTokenArrived) {
              _currentStreamingMessage = chunk;
              firstTokenArrived = true;
            } else {
              _currentStreamingMessage += chunk;
            }

            final lastIndex = _messages.length - 1;
            if (lastIndex >= 0) {
              _messages[lastIndex] = _messages[lastIndex].copyWith(
                content: _currentStreamingMessage.isEmpty
                    ? "..."
                    : _currentStreamingMessage,
              );
            }
          });
          _scrollToBottom();
        },
        onDone: () async {
          await _finishStreamingResponse();
        },
        onError: (error) async {
          await _finishStreamingResponse();
        },
      );
    } catch (e) {
      await _finishStreamingResponse();
    }
  }

  Future<void> _finishStreamingResponse() async {
    if (_streamSubscription != null) {
      await _streamSubscription!.cancel();
      _streamSubscription = null;
    }

    if (_currentSession != null && _currentStreamingMessage.isNotEmpty) {
      final aiMessage = await _chatService.addMessage(
        content: _currentStreamingMessage,
        isUser: false,
        chatId: _currentSession!.id,
      );

      setState(() {
        final lastIndex = _messages.length - 1;
        if (lastIndex >= 0) {
          _messages[lastIndex] = aiMessage;
        }
        _isStreaming = false;
        _currentStreamingMessage = '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isStreaming = false;
        _currentStreamingMessage = '';
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  Future<void> _pickImage() async {
    final file = await _fileService.pickImage();
    if (file != null) {
      setState(() {
        _selectedFile = file;
        _selectedFileType = 'image';
        _selectedFileName = file.path.split('/').last;
      });
    }
  }

  Future<void> _pickDocument() async {
    final files = await _fileService.pickDocuments();
    if (files.isNotEmpty) {
      final file = files.first;
      setState(() {
        _selectedFile = file;
        _selectedFileType = _fileService.getFileType(file.path);
        _selectedFileName = file.path.split('/').last;
      });
    }
  }

  Future<void> _pickFile() async {
    final files = await _fileService.pickFiles();
    if (files.isNotEmpty) {
      final file = files.first;
      setState(() {
        _selectedFile = file;
        _selectedFileType = _fileService.getFileType(file.path);
        _selectedFileName = file.path.split('/').last;
      });
    }
  }

  void _showFilePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose File Type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.blue),
              title: const Text('Image'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.green),
              title: const Text('Document'),
              onTap: () {
                Navigator.pop(context);
                _pickDocument();
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file, color: Colors.orange),
              title: const Text('Any File'),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentSession?.title ?? 'New Chat'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _messages.isEmpty && !_isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Start a conversation with AI',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Upload files or ask questions',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
          ),

          // Selected File Preview
          if (_selectedFile != null)
            AttachmentPreview(
              file: _selectedFile!,
              fileName: _selectedFileName!,
              fileType: _selectedFileType!,
              onRemove: () {
                setState(() {
                  _selectedFile = null;
                  _selectedFileType = null;
                  _selectedFileName = null;
                });
              },
            ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.2 * 255).floor()),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _isStreaming ? null : _showFilePickerDialog,
                  color: _isStreaming ? Colors.grey : Colors.grey[600],
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    enabled: !_isStreaming,
                  ),
                ),
                IconButton(
                  icon: _isStreaming
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  onPressed: _isStreaming ? null : _sendMessage,
                  color: _isStreaming
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }
}
