import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voice_app/api_services.dart';
import 'package:flutter_voice_app/chat_model.dart';
import 'package:flutter_voice_app/colors.dart';
import 'package:flutter_voice_app/tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();

  var text = "Hold the button and start speaking";
  var isListening = false;

  final List<ChatMessage> messages = [];

  var scrollController = ScrollController();

  scrollMethod(){
    scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening){
              var available = await speechToText.initialize();
              if(available){
                setState(() {
                  isListening = true;
                  speechToText.listen(
                      onResult: (result){
                        setState(() {
                          text = result.recognizedWords;
                        });
                    }
                  );
                });
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListening = false;
            });
            await speechToText.stop();

            if(text.isNotEmpty && text != "Hold the button and start speaking"){
              messages.add(ChatMessage(text: text, type: ChatMessageType.user));
              var msg = await ApiServices.sendMessage(text);
              msg = msg.trim();

              setState(() {
                messages.add(ChatMessage(text: msg, type: ChatMessageType.bot));
              });
              Future.delayed(Duration(milliseconds: 500),(){
                TextSpeech.speak(msg);
              });

            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to process. Try again!")));
            }
          },
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(isListening ? Icons.mic : Icons.mic_none, color: Colors.white,),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: const Icon(Icons.sort_rounded,color: Colors.white,),
        backgroundColor: bgColor,
        title: const Text(
          "Voice Assistant",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: isListening ? Colors.black87 : Colors.black54
              ),
            ),
            const SizedBox(height: 12,),
            Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: chatBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
                  child: ListView.builder(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: messages.length,
                      itemBuilder: (context, index){
                      var chat = messages[index];
                      return chatBubble(
                        chatText: chat.text,
                        type: chat.type,
                      );
                      }),
            )
            ),
            const SizedBox(height: 12,),
            const Text(
              "Developed by Sanyam Singhal",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Widget chatBubble({required chatText, required ChatMessageType? type}){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       CircleAvatar(
        backgroundColor: bgColor,
        child: type == ChatMessageType.bot
            ? const Icon(Icons.flutter_dash, color: Colors.white,)
            : const Icon(Icons.person, color: Colors.white,),
      ),
      const SizedBox(width: 12,),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 8, top: 5, right: 8),
          decoration: BoxDecoration(
            color: type == ChatMessageType.bot
                ? bgColor
                : Colors.white60,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12))
          ),
          child: Text(
            "$chatText",
            style: TextStyle(
              color: type == ChatMessageType.bot
                  ? Colors.white
                  : Colors.black,
              fontSize: 15,
              fontWeight: type == ChatMessageType.bot
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ),
      ),
    ],
  );
}
