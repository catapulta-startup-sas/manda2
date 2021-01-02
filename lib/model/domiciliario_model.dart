import 'package:manda2/model/user_model.dart';

class Domiciliario {
  User user;
  int numPedidos;
  int cantidadCalificaciones;
  double califPromedio;
  bool hasReviewedDomis;
  String dniNumber;
  String dniType;
  String vehiculo;
  String banco;
  String numeroCuentaBancaria;
  String tipoCuentaBancaria;
  Map<String, dynamic> estadisticaParcial;
  Map<String, dynamic> estadisticaTotal;

  Domiciliario({
    this.user,
    this.numPedidos,
    this.cantidadCalificaciones,
    this.califPromedio,
    this.hasReviewedDomis,
    this.dniNumber,
    this.dniType,
    this.vehiculo,
    this.banco,
    this.numeroCuentaBancaria,
    this.tipoCuentaBancaria,
  });
}
