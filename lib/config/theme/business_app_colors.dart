import 'dart:ui';

import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:flutter/material.dart';

    //Colores para los estados (Activo, Pagado...)
  final Map<String, Color> statusColors = {
    "Pendiente": Color(0xff02a8f5),
    "Exitosa": primaryColor,
    "RECHAZADO": Color(0xffff0000),
    "ACTIVO": Color(0xff02a8f5),
    "PAGADA": primaryColor,
    "PAGADA CON SOBRANTE": Colors.green,
    "PAGADA CON FALTANTE": Colors.orange,
    "EXPIRADA": Color(0xff595959),
    "REVERSADA": Color.fromARGB(219, 246, 195, 26),
    'Confirmada': primaryColor,
    "Por Confirmar":const Color.fromARGB(219, 246, 195, 26),
    'APROBADO': primaryColor,
    'POR CARGAR': Colors.grey,
    'FINALIZADO': Color(0xff02a8f5),
    'PROCESANDO': Color(0xff02a8f5),
    'REVISIÓN MANUAL': Color.fromARGB(219, 246, 195, 26)
  };

  //Convertir string a color
  Color hexToColor(String hexColor) {
  final colorString = hexColor.replaceAll('#', '');
  return Color(int.parse('0xff$colorString'));
}

