import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';
import '../models/quiz_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // Save a message to Supabase
  Future<void> saveMessage(MessageModel message) async {
    if (_currentUserId == null) return;
    
    try {
      final messageMap = message.toMap();
      messageMap['user_id'] = _currentUserId;
      
      await _client.from('chats').insert(messageMap);
    } catch (e) {
      print('Error saving message to Supabase: $e');
      throw Exception('Supabase Error: $e');
    }
  }

  // Get real-time stream of messages for the logged-in user and specific mode
  Stream<List<MessageModel>> getMessagesStream(String mode) {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _client
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('user_id', _currentUserId!)
        .eq('mode', mode) // Filter by AI mode
        .order('created_at', ascending: true)
        .map((List<Map<String, dynamic>> data) {
          return data.map((map) => MessageModel.fromMap(map)).toList();
        });
  }

  // Clear chat history for the logged-in user and specific mode
  Future<void> clearChat(String mode) async {
    if (_currentUserId == null) return;
    
    try {
      await _client
          .from('chats')
          .delete()
          .eq('user_id', _currentUserId!)
          .eq('mode', mode);
    } catch (e) {
      print('Error clearing chat in Supabase: $e');
    }
  }

  // Save a chat summary
  Future<void> saveSummary(String summaryText) async {
    if (_currentUserId == null) return;

    try {
      await _client.from('summaries').insert({
        'user_id': _currentUserId,
        'summary_text': summaryText,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error saving summary to Supabase: $e');
      throw Exception('Supabase Error: $e');
    }
  }

  // Save a quiz result
  Future<void> saveQuizResult(QuizModel quiz) async {
    if (_currentUserId == null) return;

    try {
      final quizMap = quiz.toMap();
      quizMap['user_id'] = _currentUserId;
      await _client.from('quizzes').insert(quizMap);
    } catch (e) {
      print('Error saving quiz to Supabase: $e');
      throw Exception('Supabase Error: $e');
    }
  }
}
