import 'package:f_bapp/infrastructure/shared/secure_storage_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionManager {
  final SecureStorageService secureStorageService;

  VersionManager(this.secureStorageService);

  Future<void> handleVersionChange() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.buildNumber;

    final lastVersion = await secureStorageService.getValue("appVersion");

    if (lastVersion != currentVersion) {
      print("Version changed from $lastVersion to $currentVersion");
      
      // Confirmación de eliminación de datos
      try {
        await secureStorageService.deleteAll(); // Limpia datos antiguos
        final allData = await secureStorageService.readAll();
        if (allData!.isNotEmpty) {
          throw Exception("Failed to clear storage.");
        }
        await secureStorageService.setKeyValue("appVersion", currentVersion);
      } catch (e) {
        print("Error during version change handling: $e");
        rethrow; // Lanzamos la excepción para manejarla en el nivel superior
      }
    }
  }
}