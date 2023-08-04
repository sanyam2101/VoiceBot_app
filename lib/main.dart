import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_voice_app/speech_screen.dart';
import 'package:flutter_voice_app/text_to_speech_screen.dart';
import 'package:flutter_voice_app/tts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  TextSpeech.initTTS();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speech to Text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SpeechScreen(),
    );
  }
}
