String ago(String startDateString) {
  Duration duration = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(int.parse(startDateString)));
  if (duration.inMinutes <= 0) {
    return "Justo ahora";
  } else if (duration.inMinutes <= 60) {
    int mins = duration.inMinutes;
    return "Hace ${mins.floor()} ${mins.floor() == 1 ? "min" : "mins"}";
  } else if (duration.inHours < 24) {
    int horas = duration.inHours;
    return "Hace ${horas.floor()} ${horas.floor() == 1 ? "hora" : "horas"}";
  } else if (duration.inHours / 24 < 30) {
    double dias = duration.inHours / 24;
    return "Hace ${dias.floor()} ${dias.floor() == 1 ? "día" : "días"}";
  } else if (duration.inHours / (24 * 30) < 12) {
    double meses = duration.inHours / (24 * 30);
    return "Hace ${meses.floor()} ${meses.floor() == 1 ? "mes" : "meses"}";
  } else {
    double years = duration.inHours / (24 * 30 * 12);
    return "Hace ${years.floor()} ${years.floor() == 1 ? "año" : "años"}";
  }
}
