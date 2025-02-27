import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _singleton = SecureStorage._internal();
  factory SecureStorage() {
    return _singleton;
  }

  SecureStorage._internal();

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  Future<void> write({required String key, required String value}) async {
    return _storage.write(key: key, value: value);
  }

  Future<void> delete({required String key}) async {
    return _storage.delete(key: key);
  }
}
