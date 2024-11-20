import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  FlutterSecureStorage _getSecureStorage() {
    return const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
  }

  // Leer valor individual
  Future getValue(String key) async {
    final secureStorage = _getSecureStorage();
    final value = await secureStorage.read(key: key);
    return value;
  }

  // Leer todos
  Future<Map<String, String>> readAll() async {
    final secureStorage = _getSecureStorage();
    final data = await secureStorage.readAll();
    return data;
  }

  // Guardar valor
  Future<void> setKeyValue(String key, dynamic value) async {
    final secureStorage = _getSecureStorage();
    await secureStorage.write(key: key, value: value);
  }

  // Borrar valor
  Future<void> deleteValue(String key) async {
    final secureStorage = _getSecureStorage();
    secureStorage.delete(key: key);
  }

  // Borrar todos
  Future<void> deleteAll() async {
    final secureStorage = _getSecureStorage();
    await secureStorage.deleteAll();
  }
}