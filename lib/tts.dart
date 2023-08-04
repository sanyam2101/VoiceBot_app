
import 'package:text_to_speech/text_to_speech.dart';

class TextSpeech{
  static TextToSpeech tts = TextToSpeech();

  static initTTS(){
    tts.setLanguage("en-US");
    tts.setPitch(1.0);
    tts.setRate(0.7);
    tts.setVolume(10);
  }

  static speak(String text) async {
    // tts.setStartHandler(() {
    //   print("TTS IS STARTED");
    // });
    //
    // tts.setCompletionHandler((){
    //   print("COMPLETED");
    // });
    //
    // tts.setErrorHandler((message){
    //   print(message);
    // });

    //await tts.getVoice();

    tts.speak(text);
  }
}