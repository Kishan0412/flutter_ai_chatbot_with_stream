import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.smart_toy, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).floor()),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Attachment preview
                  if (message.attachmentPath != null) _buildAttachmentPreview(),

                  // Message content
                  if (message.content.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GptMarkdown(
                        message.content,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),

                  // Timestamp
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        color: isUser
                            ? Colors.white.withAlpha((0.7 * 255).floor())
                            : Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 16, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttachmentPreview() {
    if (message.attachmentPath == null) return const SizedBox.shrink();

    final fileName = message.attachmentName ?? 'Unknown file';
    final fileType = message.attachmentType ?? 'file';

    return Container(
      margin: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.2 * 255).floor()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withAlpha((0.3 * 255).floor()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(_getFileIcon(fileType), color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  fileType.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withAlpha((0.7 * 255).floor()),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'image':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'document':
        return Icons.description;
      case 'text':
        return Icons.text_snippet;
      case 'spreadsheet':
        return Icons.table_chart;
      case 'presentation':
        return Icons.slideshow;
      case 'audio':
        return Icons.audiotrack;
      case 'video':
        return Icons.videocam;
      default:
        return Icons.attach_file;
    }
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
