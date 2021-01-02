import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/model/domiciliario_model.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/model/user_model.dart';

import 'calificacion_model.dart';

class Mandado {
  User user;
  String id;
  String identificador;
  Categoria categoria;

  Review review;

  Domiciliario domiciliario;

  bool isTomado;
  bool isRecogido;
  bool isEntregado;
  bool isCalificado;

  bool isHidden;

  Lugar origen;
  Lugar destino;

  String descripcion;

  String tipoPago;
  int total;

  DateTime fechaMaxEntrega;

  String fechaMaxEntregaStringFormatted;
  String horaMaxEntregaStringFormatted;

  int cuotas;
  String cardType;
  String lastFourDigits;

  int tomadoDateTimeMSE;
  int recogidoDateTimeMSE;
  int entregadoDateTimeMSE;
  int createdDateTimeMSE;

  Mandado({
    this.id,
    this.total,
    this.fechaMaxEntrega,
    this.tomadoDateTimeMSE,
    this.recogidoDateTimeMSE,
    this.entregadoDateTimeMSE,
    this.createdDateTimeMSE,
    this.domiciliario,
    this.isCalificado,
    this.descripcion,
    this.tipoPago,
    this.fechaMaxEntregaStringFormatted,
    this.horaMaxEntregaStringFormatted,
    this.isEntregado,
    this.isTomado,
    this.cardType,
    this.cuotas,
    this.lastFourDigits,
    this.categoria,
    this.destino,
    this.identificador,
    this.isRecogido,
    this.origen,
    this.isHidden,
    this.user,
    this.review,
  });
}
