// Tipo de conexión
// ignore_for_file: constant_identifier_names

enum Connection {
  developer,
  qa,
  sandbox,
  preProduction,
  production,
}
class Constants{
  static String? appVersion;
  static String? buildNumber;
}

List<String> typeDocuments = [
  'V',
  'J',
  'G',
  'E',
  'P',
  'Cancelar', // Cancelar
];

// Color de cintillos
const DEVELOPER_COLOR = 0xFF2B4B2C;
const QUALITY_COLOR = 0xFFF0C200;
const PRODUCTION_COLOR = 0x00000000;