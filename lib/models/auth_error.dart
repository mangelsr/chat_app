// To parse this JSON data, do
//
//     final loginError = loginErrorFromJson(jsonString);

import 'dart:convert';

AuthError authErrorFromJson(String str) => AuthError.fromJson(json.decode(str));

String authErrorToJson(AuthError data) => json.encode(data.toJson());

class AuthError {
  AuthError({
    this.ok,
    this.msg,
  });

  bool ok;
  String msg;

  factory AuthError.fromJson(Map<String, dynamic> json) => AuthError(
        ok: json["ok"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
      };
}
