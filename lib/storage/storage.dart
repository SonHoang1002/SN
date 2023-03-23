import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  Future<dynamic> saveKeyStorage(value, key) async {
    await storage.write(key: key, value: value);
  }

  Future<dynamic> deleteKeyStorage(key) async {
    await storage.delete(key: key);
  }

  Future<dynamic> getKeyStorage(key) async {
    final value = await storage.read(key: key);
    return value ?? 'noData';
  }
}