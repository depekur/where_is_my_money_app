import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final serverUrl = dotenv.env['SERVER_URL'];

class HttpService {
  static Future<dynamic> get(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');

    final uri = Uri.parse('$serverUrl$url');

    try {
      final res = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      return json.decode(res.body);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> post(String url, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');

    final uri = Uri.parse('$serverUrl$url');
    final requestData = json.encode(data);

    try {
      final res = await http.post(
        uri,
        body: requestData,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      final body = json.decode(res.body);

      return body;
    } catch (e) {
      rethrow;
    }
  }
}
