import 'package:intl/intl.dart';

String dateFormattedFromDateTime(DateTime dateTime) {
  Duration duration = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch));
  DateTime hoy = DateTime.now();
  String diaHoy = DateFormat.d('es').format(hoy);
  String dia = DateFormat.d('es').format(dateTime);
  String mes = DateFormat.M('es').format(dateTime);
  String mesHoy = DateFormat.M('en').format(hoy);
  String year = DateFormat.y('es').format(dateTime);
  String yearHoy = DateFormat.y('es').format(hoy);

  if (duration.inMinutes == 0) {
    return "Justo ahora";
  } else if (duration.inMinutes < 60 && duration.inMinutes > 0) {
    int mins = duration.inMinutes;
    return "Hace ${mins.floor()} ${mins.floor() == 1 ? "min" : "mins"}";
  } else if (duration.inHours <= 3 && duration.inMinutes > 0) {
    int horas = duration.inHours;
    return "Hace ${horas.floor()} ${horas.floor() == 1 ? "hora" : "horas"}";
  } else if (diaHoy == dia &&
      mesHoy == mes &&
      yearHoy == year &&
      duration.inMinutes > 0) {
    String horaFormatted = DateFormat.jm('en').format(dateTime);
    horaFormatted = horaFormatted.replaceAll('AM', 'a.m.');
    horaFormatted = horaFormatted.replaceAll('PM', 'p.m.');
    return "Hoy, $horaFormatted";
  } else if (((int.parse(diaHoy) - 1 == (int.parse(dia))) ||
          (int.parse(diaHoy) == (int.parse(dia) - 30)) ||
          (int.parse(diaHoy) == (int.parse(dia) - 29))) &&
      duration.inDays < 2 &&
      duration.inDays >= 0) {
    String horaFormatted = DateFormat.jm('en').format(dateTime);
    horaFormatted = horaFormatted.replaceAll('AM', 'a.m.');
    horaFormatted = horaFormatted.replaceAll('PM', 'p.m.');
    return "Ayer, $horaFormatted ";
  } else if (duration.inDays >= 2 &&
      duration.inDays < 7 &&
      duration.inMinutes > 0) {
    String fechaFormatted = DateFormat.EEEE('es').format(dateTime);
    String horaFormatted = DateFormat.jm('en').format(dateTime);
    String diaFormatted = DateFormat.d('en').format(dateTime);
    horaFormatted = horaFormatted.replaceAll('AM', 'a.m.');
    horaFormatted = horaFormatted.replaceAll('PM', 'p.m.');
    fechaFormatted = fechaFormatted.replaceAll('.', '');
    String mayusc = fechaFormatted.toUpperCase().substring(0, 1);
    fechaFormatted = fechaFormatted.replaceRange(0, 1, mayusc);
    return "$fechaFormatted $diaFormatted, $horaFormatted ";
  } else if (duration.inHours / 24 < 30 && duration.inMinutes > 0) {
    double dias = duration.inHours / 24;
    return "Hace ${dias.floor()} ${dias.floor() == 1 ? "día" : "días"}";
  } else if (duration.inHours / (24 * 30) < 12 && duration.inMinutes > 0) {
    double meses = duration.inHours / (24 * 30);
    return "Hace ${meses.floor()} ${meses.floor() == 1 ? "mes" : "meses"}";
  } else if (duration.inDays > 365 && duration.inMinutes > 0) {
    double years = duration.inHours / (24 * 30 * 12);
    return "Hace ${years.floor()} ${years.floor() == 1 ? "año" : "años"}";
  } else if (diaHoy == dia && mesHoy == mes && yearHoy == year) {
    String horaFormatted = DateFormat.jm('en').format(dateTime);
    horaFormatted = horaFormatted.replaceAll('AM', 'a.m.');
    horaFormatted = horaFormatted.replaceAll('PM', 'p.m.');
    return "Hoy, $horaFormatted ";
  } else if ((-duration.inDays >= 1 && -duration.inDays < 6) &&
      ((int.parse(diaHoy) + 1 != (int.parse(dia))) &&
              (int.parse(diaHoy) != (int.parse(dia) + 30)) ||
          (int.parse(diaHoy) != (int.parse(dia) + 29)))) {
    String fechaFormatted = DateFormat.EEEE('es').format(dateTime);
    String diaFormatted = DateFormat.d('en').format(dateTime);
    String horaFormatted = DateFormat.jm('en').format(dateTime);
    horaFormatted = horaFormatted.replaceAll('AM', 'a.m.');
    horaFormatted = horaFormatted.replaceAll('PM', 'p.m.');
    fechaFormatted = fechaFormatted.replaceAll('.', '');
    String mayusc = fechaFormatted.toUpperCase().substring(0, 1);
    fechaFormatted = fechaFormatted.replaceRange(0, 1, mayusc);
    return "$fechaFormatted $diaFormatted, $horaFormatted ";
  } else if (((int.parse(diaHoy) + 1 == (int.parse(dia))) ||
          (int.parse(diaHoy) == (int.parse(dia) + 30)) ||
          (int.parse(diaHoy) == (int.parse(dia) + 29))) &&
      (duration.inDays == -1 || duration.inDays == 0)) {
    String horaFormatted = DateFormat.jm('en').format(dateTime);
    horaFormatted = horaFormatted.replaceAll('AM', 'a.m.');
    horaFormatted = horaFormatted.replaceAll('PM', 'p.m.');
    return "Mañana, $horaFormatted ";
  } else if (-duration.inDays >= 6 && (int.parse(yearHoy) == int.parse(year))) {
    String fechaFormatted = DateFormat.MMMd('es').format(dateTime);
    String horaFormatted = DateFormat.jm('en').format(dateTime);
    horaFormatted = horaFormatted.replaceAll('AM', 'a.m.');
    horaFormatted = horaFormatted.replaceAll('PM', 'p.m.');
    fechaFormatted = fechaFormatted.replaceAll('.', '');
    return "$fechaFormatted, $horaFormatted";
  } else if (int.parse(yearHoy) != int.parse(year)) {
    String fechaFormatted = DateFormat.yMMMMd('es').format(dateTime);
    String horaFormatted = DateFormat.jm('en').format(dateTime);
    horaFormatted = horaFormatted.replaceAll('AM', 'a.m.');
    horaFormatted = horaFormatted.replaceAll('PM', 'p.m.');
    return "$fechaFormatted, $horaFormatted";
  } else {
    String horaFormatted = DateFormat.jm('en').format(dateTime);
    String fechaFormatted = DateFormat.MMMd('es').format(dateTime);
    String diaFormatted = DateFormat.d('en').format(dateTime);
    horaFormatted = horaFormatted.replaceAll('AM', 'a.m.');
    horaFormatted = horaFormatted.replaceAll('PM', 'p.m.');
    fechaFormatted = fechaFormatted.replaceAll('.', '');
    return "$fechaFormatted $diaFormatted, $horaFormatted ";
  }
}
