import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy, hh:mm a').format(date.toLocal());
  }

  static String formatDateWithOutTZ(String date) {
    String dateTime = date;
    // String datetime UTC zone

    DateTime parsedDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
        .parseUTC(dateTime)
        .toLocal(); // parse String datetime to DateTime and get local date time

    // TODO esta logica (jhoel) es para convertir la fecha a dia mes año (debe haber otra forma con el DateFormat y el location pero no encontre ninguno que fuese igual al que queria, REVISAR)

    String splitedDate =
        DateFormat.yMd().add_jm().format(parsedDateFormat).toString();

    // fecha
    String date2 = splitedDate.split(' ')[0];

    // hora
    String time = splitedDate.split(' ')[1];

    // am, pm
    String timeAmPm = splitedDate.split(' ')[2];

    // dia, mes, año
    String date3 =
        '${date2.split('/')[1]}/${date2.split('/')[0]}/${date2.split('/')[2]}';

    // rETORNO Fecha, tiempo y am/pm
    return '$date3, $time $timeAmPm';

  }

  // Dar formato a fecha devuelta por el datePicker
  static String formatDatePicker(DateTime date, String format) {
    return DateFormat(format).format(date);
    
  }

  // Devuelve la fecha en formato yyyy/MM/dd
  static String formatDate2(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date.toLocal());
  }
}