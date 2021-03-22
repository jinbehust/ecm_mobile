import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const SERVER_IP = 'http://192.168.0.108:8181/api/';
  static const URL_LOGIN = "${SERVER_IP}users/login";
  final storage = FlutterSecureStorage();
  String token = '';

  // ignore: type_annotate_public_apis
  loginData(String email, String password) async {
    var url = "$URL_LOGIN?userName=$email&password=$password";
    try {
      final response = await http.post(url, body: '');
      var data = json.decode(response.body);
      var status = response.statusCode == 200;
      if (status) {
        print("Login sucesss -----------");
        if (data["data"] != null) {
          _save(data["data"]["tokenInfo"].toString());
        }
        print(data["data"]["tokenInfo"]);
      } else {
        print("Fail login ....");
        print('data : ${data["tokenInfo"]}');
        print('data : ${data["error"]}');
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print(e);
      return false;
    }
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  // ignore: type_annotate_public_apis
  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }
}
