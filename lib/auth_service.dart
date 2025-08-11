import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthResult {
  final bool success;
  final String message;

  AuthResult(this.success, this.message);
}

class AuthService {
  static const String _baseUrl = 'https://py-auth.onrender.com';

  static Future<AuthResult> register(
      String name, String email, String password) async {
    final url = Uri.parse('$_baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResult(true, 'Registration successful');
      } else {
        final body = jsonDecode(response.body);
        return AuthResult(false, body['error'] ?? 'Unknown error');
      }
    } catch (e) {
      return AuthResult(false, 'Network error: $e');
    }
  }
}
