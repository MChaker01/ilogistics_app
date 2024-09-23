import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ism_two/classes/Token.dart';


class AuthService {
  final String baseUrl = 'http://localhost:8085';

  Future<Token?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mobile/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'login': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Token.fromJson(data);
    } else if (response.statusCode == 401) {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      final String errorMessage = errorData['message'];
      throw Exception(errorMessage);
    } else {
      throw Exception('Erreur lors de la connexion');
    }
  }
}
