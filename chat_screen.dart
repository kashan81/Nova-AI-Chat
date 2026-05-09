import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/chat_input_field.dart';
import '../theme/theme_provider.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final chatVM = Provider.of<ChatViewModel>(context, listen: false);
    chatVM.sendMessage(text);
    _textController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // Add a slight delay to allow the list view to render new items
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  void _handleLogout() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    await authVM.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final chatVM = Provider.of<ChatViewModel>(context);
    final isDark = themeProvider.isDarkMode;

    // Automatically scroll to bottom whenever the UI rebuilds with new messages
    _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Study Assistant'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              chatVM.clearChat();
            },
            tooltip: 'Clear Chat',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Log Out',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatVM.messages.isEmpty
                ? const Center(
                    child: Text(
                      'No messages yet. Start chatting!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: chatVM.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatVM.messages[index];
                      return ChatBubble(
                        message: message.message,
                        isUser: message.isUser,
                      );
                    },
                  ),
          ),
          if (chatVM.isLoading) const TypingIndicator(),
          ChatInputField(
            controller: _textController,
            isLoading: chatVM.isLoading,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}


