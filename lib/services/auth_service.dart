import 'dart:convert';

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/env.dart';
import 'package:chat_app/models/auth_error.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';

class AuthService with ChangeNotifier {
  User user;
  bool _isAuthenticating = false;
  String _authError = '';
  final _storage = FlutterSecureStorage();

  // Static token getter
  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  bool get isAuthenticating => this._isAuthenticating;

  set isAuthenticating(bool value) {
    this._isAuthenticating = value;
    notifyListeners();
  }

  String get authError => this._authError;

  set authError(String value) {
    this._authError = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };
    return this._requestServer(data, 'auth/login');
  }

  Future<bool> register(String name, String email, String password) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
    };
    return this._requestServer(data, 'auth/register');
  }

  Future<bool> _requestServer(Map<String, String> data, String enpoint) async {
    this.isAuthenticating = true;
    final resp = await http.post(
      '${Env.URL}/$enpoint',
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    print(resp.body);
    this.isAuthenticating = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    } else {
      final authError = authErrorFromJson(resp.body);
      this.authError = authError.msg;
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    print(token);
    final resp = await http.get(
      '${Env.URL}/auth/renew',
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );
    print(resp.body);
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    } else {
      await this._delteToken();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _delteToken() async {
    return await _storage.delete(key: 'token');
  }
}
