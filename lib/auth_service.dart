import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  AuthResult(this.success, this.message, {this.data});
}

class AuthService {
  static const String _baseUrl = 'https://py-auth.onrender.com';

  /// Register
  static Future<AuthResult> register(
    String name,
    String email,
    String password,
  ) async {
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

  /// Login
  static Future<AuthResult> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

         final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode({'image': 'https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D', ...data}));
        
        return AuthResult(true, 'Login successful', data: data);
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
        return AuthResult(false, error);
      }
    } catch (e) {
      return AuthResult(false, 'Network error: $e');
    }
  }

  /// Load stored user data
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }

  /// Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
