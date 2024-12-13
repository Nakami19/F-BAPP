import 'package:flutter/material.dart';

class FilterDefinition {
  final String key; // Clave única para identificar el filtro
  final String hint; // Placeholder para el campo de búsqueda
  final bool Function(dynamic element, String query)? filterLogic; // Lógica de filtro personalizada
  final Icon? icon; // Icono opcional

  FilterDefinition({
    required this.key,
    required this.hint,
    this.filterLogic,
    this.icon,
  });
}