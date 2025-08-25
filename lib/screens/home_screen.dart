import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'chat_screen.dart';
import 'chat_history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(
                context,
              ).colorScheme.primary.withAlpha((0.8 * 255).floor()),
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.2 * 255).floor()),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.smart_toy,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // App Title
                  const Text(
                    'AI Chatbot',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // App Description
                  const Text(
                    'Your intelligent conversation partner',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 64),

                  // New Chat Button
                  _buildActionButton(
                    context,
                    title: 'Start New Chat',
                    subtitle: 'Begin a conversation with AI',
                    icon: Icons.chat_bubble_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Chat History Button
                  _buildActionButton(
                    context,
                    title: 'Chat History',
                    subtitle: 'View your previous conversations',
                    icon: Icons.history,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatHistoryScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Settings Button
                  _buildActionButton(
                    context,
                    title: 'Settings',
                    subtitle: 'Configure API and preferences',
                    icon: Icons.settings,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 48),

                  // Features List
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.1 * 255).floor()),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withAlpha((0.2 * 255).floor()),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Features',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          icon: Icons.image,
                          text: 'Upload images & documents',
                        ),
                        _buildFeatureItem(
                          icon: Icons.storage,
                          text: 'Local chat storage',
                        ),
                        _buildFeatureItem(
                          icon: Icons.chat_bubble,
                          text: 'Smart AI responses',
                        ),
                        _buildFeatureItem(
                          icon: Icons.search,
                          text: 'Search chat history',
                        ),
                        _buildFeatureItem(
                          icon: Icons.stream,
                          text: 'Real-time streaming',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.1 * 255).floor()),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withAlpha((0.2 * 255).floor()),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.2 * 255).floor()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha((0.8 * 255).floor()),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withAlpha((0.6 * 255).floor()),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
