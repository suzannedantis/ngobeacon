import 'package:flutter/material.dart';
import 'package:ngobeacon/chat_screen.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
      },
      backgroundColor: Colors.blue[900],
      shape: CircleBorder(),
      child: Icon(Icons.chat, color: Colors.white),
    );
  }
}
