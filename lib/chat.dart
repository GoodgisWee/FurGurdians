import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];

  TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isEmpty) {
      return;
    }
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: _controller.text,
          time: DateTime.now(),
        ),
      );
    });
    _controller.clear();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.lightBlue,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.0), // Adjust as needed
            child: Icon(Icons.android, size: 32, color: Colors.white,), // Example icon, replace with 'Mr Paw' icon
          ),
          Text('Mr Paw', style: TextStyle(color: Colors.white),),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _buildMessage(_messages[index]);
            },
          ),
        ),
        Divider(height: 1),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ],
    ),
  );
}


  Widget _buildMessage(ChatMessage message) {
  final isMe = message.isMe;
  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.text),
          SizedBox(height: 4),
          Text(
            '${message.time.hour}:${message.time.minute.toString().padLeft(2,'0')}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    ),
  );
}



  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration.collapsed(hintText: 'Send a message'),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final DateTime time;
  final bool isMe; // Added field to identify messages from the current user

  ChatMessage({
    required this.text,
    required this.time,
    this.isMe = true, // Default is false (message from others)
  });
}

