import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:http/http.dart' as http;

import 'package:chat_app/global/env.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';

class ChatService with ChangeNotifier {
  User userTo;

  Future<List<Message>> getChat() async {
    final resp = await http.get(
      '${Env.URL}/messages/${this.userTo.uid}',
      headers: {
        'x-token': await AuthService.getToken(),
      },
    );
    final messagesResponse = messagesResponseFromJson(resp.body);
    return messagesResponse.messages;
  }
}
