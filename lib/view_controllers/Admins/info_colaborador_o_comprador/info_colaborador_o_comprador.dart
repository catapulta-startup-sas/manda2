import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:manda2/functions/formato_fecha.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/calificacion_model.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/model/domiciliario_model.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:manda2/model/user_model.dart';
import 'package:manda2/view_controllers/Admins/info_colaborador_o_comprador/info_personal.dart';
import 'package:manda2/view_controllers/Admins/info_colaborador_o_comprador/mandados.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_container_configuracion.dart';
import 'package:manda2/constants.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class InfoColaboradorOComprador extends StatefulWidget {
  InfoColaboradorOComprador({this.user});
  User user;
  @override
  _InfoColaboradorOCompradorState createState() =>
      _InfoColaboradorOCompradorState(user: user);
}

class _InfoColaboradorOCompradorState extends State<InfoColaboradorOComprador> {
  _InfoColaboradorOCompradorState({this.user});

  User user;
  double calificacion;

  bool isLoading = false;

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();

    if (user.isDomi) {
      _getMandadosColaborador();
    } else {
      _getMandadosComprador();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: kLightGreyColor,
        actionsForegroundColor: kBlackColor,
        border: Border(
          bottom: BorderSide(
            color: kTransparent,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: Text(
          "${user.name}",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 17,
              color: kBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: kLightGreyColor,
          child: CatapultaScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Container(
                    color: kLightGreyColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /// Experiencia de cliente
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 10,
                                height: 50,
                                color: kLightGreyColor,
                              ),
                              Container(
                                width: 10,
                                height: 50,
                                color: kLightGreyColor,
                              ),
                              Container(
                                height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      user.isDomi
                                          ? "Calificación promedio"
                                          : 'Experiencia de cliente',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 13,
                                          color: kBlackColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: kLightGreyColor,
                                ),
                              ),
                              calificacion == null
                                  ? SizedBox.shrink()
                                  : Image(
                                      image: AssetImage('images/estrella.png'),
                                      height: 12,
                                      color: kGreenManda2Color,
                                    ),
                              const SizedBox(width: 5),
                              calificacion == null
                                  ? Text(
                                      user.isDomi
                                          ? "Sin calificaciones"
                                          : 'No ha calificado',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          color: kBlackColorOpacity,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      '$calificacion',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          color: kBlackColor,
                                        ),
                                      ),
                                    ),
                              Container(
                                width: 10,
                                height: 50,
                                color: kLightGreyColor,
                              ),
                            ],
                          ),
                        ),

                        ///Información personal
                        ContainerConfiguracion(
                          text: 'Información personal',
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => InfoPersonal(user: user),
                              ),
                            );
                          },
                        ),

                        ///Mandados
                        ContainerConfiguracion(
                          text:
                              'Mandados ${user.isDomi ? "tomados" : "solicitados"}',
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Mandados(
                                  mandados: mandados,
                                  isDomi: user.isDomi,
                                ),
                              ),
                            );
                          },
                        ),

                        /// Inhabilitar usuario
                        ContainerConfiguracion(
                          flecha: false,
                          isLoading: isLoading,
                          text: user.isBloqueado
                              ? "Habilitar usuario"
                              : 'Inhabilitar usuario',
                          color:
                              user.isBloqueado ? kGreenManda2Color : kRedActive,
                          onTap: () {
                            showAlert(
                              context: context,
                              title:
                                  "${user.isBloqueado ? "Habilitar usuario" : "Inhabilitar usuario"}",
                              body:
                                  "${user.isBloqueado ? "${user.name} podrá acceder de nuevo a todas las funcionalidades de Manda2 y Manda2 Colaboradores." : "${user.name} ya no podrá acceder a Manda2 ni Manda2 Colaboradores. Podrás habilitarlo de nuevo en otro momento."}",
                              actions: [
                                AlertAction(
                                  text: "Volver",
                                ),
                                AlertAction(
                                    text: user.isBloqueado
                                        ? "Habilitar"
                                        : "Inhabilitar",
                                    isDestructiveAction: !user.isBloqueado,
                                    isDefaultAction: user.isBloqueado,
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      Map<String, dynamic> userMap = {
                                        "roles.isBloqueado": !user.isBloqueado,
                                      };
                                      Firestore.instance
                                          .document("users/${user.id}")
                                          .updateData(userMap)
                                          .then((value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        setState(() {
                                          user.isBloqueado = !user.isBloqueado;
                                        });
                                      }).catchError((e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        print("ERROR AL HABILITAR USUARIO: $e");
                                        showBasicAlert(
                                            context,
                                            "Hubo un error.",
                                            "Por favor, intenta más tarde.");
                                      });
                                    }),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Mandado> mandados = List();

  void _getMandadosComprador() async {
    print("OBTENDRÉ MANDADOS");
    Firestore.instance
        .collection("mandadosDesarrollo")
        .where("clienteId", isEqualTo: user.id)
        .orderBy("created", descending: true)
        .snapshots()
        .listen((querySnapshot) {
      print("OBTUVE MANDADOS");
      if (querySnapshot.documents.isEmpty) {
      } else {
        querySnapshot.documents.forEach((mandadoDoc) {
          print("OBTENDRÉ DOMI USER");
          Firestore.instance
              .document("users/${mandadoDoc.data["domiciliarioId"]}")
              .get()
              .then((userDoc) {
            print("OBTUVE DOMI USER");
            User domiUser = User(
              id: userDoc.documentID,
              name: userDoc.data["name"],
              fotoPerfilURL: userDoc.data["fotoPerfilURL"],
              phoneNumber: userDoc.data["phoneNumber"],
            );
            print("OBTENDRÉ DOMI DOMI");
            Firestore.instance
                .document("domiciliarios/${mandadoDoc.data["domiciliarioId"]}")
                .get()
                .then((domiDoc) {
              print("OBTUVE DOMI DOMI");

              Domiciliario domi = Domiciliario(
                user: domiUser,
                califPromedio: (domiDoc.data["calificaciones"]["promedio"] ?? 0)
                    .toDouble(),
                cantidadCalificaciones:
                    (domiDoc.data["calificaciones"]["cantidad"] ?? 0),
              );

              mandados.add(Mandado(
                id: mandadoDoc.documentID,
                identificador: mandadoDoc.data["identificador"],
                categoria: Categoria(
                  emoji: mandadoDoc.data["categoria"]["emoji"],
                  title: mandadoDoc.data["categoria"]["title"],
                ),
                domiciliario: domi,
                isTomado: mandadoDoc.data["estados"]["isTomado"] ?? false,
                isRecogido: mandadoDoc.data["estados"]["isRecogido"] ?? false,
                isEntregado: mandadoDoc.data["estados"]["isEntregado"] ?? false,
                isCalificado:
                    mandadoDoc.data["estados"]["isCalificado"] ?? false,
                isHidden: mandadoDoc.data["estados"]["isHidden"] ?? false,
                origen: Lugar(
                  apto: mandadoDoc.data["puntoA"]["apto"],
                  barrio: mandadoDoc.data["puntoA"]["barrio"],
                  direccion: mandadoDoc.data["puntoA"]["calle"],
                  ciudad: mandadoDoc.data["puntoA"]["ciudad"],
                  contactoName: mandadoDoc.data["puntoA"]["contacto"],
                  edificio: mandadoDoc.data["puntoA"]["edificio"],
                  notas: mandadoDoc.data["puntoA"]["notas"],
                  contactoPhoneNumber: mandadoDoc.data["puntoA"]["phoneNumber"],
                ),
                destino: Lugar(
                  apto: mandadoDoc.data["puntoB"]["apto"],
                  barrio: mandadoDoc.data["puntoB"]["barrio"],
                  direccion: mandadoDoc.data["puntoB"]["calle"],
                  ciudad: mandadoDoc.data["puntoB"]["ciudad"],
                  contactoName: mandadoDoc.data["puntoB"]["contacto"],
                  edificio: mandadoDoc.data["puntoB"]["edificio"],
                  notas: mandadoDoc.data["puntoB"]["notas"],
                  contactoPhoneNumber: mandadoDoc.data["puntoB"]["phoneNumber"],
                ),
                review: mandadoDoc.data["resena"] == null
                    ? Review(
                        id: mandadoDoc.documentID,
                        message: "NA",
                        calification: -1.0,
                      )
                    : Review(
                        id: mandadoDoc.documentID,
                        message: mandadoDoc.data["resena"]["resena"],
                        calification: mandadoDoc.data["resena"]["calificacion"]
                            .toDouble(),
                        ago: dateFormattedFromDateTime(
                          DateTime.fromMillisecondsSinceEpoch(
                            mandadoDoc.data["resena"]["created"],
                          ),
                        ),
                      ),
                descripcion: mandadoDoc.data["descripcion"],
                tipoPago: mandadoDoc.data["pago"]["tipoPago"],
                total: mandadoDoc.data["pago"]["total"],
                cuotas: mandadoDoc.data["pago"]["cuotas"],
                cardType: mandadoDoc.data["pago"]["cardType"],
                lastFourDigits: mandadoDoc.data["pago"]["lastFourDigits"],
                fechaMaxEntregaStringFormatted: DateFormat('EEE d').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        mandadoDoc.data["vencimiento"])),
                horaMaxEntregaStringFormatted: DateFormat('hh:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        mandadoDoc.data["vencimiento"])),
                tomadoDateTimeMSE: mandadoDoc.data["estados"]["dates"]
                    ["tomado"],
                recogidoDateTimeMSE: mandadoDoc.data["estados"]["dates"]
                    ["recogido"],
                entregadoDateTimeMSE: mandadoDoc.data["estados"]["dates"]
                    ["entregado"],
                createdDateTimeMSE: mandadoDoc.data["created"],
                fechaMaxEntrega: DateTime.fromMillisecondsSinceEpoch(
                    mandadoDoc.data["vencimiento"]),
              ));
              setState(() {
                calificacion = _getUserExperience();
              });
            }).catchError((e) {
              print("ERROR AL OBTENER DOMI: $e");
            });
          }).catchError((e) {
            print("ERROR AL OBTENER USER: $e");
          });
        });
      }
    });
  }

  void _getMandadosColaborador() async {
    print("OBTENDRÉ MANDADOS");
    Firestore.instance
        .collection("mandadosDesarrollo")
        .where("domiciliarioId", isEqualTo: user.id)
        .orderBy("created", descending: true)
        .snapshots()
        .listen((querySnapshot) {
      print("OBTUVE MANDADOS");
      if (querySnapshot.documents.isEmpty) {
      } else {
        querySnapshot.documents.forEach((mandadoDoc) {
          print("OBTENDRÉ CLIENTE USER");
          Firestore.instance
              .document("users/${mandadoDoc.data["clienteId"]}")
              .get()
              .then((userDoc) {
            print("OBTUVE DOMI USER");
            User clienteUser = User(
              id: userDoc.documentID,
              name: userDoc.data["name"],
              fotoPerfilURL: userDoc.data["fotoPerfilURL"],
              phoneNumber: userDoc.data["phoneNumber"],
            );
            print("OBTENDRÉ DOMI DOMI");
            Firestore.instance
                .document("domiciliarios/${user.id}")
                .get()
                .then((domiDoc) {
              print("OBTUVE DOMI DOMI");

              Domiciliario domi = Domiciliario(
                user: User(
                  id: user.id,
                  name: user.name,
                  fotoPerfilURL: user.fotoPerfilURL,
                  phoneNumber: user.phoneNumber,
                ),
                califPromedio: (domiDoc.data["calificaciones"]["promedio"] ?? 0)
                    .toDouble(),
                cantidadCalificaciones:
                    (domiDoc.data["calificaciones"]["cantidad"] ?? 0),
              );

              mandados.add(Mandado(
                id: mandadoDoc.documentID,
                identificador: mandadoDoc.data["identificador"],
                categoria: Categoria(
                  emoji: mandadoDoc.data["categoria"]["emoji"],
                  title: mandadoDoc.data["categoria"]["title"],
                ),
                domiciliario: domi,
                isTomado: mandadoDoc.data["estados"]["isTomado"] ?? false,
                isRecogido: mandadoDoc.data["estados"]["isRecogido"] ?? false,
                isEntregado: mandadoDoc.data["estados"]["isEntregado"] ?? false,
                isCalificado:
                    mandadoDoc.data["estados"]["isCalificado"] ?? false,
                isHidden: mandadoDoc.data["estados"]["isHidden"] ?? false,
                origen: Lugar(
                  apto: mandadoDoc.data["puntoA"]["apto"],
                  barrio: mandadoDoc.data["puntoA"]["barrio"],
                  direccion: mandadoDoc.data["puntoA"]["calle"],
                  ciudad: mandadoDoc.data["puntoA"]["ciudad"],
                  contactoName: mandadoDoc.data["puntoA"]["contacto"],
                  edificio: mandadoDoc.data["puntoA"]["edificio"],
                  notas: mandadoDoc.data["puntoA"]["notas"],
                  contactoPhoneNumber: mandadoDoc.data["puntoA"]["phoneNumber"],
                ),
                destino: Lugar(
                  apto: mandadoDoc.data["puntoB"]["apto"],
                  barrio: mandadoDoc.data["puntoB"]["barrio"],
                  direccion: mandadoDoc.data["puntoB"]["calle"],
                  ciudad: mandadoDoc.data["puntoB"]["ciudad"],
                  contactoName: mandadoDoc.data["puntoB"]["contacto"],
                  edificio: mandadoDoc.data["puntoB"]["edificio"],
                  notas: mandadoDoc.data["puntoB"]["notas"],
                  contactoPhoneNumber: mandadoDoc.data["puntoB"]["phoneNumber"],
                ),
                review: mandadoDoc.data["resena"] == null
                    ? Review(
                        id: mandadoDoc.documentID,
                        message: "NA",
                        calification: -1.0,
                      )
                    : Review(
                        id: mandadoDoc.documentID,
                        message: mandadoDoc.data["resena"]["resena"],
                        calification: mandadoDoc.data["resena"]["calificacion"]
                            .toDouble(),
                        ago: dateFormattedFromDateTime(
                          DateTime.fromMillisecondsSinceEpoch(
                            mandadoDoc.data["resena"]["created"],
                          ),
                        ),
                      ),
                descripcion: mandadoDoc.data["descripcion"],
                tipoPago: mandadoDoc.data["pago"]["tipoPago"],
                total: mandadoDoc.data["pago"]["total"],
                cuotas: mandadoDoc.data["pago"]["cuotas"],
                cardType: mandadoDoc.data["pago"]["cardType"],
                lastFourDigits: mandadoDoc.data["pago"]["lastFourDigits"],
                fechaMaxEntregaStringFormatted: DateFormat('EEE d').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        mandadoDoc.data["vencimiento"])),
                horaMaxEntregaStringFormatted: DateFormat('hh:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        mandadoDoc.data["vencimiento"])),
                tomadoDateTimeMSE: mandadoDoc.data["estados"]["dates"]
                    ["tomado"],
                recogidoDateTimeMSE: mandadoDoc.data["estados"]["dates"]
                    ["recogido"],
                entregadoDateTimeMSE: mandadoDoc.data["estados"]["dates"]
                    ["entregado"],
                createdDateTimeMSE: mandadoDoc.data["created"],
                fechaMaxEntrega: DateTime.fromMillisecondsSinceEpoch(
                    mandadoDoc.data["vencimiento"]),
              ));
              setState(() {
                calificacion = _getUserExperience();
              });
            }).catchError((e) {
              print("ERROR AL OBTENER DOMI: $e");
            });
          }).catchError((e) {
            print("ERROR AL OBTENER USER: $e");
          });
        });
      }
    });
  }

  double _getUserExperience() {
    double acumulado = 0;
    List<Mandado> mandadosCalificados = mandados
        .where((mandado) =>
            mandado.review.calification != null &&
            mandado.review.calification != -1)
        .toList();
    if (mandadosCalificados.isNotEmpty) {
      mandadosCalificados.forEach((mandado) {
        acumulado = acumulado + mandado.review.calification;
      });
      return ((acumulado * 10 / mandadosCalificados.length).round() / 10);
    } else {
      return null;
    }
  }
}
