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
