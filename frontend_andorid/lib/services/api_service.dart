import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static Future<http.Response> postChatBudaya(Map<String, dynamic> body) {
    final url = Uri.parse('$BACKEND_URL/chat_budaya');
    return http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> postPredictSentiment(Map<String, dynamic> body) {
    final url = Uri.parse('$BACKEND_URL/predict_sentiment');
    return http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }
}
