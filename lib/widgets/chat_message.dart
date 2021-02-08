import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    @required this.text,
    @required this.uid,
    @required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context, listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
        child: Container(
          child: this.uid == authService.user.uid
              ? _buildMyMessage()
              : _buildOtherMessage(),
        ),
      ),
    );
  }

  Widget _buildMyMessage() => _buildMessage(
        Alignment.centerRight,
        EdgeInsets.only(
          right: 10,
          bottom: 5,
          left: 50,
        ),
        Color(0xff4D9EF6),
        Colors.white,
      );

  Widget _buildOtherMessage() => _buildMessage(
        Alignment.centerLeft,
        EdgeInsets.only(
          right: 50,
          bottom: 5,
          left: 10,
        ),
        Color(0xffE4E5E8),
        Colors.black87,
      );

  Widget _buildMessage(Alignment alignment, EdgeInsets edgeInsets,
          Color bubblecColor, Color textColor) =>
      Align(
        alignment: alignment,
        child: Container(
          padding: EdgeInsets.all(8),
          margin: edgeInsets,
          decoration: BoxDecoration(
            color: bubblecColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            this.text,
            style: TextStyle(color: textColor),
          ),
        ),
      );
}
