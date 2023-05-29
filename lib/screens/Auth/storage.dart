import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<dynamic> saveKeyStorage(token, key) async {
    await storage.write(key: key, value: token, aOptions: _getAndroidOptions());
  }

  Future<dynamic> deleteKeyStorage(key) async {
    await storage.delete(key: key, aOptions: _getAndroidOptions());
  }

  Future<dynamic> getKeyStorage(key) async {
    final token = await storage.read(key: key, aOptions: _getAndroidOptions());
    return token ?? 'noData';
  }
}
