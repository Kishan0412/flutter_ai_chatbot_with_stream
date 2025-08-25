import 'dart:io';
import 'package:flutter/material.dart';

class AttachmentPreview extends StatelessWidget {
  final File file;
  final String fileName;
  final String fileType;
  final VoidCallback onRemove;

  const AttachmentPreview({
    super.key,
    required this.file,
    required this.fileName,
    required this.fileType,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // File icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getFileIcon(fileType),
              color: Colors.blue[700],
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_getFileSize(file)} • ${fileType.toUpperCase()}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Remove button
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.close,
              color: Colors.red[400],
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
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

  String _getFileSize(File file) {
    try {
      final bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      if (bytes < 1024 * 1024 * 1024) {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    } catch (e) {
      return 'Unknown size';
    }
  }
}
