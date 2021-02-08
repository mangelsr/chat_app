import 'dart:io';

class Env {
  static String _ANDROID = '10.0.2.2';
  static String _IOS = 'localhost';
  static String _PORT = '3000';

  static String URL =
      'http://${Platform.isAndroid ? _ANDROID : _IOS}:$_PORT/api';

  static String SOCKETURL =
      'http://${Platform.isAndroid ? _ANDROID : _IOS}:$_PORT';
}
