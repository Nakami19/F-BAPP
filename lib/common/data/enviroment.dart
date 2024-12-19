import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/data/constants.dart';
import 'package:f_bapp/flavors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment{
  static int headbandColor = 0;
  static String environmentName = '';
  static String imageUrl = dotenv.env['IMAGE_URL']!;
  static String recaptcha = dotenv.env['RECAPTCHA']!;
  static String verificationUrl = dotenv.env['VERIFICATION_URL']!;
  static String ccFbusGateway = FlavorConfig.flavorValues.baseUrl;

  //se carga la informacion de .env
  static initEnviroment() async {
    await dotenv.load(fileName: ".env");
  }

  /// Obtener color de cintillos
  /// [connection] enum con el entorno a utilizar
  static getHeadbandColor(Connection connection) {
    switch (connection) {
      case Connection.developer:
        return headbandColor = developerColor;
      case Connection.qa:
        return headbandColor = qualityColor;
      case Connection.sandbox:
        return headbandColor = qualityColor;
      case Connection.preProduction:
        return headbandColor = productionColor;
      case Connection.production:
        return headbandColor = productionColor;
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
