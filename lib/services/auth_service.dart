import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String emailKey = 'email';
  static const String loginKey = 'isLoggedIn';

  static Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(emailKey, email);
    await prefs.setBool(loginKey, true);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(loginKey) ?? false;
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(emailKey) ?? '';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(emailKey);
    await prefs.setBool(loginKey, false);
  }
}