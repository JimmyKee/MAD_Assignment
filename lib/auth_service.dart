import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String name;
  final String role; // e.g., 'inventory'
  const User({required this.id, required this.name, required this.role});
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  // Fake users (demo)
  final Map<String, Map<String, String>> _users = {
    'INV1001': {
      'pw': 'inventory123',
      'name': 'Aisyah',
      'role': 'inventory',
    },
    'parts.lead@greenstem.com': {
      'pw': 'inventory123',
      'name': 'Ken',
      'role': 'inventory',
    },
  };

  static const _kSessionKey = 'session_user_id';

  Future<bool> signIn(String id, String pw, {bool remember = true}) async {
    final rec = _users[id.trim()];
    if (rec == null || rec['pw'] != pw) return false;

    if (remember) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kSessionKey, id.trim());
    }
    return true;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSessionKey);
  }

  Future<User?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_kSessionKey);
    if (id == null) return null;
    final rec = _users[id];
    if (rec == null) return null;
    return User(id: id, name: rec['name']!, role: rec['role']!);
  }

  Future<bool> isSignedIn() async => (await currentUser()) != null;
}
