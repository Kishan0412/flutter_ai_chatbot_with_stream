# AI Chatbot with Streaming

A Flutter application that provides an intelligent AI chatbot with real-time streaming responses, file upload capabilities, and local chat storage.

## Features

- 🤖 **AI Chat Interface**: Chat with AI models like GPT-3.5, Claude, and more
- 📱 **Real-time Streaming**: See AI responses appear in real-time as they're generated
- 📎 **File Uploads**: Support for images, documents, and various file types
- 💾 **Local Storage**: Chat history stored locally using Hive database
- 🔍 **Chat History**: Search and manage previous conversations
- ⚙️ **Configurable API**: Easy setup for different AI service providers
- 🎨 **Modern UI**: Beautiful, responsive design with Material 3

## Screenshots

- **Home Screen**: Welcome screen with navigation options
- **Chat Screen**: Main chat interface with streaming responses
- **Chat History**: Browse and search previous conversations
- **Settings**: Configure API keys and endpoints

## Setup Instructions

### 1. Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### 2. Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd ai_chatbot_with_stream
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive adapters:
```bash
flutter packages pub run build_runner build
```

### 3. API Configuration

1. **Get an API Key**: Sign up for an AI service provider:
   - [OpenAI](https://platform.openai.com/) (GPT models)
   - [Anthropic](https://www.anthropic.com/) (Claude models)
   - [Google AI](https://ai.google.dev/) (Gemini models)

2. **Configure the App**:
   - Open the app and go to Settings
   - Enter your API key
   - Set the base URL (e.g., `https://api.openai.com/v1`)
   - Choose your model (e.g., `gpt-3.5-turbo`)

### 4. Run the App

```bash
flutter run
```

## Supported AI Services

### OpenAI
- **Base URL**: `https://api.openai.com/v1`
- **Models**: `gpt-3.5-turbo`, `gpt-4`, `gpt-4-turbo`
- **Endpoint**: `/chat/completions`

### Anthropic (Claude)
- **Base URL**: `https://api.anthropic.com`
- **Models**: `claude-3-sonnet`, `claude-3-opus`, `claude-3-haiku`
- **Endpoint**: `/v1/messages`

### Google AI (Gemini)
- **Base URL**: `https://generativelanguage.googleapis.com`
- **Models**: `gemini-pro`, `gemini-pro-vision`
- **Endpoint**: `/v1beta/models/{model}:generateContent`

## File Upload Support

The app supports various file types:

- **Images**: JPG, PNG, GIF, BMP, WebP
- **Documents**: PDF, DOC, DOCX, TXT, RTF
- **Spreadsheets**: XLS, XLSX
- **Presentations**: PPT, PPTX
- **Media**: MP3, WAV, MP4, AVI, MOV

## Architecture

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── message.dart         # Chat message model
│   └── chat_session.dart    # Chat session model
├── services/                 # Business logic
│   ├── api_service.dart     # AI API integration
│   ├── chat_service.dart    # Chat management
│   └── file_service.dart    # File handling
├── screens/                  # UI screens
│   ├── home_screen.dart     # Welcome screen
│   ├── chat_screen.dart     # Chat interface
│   ├── chat_history_screen.dart # Chat history
│   └── settings_screen.dart # Configuration
└── widgets/                  # Reusable components
    ├── message_bubble.dart  # Message display
    └── attachment_preview.dart # File preview
```

## Dependencies

### Core Dependencies
- `flutter`: Flutter framework
- `hive`: Local database storage
- `dio`: HTTP client for API calls
- `file_picker`: File selection
- `image_picker`: Image capture and selection
- `shared_preferences`: Local settings storage
- `uuid`: Unique identifier generation

### Development Dependencies
- `hive_generator`: Hive code generation
- `build_runner`: Build system
- `flutter_lints`: Code quality

## Usage

### Starting a New Chat
1. Tap "Start New Chat" on the home screen
2. Type your message or upload a file
3. Watch the AI response stream in real-time

### Managing Chat History
1. Go to "Chat History" from the home screen
2. Browse your previous conversations
3. Search for specific chats
4. Delete unwanted conversations

### Configuring API Settings
1. Navigate to "Settings"
2. Enter your API key and endpoint
3. Choose your preferred model
4. Save the configuration

## Troubleshooting

### Common Issues

1. **API Key Not Working**
   - Verify your API key is correct
   - Check if you have sufficient credits
   - Ensure the base URL is correct

2. **Streaming Not Working**
   - Check your internet connection
   - Verify API endpoint supports streaming
   - Check console for error messages

3. **File Upload Issues**
   - Ensure file size is reasonable
   - Check file format is supported
   - Verify app permissions

### Debug Mode

Enable debug logging by checking the console output. The app logs all API requests and responses for debugging purposes.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

If you encounter any issues or have questions:

1. Check the troubleshooting section
2. Review the console logs
3. Open an issue on GitHub
4. Contact the development team

## Roadmap

- [ ] Multi-language support
- [ ] Voice input/output
- [ ] Advanced file analysis
- [ ] Chat export functionality
- [ ] Cloud sync options
- [ ] Custom AI model training
- [ ] Plugin system for extensions

---

**Note**: This app requires an active internet connection and valid API credentials to function. Make sure to keep your API keys secure and never share them publicly.
