import 'dart:convert';

/// Clase para codificar/decodificar a base64
class Base64Encoder {
  // Codificar base64
  static String encodeBase64(String value) {
    return base64.encode(utf8.encode(value));
  }

  // Decodificar base64
  static String decodeBase64(String value) {
    // Obtener lista de bytes
    final decoded = base64.decode(value);

    // Retornar string
    return utf8.decode(decoded);
  }
}