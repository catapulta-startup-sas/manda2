import 'package:manda2/model/categoria_model.dart';
import 'lugar_model.dart';

class User {
  String id;
  String name;
  String phoneNumber;
  String email;
  bool isAdmin;
  bool isDomi;
  bool isBloqueado;
  bool hasReviewedBuyers;
  String favoriteCreditCard;
  int numTarjetas;
  int numLugares;
  Map<String, dynamic> userTks;
  int payCount;
  int numEnvios;
  String fotoPerfilURL;
  List<Lugar> lugares;
  List<Categoria> categorias;
  int numCategorias;
  List<dynamic> dispositivos;

  User({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.hasReviewedBuyers,
    this.isAdmin,
    this.isDomi,
    this.favoriteCreditCard,
    this.numTarjetas,
    this.userTks,
    this.payCount,
    this.numEnvios,
    this.numLugares,
    this.fotoPerfilURL,
    this.lugares,
    this.numCategorias,
    this.categorias,
    this.dispositivos,
    this.isBloqueado,
  });
}
