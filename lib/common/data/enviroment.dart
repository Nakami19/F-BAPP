import 'package:f_bapp/common/data/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static int headbandColor = 0;
  static String environmentName = '';


  static   initEnviroment() async {
    await dotenv.load(fileName: ".env");
  }

  /// Obtener color de cintillos
  /// [connection] enum con el entorno a utilizar
  static getHeadbandColor(Connection connection) {
    switch (connection) {
      case Connection.developer:
        return headbandColor = DEVELOPER_COLOR;
      case Connection.qa:
        return headbandColor = QUALITY_COLOR;
      case Connection.sandbox:
        return headbandColor = QUALITY_COLOR;
      case Connection.preProduction:
        return headbandColor = PRODUCTION_COLOR;
      case Connection.production:
        return headbandColor = PRODUCTION_COLOR;
    }
  }

  /// Obtener url según el entorno
  /// [connection] enum con el entorno a utilizar
  static String getUrl(Connection connection) {
    switch (connection) {
      case Connection.developer:
        environmentName = 'Developer';
        return dotenv.env['DEVELOPER']!;
      case Connection.qa:
        environmentName = 'Quality';
        return dotenv.env['QA']!;
      case Connection.sandbox:
        environmentName = 'Sandbox';
        return dotenv.env['SANDBOX']!;
      case Connection.preProduction:
        environmentName = 'PREPRODUCTION';
        return dotenv.env['PREPRODUCTION']!;
      case Connection.production:
        environmentName = '';
        return dotenv.env['PRODUCTION']!;
    }
  }
}
