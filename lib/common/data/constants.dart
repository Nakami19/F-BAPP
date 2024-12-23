// Tipo de conexión 
enum Connection {
  developer,
  qa,
  sandbox,
  preProduction,
  production,
}

//version de la app y build
class Constants{
  static String? appVersion;
  static String? buildNumber;
}

//tipo de documento de identidad
List<String> typeDocuments = [
  'V',
  'J',
  'G',
  'E',
  'P',
  'Cancelar', // Cancelar
];

final phoneRegex = RegExp(r'^(0424|0414|0412|0426|0416|424|414|412|426|416)[0-9]{6}$');
