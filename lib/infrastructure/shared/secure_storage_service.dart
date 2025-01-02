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

// import 'package:f_bapp/app.dart';
// import 'package:f_bapp/common/widgets/shared/snackbars.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SecureStorageService {
//   final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
//     aOptions: AndroidOptions(
//       encryptedSharedPreferences: true, // Cifrado activado
//     ),
//   );

//   Future<String?> getValue(String key) async {
//     try {
//       return await secureStorage.read(key: key);
//     } catch (e) {
//        Snackbars.customSnackbar(
//           navigatorKey.currentContext!,
//           title: 'Error get Value from storage reading key $key',
//           message: e.toString(),
//         );
//       print("Error reading key $key: $e");
//       return null;
//     }
//   }

//   Future<void> setKeyValue(String key, String value) async {
//     try {
//       await secureStorage.write(key: key, value: value);
//     } catch (e) {
//       Snackbars.customSnackbar(
//           navigatorKey.currentContext!,
//           title: 'Error writting key $key',
//           message: e.toString(),
//         );
//       print("Error writing key $key: $e");
//     }
//   }

//   Future<void> deleteValue(String key) async {
//     try {
//       await secureStorage.delete(key: key);
//     } catch (e) {
//       Snackbars.customSnackbar(
//           navigatorKey.currentContext!,
//           title: 'Error deleting key $key',
//           message: e.toString(),
//         );
//       print("Error deleting key $key: $e");
//     }
//   }

//   Future<void> deleteAll() async {
//     try {
//       await secureStorage.deleteAll();
//     } catch (e) {
//       Snackbars.customSnackbar(
//           navigatorKey.currentContext!,
//           title: 'Error deleting all keys',
//           message: e.toString(),
//         );
//       print("Error deleting all keys: $e");
//     }
//   }

//     Future<Map<String, String>?> readAll() async {
//     try {
//       return await secureStorage.readAll();
//     } catch (e) {
//       Snackbars.customSnackbar(
//           navigatorKey.currentContext!,
//           title: 'Error reading all keys',
//           message: e.toString(),
//         );
//       print("Error reading all keys: $e");
//     }
//   }
//   }
