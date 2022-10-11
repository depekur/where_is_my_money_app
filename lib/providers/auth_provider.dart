import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

final serverUrl = dotenv.env['SERVER_URL'];

class AuthProvider with ChangeNotifier {
  String _token = '';

  bool get isAuth {
    return _token.isNotEmpty;
  }

  static Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? DateTime.now().toString();
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id ?? DateTime.now().toString();
    } else {
      return DateTime.now().toString();
    }
  }

  Future<void> signIn() async {
    final String deviceId = await AuthProvider.getDeviceId();
    final uri = Uri.parse('${serverUrl}user/sign-in');

    final res = await http.post(
      uri,
      body: json.encode({'deviceId': deviceId}),
      headers: {"Content-Type": "application/json"},
    );

    final body = json.decode(res.body);

    if (body != null) {
      saveToken(body['token']);
    }
  }

  Future<void> saveToken(String token) async {
    _token = token;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _token);

    notifyListeners();
  }
}
