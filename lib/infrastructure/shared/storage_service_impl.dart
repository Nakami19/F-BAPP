import 'package:f_bapp/infrastructure/shared/key_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends KeyValueStorageService {
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case int:
        return prefs.getInt(key) as T?;

      case String:
        return prefs.getString(key) as T?;

      case bool:
        return prefs.getBool(key) as T?;

      default:
        throw UnimplementedError(
            'GET not implemented for type ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case int:
        await prefs.setInt(key, value as int);
        break;

      case String:
        await prefs.setString(key, value as String);
        break;

      case bool:
        await prefs.setBool(key, value as bool);
        break;

      default:
        throw UnimplementedError(
            'Set not implemented for type ${T.runtimeType}');
    }
  }

   /// Método para eliminar todos los datos
  Future<void> deleteAll() async {
    final prefs = await getSharedPrefs();
    final keys = prefs.getKeys(); // Obtener todas las claves almacenadas
    for (String key in keys) {
      await prefs.remove(key); // Eliminar cada clave
    }
  }
}

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class StorageService extends KeyValueStorageService {
//   // Instancia de SecureStorage para datos sensibles
//   final _secureStorage = const FlutterSecureStorage();

//   Future<SharedPreferences> getSharedPrefs() async {
//     return await SharedPreferences.getInstance();
//   }

//   @override
//   Future<T?> getValue<T>(String key, {bool isSensitive = false}) async {
//     if (isSensitive) {
//       // Leer datos sensibles desde SecureStorage
//       final value = await _secureStorage.read(key: key);
//       if (value == null) return null;

//       if (T == int) return int.tryParse(value) as T?;
//       if (T == bool) return (value == 'true') as T?;
//       if (T == String) return value as T?;

//       throw UnimplementedError(
//           'GET not implemented for sensitive type ${T.runtimeType}');
//     } else {
//       // Leer datos normales desde SharedPreferences
//       final prefs = await getSharedPrefs();
//       switch (T) {
//         case int:
//           return prefs.getInt(key) as T?;
//         case String:
//           return prefs.getString(key) as T?;
//         case bool:
//           return prefs.getBool(key) as T?;
//         default:
//           throw UnimplementedError(
//               'GET not implemented for type ${T.runtimeType}');
//       }
//     }
//   }

//   @override
//   Future<bool> removeKey(String key, {bool isSensitive = false}) async {
//     if (isSensitive) {
//       await _secureStorage.delete(key: key);
//       return true;
//     } else {
//       final prefs = await getSharedPrefs();
//       return await prefs.remove(key);
//     }
//   }

//   @override
//   Future<void> setKeyValue<T>(String key, T value,
//       {bool isSensitive = false}) async {
//     if (isSensitive) {
//       // Guardar datos sensibles en SecureStorage
//       String stringValue;
//       if (value is int || value is bool || value is String) {
//         stringValue = value.toString();
//       } else {
//         throw UnimplementedError(
//             'SET not implemented for sensitive type ${T.runtimeType}');
//       }
//       await _secureStorage.write(key: key, value: stringValue);
//     } else {
//       // Guardar datos normales en SharedPreferences
//       final prefs = await getSharedPrefs();
//       switch (T) {
//         case int:
//           await prefs.setInt(key, value as int);
//           break;
//         case String:
//           await prefs.setString(key, value as String);
//           break;
//         case bool:
//           await prefs.setBool(key, value as bool);
//           break;
//         default:
//           throw UnimplementedError(
//               'SET not implemented for type ${T.runtimeType}');
//       }
//     }
//   }

//   Future<void> clearAll({bool isSensitive = false}) async {
//     if (isSensitive) {
//       await _secureStorage.deleteAll();
//     } else {
//       final prefs = await getSharedPrefs();
//       await prefs.clear();
//     }
//   }
// }
