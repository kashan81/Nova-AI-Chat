import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Replace with your actual Gemini API key
  static const String _apiKey = 'Enter your key';

  GenerativeModel? _model;
  ChatSession? _chatSession;

  // Initialize a new chat session with a specific system instruction (personality)
  void initSession(String systemInstructionText) {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: _apiKey,
      systemInstruction: Content.system(systemInstructionText),
    );
    _chatSession = _model!.startChat();
  }

  // Send a message within the current chat context
  Future<String> sendMessage(String text) async {
    try {
      if (_chatSession == null) {
        return "Error: Chat session not initialized. Please select a mode.";
      }
      final response = await _chatSession!.sendMessage(Content.text(text));
      return response.text ?? "No response from AI.";
    } catch (e) {
      print("Gemini API Error: $e");
      return "Unable to get response. Please check your network and API key. Error: $e";
    }
  }

  // Generate text without chat context (used for summarization or quizzes)
  Future<String> generateText(String prompt) async {
    try {
      final tempModel = GenerativeModel(
        model: 'gemini-2.5-flash-lite',
        apiKey: _apiKey,
      );
      final response = await tempModel.generateContent([Content.text(prompt)]);
      return response.text ?? "Failed to generate text.";
    } catch (e) {
      print("Gemini API Error (generateText): $e");
      throw Exception("Unable to generate text.");
    }
  }
}
