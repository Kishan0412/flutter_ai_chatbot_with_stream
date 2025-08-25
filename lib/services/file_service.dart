import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FileService {
  final ImagePicker _imagePicker = ImagePicker();

  // Pick image from gallery or camera
  Future<File?> pickImage({bool fromCamera = false}) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  // Pick documents
  Future<List<File>> pickDocuments({
    List<String> allowedExtensions = const ['pdf', 'doc', 'docx', 'txt', 'rtf'],
    bool allowMultiple = false,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error picking documents: $e');
      return [];
    }
  }

  // Pick any file type
  Future<List<File>> pickFiles({
    bool allowMultiple = false,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: allowMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error picking files: $e');
      return [];
    }
  }

  // Get file type from extension
  String getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return 'image';
      case 'pdf':
        return 'pdf';
      case 'doc':
      case 'docx':
        return 'document';
      case 'txt':
      case 'rtf':
        return 'text';
      case 'xls':
      case 'xlsx':
        return 'spreadsheet';
      case 'ppt':
      case 'pptx':
        return 'presentation';
      case 'mp3':
      case 'wav':
      case 'flac':
        return 'audio';
      case 'mp4':
      case 'avi':
      case 'mov':
        return 'video';
      default:
        return 'file';
    }
  }

  // Get file size in readable format
  String getFileSize(File file) {
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

  // Check if file is an image
  bool isImage(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  // Check if file is a document
  bool isDocument(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return ['pdf', 'doc', 'docx', 'txt', 'rtf'].contains(extension);
  }
}
