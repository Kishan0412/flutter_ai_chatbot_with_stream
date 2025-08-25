import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // final Dio _dio = Dio();
  //
  // // Configure your API endpoint here
  static const String _baseUrl = 'https://openrouter.ai/api/v1';
  static const String _model = '<enter-your-model>';
  static const String _apiKey =
      '<Enter-token>';

  // Stream response from AI API
  Stream<String> streamAIResponse(
    String message,
    List<Map<String, String>> conversation, [
    String? attachmentType,
    String? attachmentContent,
  ]) async* {
    final payload = {
      "model": _model,
      "messages": [
        for (var data in conversation) data,
        {
          "role": "user",
          "content": _buildPrompt(message, attachmentType, attachmentContent),
        },
      ],
      "stream": true,
    };

    final request = http.Request(
      "POST",
      Uri.parse("$_baseUrl/chat/completions"),
    );

    request.headers.addAll({
      "Authorization": "Bearer $_apiKey",
      "Content-Type": "application/json",
    });
    request.body = jsonEncode(payload);

    final response = await request.send();

    // Process the stream response
    await for (final line
        in response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())) {
      if (line.startsWith("data:")) {
        final data = line.substring(5).trim();
        if (data == "[DONE]") {
          break;
        }
        try {
          final jsonData = jsonDecode(data);
          final delta = jsonData["choices"][0]["delta"];
          if (delta != null && delta["content"] != null) {
            yield delta["content"]; // return token by token
          }
        } catch (e) {
          debugPrint("Stream parse error: $e");
        }
      }
    }
  }

  // Alternative method for non-streaming responses
  Future<String?> getAIResponse(String message) async {
    final payload = {
      "model": _model,
      "messages": [
        {"role": "user", "content": message},
      ],
    };

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/chat/completions"),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data["choices"]?[0]?["message"]?["content"];
        debugPrint("✅ AI Response: $content");
        return jsonEncode(content);
      } else {
        debugPrint("❌ Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Exception: $e");
    }
    return null;
  }

  // Build the prompt based on message and attachment
  String _buildPrompt(
    String message,
    String? attachmentType,
    String? attachmentContent,
  ) {
    String prompt = message;

    if (attachmentType != null && attachmentContent != null) {
      prompt =
          '''
I have a $attachmentType file with the following content:
$attachmentContent

User message: $message

Please analyze the file content and respond to the user's message accordingly.
''';
    }

    return prompt;
  }

  //   // Method to handle file uploads (if your API supports it)
  //   Future<String?> uploadFile(String filePath, String fileName) async {
  //     try {
  //       final formData = FormData.fromMap({
  //         'file': await MultipartFile.fromFile(filePath, filename: fileName),
  //       });
  //
  //       final response = await _dio.post('/files', data: formData);
  //       return response.data['id']; // Return file ID or URL
  //     } catch (e) {
  //       print('Error uploading file: $e');
  //       return null;
  //     }
  //   }
  //
  //   // Update API configuration
  //   void updateApiKey(String newApiKey) {
  //     _dio.options.headers['Authorization'] = 'Bearer $newApiKey';
  //   }
  //
  //   void updateBaseUrl(String newBaseUrl) {
  //     _dio.options.baseUrl = newBaseUrl;
  //   }
  //
  //   void dispose() {
  //     _dio.close();
  //   }
}
