import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  final storage = const FlutterSecureStorage();
  // String? _token;

  factory TokenManager() {
    return _instance;
  }

  Future<void> setToken(String value) async {
    await storage.write(key: 'token', value: value);
    // _token = value;
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> setRole(String value) async {
    await storage.write(key: 'role', value: value);
  }

  Future<String?> getRole() async {
    return await storage.read(key: 'role');
  }

  TokenManager._internal();
}
