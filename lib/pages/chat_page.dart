import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final List<ChatMessage> _messages = [
    //   ChatMessage(uid: '123', text: 'Hello Test1'),
    //   ChatMessage(uid: '123', text: 'Hello Test1'),
    //   ChatMessage(uid: '123', text: 'Hello Test1'),
    //   ChatMessage(uid: '458', text: 'Hello Miguel'),
  ];
  bool isTyping = false;

  @override
  void dispose() {
    // TODO: Close socket
    _messages.forEach(
        (ChatMessage element) => element.animationController.dispose());
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 15,
              child: Text(
                'TE',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text(
              'Test1',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, int i) => _messages[i],
                reverse: true,
              ),
            ),
            Divider(height: 2),
            Container(
              color: Colors.white,
              child: _buildChatInput(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (String value) {
                // TODO: Check if value is not empty
                setState(() {
                  isTyping = value.trim().isNotEmpty;
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Send message',
              ),
              focusNode: _focusNode,
            ),
          ),
          // Send button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Send'),
                    onPressed: () {},
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        onPressed: this.isTyping
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    ));
  }

  _handleSubmit(String text) {
    if (this.isTyping) {
      _textController.clear();
      _focusNode.requestFocus();
      final newMessage = ChatMessage(
        uid: '123',
        text: text,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 250),
        ),
      );
      this._messages.insert(0, newMessage);
      newMessage.animationController.forward();
      setState(() {
        this.isTyping = false;
      });
    }
  }
}
