import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;

  Future<bool> initSpeech({Function(String)? onStatus}) async {
    if (_isInitialized) return true;
    
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }

    _isInitialized = await _speech.initialize(
      onError: (val) => print('SpeechError: ${val.errorMsg}'),
      onStatus: onStatus,
    );
    return _isInitialized;
  }

  Future<void> startListening(Function(String text) onResult, {Function(String)? onStatus}) async {
    if (!_isInitialized) {
      bool initialized = await initSpeech(onStatus: onStatus);
      if (!initialized) return;
    }

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
}
