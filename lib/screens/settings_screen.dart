import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _baseUrlController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _apiKeyController.text = prefs.getString('api_key') ?? '';
        _baseUrlController.text =
            prefs.getString('base_url') ?? 'https://api.openai.com/v1';
        _modelController.text = prefs.getString('model') ?? 'gpt-3.5-turbo';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_key', _apiKeyController.text.trim());
      await prefs.setString('base_url', _baseUrlController.text.trim());
      await prefs.setString('model', _modelController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showApiKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Key Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To use this AI chatbot, you need to:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('1. Get an API key from your AI service provider'),
            Text('2. Enter the API key in the field above'),
            Text('3. Configure the base URL and model'),
            SizedBox(height: 16),
            Text(
              'Popular AI services:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• OpenAI: https://api.openai.com/v1'),
            Text('• Anthropic: https://api.anthropic.com'),
            Text('• Google AI: https://generativelanguage.googleapis.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // API Configuration Section
                  _buildSectionHeader('API Configuration'),
                  const SizedBox(height: 16),

                  // API Key
                  TextFormField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      hintText: 'Enter your API key',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: _showApiKeyDialog,
                      ),
                    ),
                    obscureText: true,
                  ),

                  const SizedBox(height: 16),

                  // Base URL
                  TextFormField(
                    controller: _baseUrlController,
                    decoration: InputDecoration(
                      labelText: 'Base URL',
                      hintText: 'https://api.openai.com/v1',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Model
                  TextFormField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      labelText: 'Model',
                      hintText: 'gpt-3.5-turbo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Save Settings',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Information Section
                  _buildSectionHeader('Information'),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Text(
                              'How to get started',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '1. Sign up for an AI service (OpenAI, Anthropic, etc.)\n'
                          '2. Get your API key from the service dashboard\n'
                          '3. Enter the API key and configure the endpoint\n'
                          '4. Save settings and start chatting!',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.security, color: Colors.orange[700]),
                            const SizedBox(width: 8),
                            Text(
                              'Security Note',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Your API key is stored locally on your device. '
                          'Never share it with others or commit it to version control.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    _modelController.dispose();
    super.dispose();
  }
}
