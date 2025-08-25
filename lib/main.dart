import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/chat_history_screen.dart';
import 'models/message.dart';
import 'models/chat_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(ChatSessionAdapter());

  await Hive.openBox<ChatSession>('sessions');
  await Hive.openBox<ChatMessage>('messages');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chatbot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/chat': (context) => const ChatScreen(),
        '/history': (context) => const ChatHistoryScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final session = settings.arguments as ChatSession?;

          return MaterialPageRoute(
            builder: (context) => ChatScreen(session: session),
          );
        }
        return null;
      },
    );
  }
}
