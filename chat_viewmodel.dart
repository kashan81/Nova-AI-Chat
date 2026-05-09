import 'dart:async';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/gemini_service.dart';
import '../services/supabase_service.dart';

class ChatViewModel extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final SupabaseService _supabaseService = SupabaseService();

  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StreamSubscription? _streamSubscription;

  ChatViewModel() {
    // Listen to the real-time stream from Supabase
    _streamSubscription = _supabaseService.getMessagesStream().listen((data) {
      _messages = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty || _isLoading) return;

    // Optimistic UI: instantly add user message to the screen
    final userMessage = MessageModel(
      message: text,
      isUser: true,
      createdAt: DateTime.now(),
    );
    
    // Create a brand new list so Flutter definitively knows the state changed
    _messages = List.from(_messages)..add(userMessage);
    _setLoading(true);

    try {
      // 1. Save user message to Supabase
      await _supabaseService.saveMessage(userMessage);

      // 2. Call Gemini API
      final String response = await _geminiService.sendMessage(text);

      // 3. Save AI response to Supabase
      final aiMessage = MessageModel(
        message: response,
        isUser: false,
        createdAt: DateTime.now(),
      );
      await _supabaseService.saveMessage(aiMessage);
      
      // Optimistic UI for AI message in case Realtime isn't configured
      _messages = List.from(_messages)..add(aiMessage);
    } catch (e) {
      print("Error in sendMessage: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearChat() async {
    _messages.clear();
    notifyListeners();
    await _supabaseService.clearChat();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

