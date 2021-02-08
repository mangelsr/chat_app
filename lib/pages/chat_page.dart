import 'dart:io';

import 'package:chat_app/models/messages_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool isTyping = false;

  AuthService authService;
  ChatService chatService;
  SocketService socketService;

  @override
  void initState() {
    super.initState();
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);

    this.socketService.socket.on('message', _listenMessages);
    this._loadMessages();
  }

  _loadMessages() async {
    List<Message> chat = await this.chatService.getChat();
    final history = chat.map((Message e) => ChatMessage(
          text: e.message,
          uid: e.from,
          animationController: AnimationController(
            vsync: this,
            duration: Duration(seconds: 0),
          )..forward(),
        ));
    setState(() {
      this._messages.insertAll(0, history);
    });
  }

  void _listenMessages(dynamic data) {
    final newMessage = ChatMessage(
      uid: data['from'],
      text: data['message'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 250),
      ),
    );
    setState(() {
      this._messages.insert(0, newMessage);
    });
    newMessage.animationController.forward();
  }

  @override
  void dispose() {
    this.socketService.socket.off('message');
    _messages.forEach(
        (ChatMessage element) => element.animationController.dispose());
    super.dispose();
  }

  Widget build(BuildContext context) {
    final userTo = this.chatService.userTo;
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
                userTo.name.substring(0, 2).toUpperCase(),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text(
              userTo.name,
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
        uid: this.authService.user.uid,
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
      this.socketService.socket.emit('message', {
        'from': this.authService.user.uid,
        'to': this.chatService.userTo.uid,
        'message': text,
      });
    }
  }
}
