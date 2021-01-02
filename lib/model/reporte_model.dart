import 'package:manda2/model/user_model.dart';

class Reporte {
  Reporte(
      {this.id,
      this.reportante,
      this.comentario,
      this.fecha,
      this.tipoReporte});

  String id;
  User reportante;
  String comentario;
  String tipoReporte;
  DateTime fecha;
}
