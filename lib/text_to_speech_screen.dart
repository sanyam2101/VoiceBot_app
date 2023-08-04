import 'package:flutter/material.dart';
import 'package:flutter_voice_app/tts.dart';

class TTSScreen extends StatelessWidget {
  const TTSScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: const Text("Text to Speech"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: textController,
          ),
          ElevatedButton(
              onPressed: (){
                TextSpeech.speak(textController.text);
              },
              child: const Text("Speak"))
        ],
      ),
    );
  }
}
