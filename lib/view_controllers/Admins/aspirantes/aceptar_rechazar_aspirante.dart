import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/launch_whatsapp.dart';
import 'package:manda2/functions/llamar.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/domiciliario_model.dart';
import 'package:manda2/model/user_model.dart';
import 'package:manda2/view_controllers/Admins/aspirantes/lista_aspirantes.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class VistaAspirante extends StatefulWidget {
  VistaAspirante({
    this.aspirante,
  });

  Domiciliario aspirante;

  @override
  _VistaAspiranteState createState() => _VistaAspiranteState(
        aspirante: aspirante,
      );
}

class _VistaAspiranteState extends State<VistaAspirante> {
  _VistaAspiranteState({
    this.aspirante,
  });

  Domiciliario aspirante;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "${aspirante.user.name}",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 17, color: kBlackColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: CatapultaScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Cuadro info
            Padding(
              padding: EdgeInsets.fromLTRB(17, 20, 17, 20),
              child: Container(
                height: 121,
                width: MediaQuery.of(context).size.width - 34,
                decoration:
                    BoxDecoration(borderRadius: kRadiusAll, color: kWhiteColor),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 17),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kTransparent),
                              borderRadius: kRadiusAll,
                            ),
                            child: Shimmer.fromColors(
                              baseColor: Color(0x50D1D1D1),
                              highlightColor: Color(0x01D1D1D1),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: kTransparent),
                                  borderRadius: kRadiusAll,
                                  color: Colors.lightBlue[100],
                                ),
                                height: 77,
                                width: 77,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Image(
                                    image: NetworkImage(
                                      aspirante.user.fotoPerfilURL,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            height: 77,
                            width: 77,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kTransparent),
                              borderRadius: kRadiusAll,
                              image: DecorationImage(
                                image: NetworkImage(
                                  aspirante.user.fotoPerfilURL,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 77,
                            width: 77,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ///Nombre
                        Padding(
                          padding: EdgeInsets.only(left: 17),
                          child: Container(
                            height: 25,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              "${aspirante.user.name}",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14, color: kBlackColorOpacity)),
                            ),
                          ),
                        ),

                        /// Telefono
                        Row(
                          children: <Widget>[
                            /// numero
                            Padding(
                              padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
                              child: Container(
                                height: 25,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    child: Text(
                                      "${aspirante.user.phoneNumber}",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 13,
                                              color: kBlackColor,
                                              fontWeight: FontWeight.w300)),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// icono
                            GestureDetector(
                              onTap: () {
                                llamar(context, aspirante.user.phoneNumber);
                              },
                              child: Container(
                                height: 20,
                                child: Image(
                                  image: AssetImage('images/celular.png'),
                                  color: kGreenManda2Color,
                                ),
                              ),
                            )
                          ],
                        ),

                        /// Comprador
                        Padding(
                          padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
                          child: Container(
                            height: 25,
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// Info Personal
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 17, 20),
              child: Container(
                height: 30,
                width: 195,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      'Información',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kBlackColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///Label tipo vehiculo
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
              child: Container(
                height: 25,
                width: 195,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      'Tipo de vehículo',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: kBlackColorOpacity)),
                    ),
                  ),
                ),
              ),
            ),

            /// vehiculo
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 17, 23),
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width - 34,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      "${aspirante.vehiculo}",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: kBlackColor)),
                    ),
                  ),
                ),
              ),
            ),

            /// Label email
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 17, 2),
              child: Container(
                height: 30,
                width: 195,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      'Tipo de documento',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: kBlackColorOpacity)),
                    ),
                  ),
                ),
              ),
            ),

            /// Email
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 17, 23),
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width - 34,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      "${aspirante.dniType}",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: kBlackColor)),
                    ),
                  ),
                ),
              ),
            ),

            /// Comentario cedula
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 17, 2),
              child: Container(
                height: 30,
                width: 195,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      'Número de documento',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: kBlackColorOpacity)),
                    ),
                  ),
                ),
              ),
            ),

            /// cedula
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
              child: Container(
                width: MediaQuery.of(context).size.width - 34,
                height: 25,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      "${aspirante.dniNumber}",
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: kBlackColor, fontSize: 13)),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(17, 30, 0, 20),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                        borderRadius: kRadiusAll,
                        border: Border.all(color: kRedBoton, width: 2)),
                    child: CupertinoButton(
                      onPressed: () {
                        showAlert(
                          context: context,
                          title: "¿Rechazar aspirante a domiciliario?",
                          actions: [
                            AlertAction(
                              text: "Volver",
                              isDefaultAction: true,
                            ),
                            AlertAction(
                              text: "Rechazar",
                              isDestructiveAction: true,
                              onPressed: () {
                                aspirantes.removeWhere(
                                    (asp) => asp.user.id == aspirante.user.id);
                                Navigator.pop(context, aspirantes);
                                _updateIsDomi(isAprobado: false);
                                showAlert(
                                  context: context,
                                  title: "Aspirante rechazado",
                                  body:
                                      "¿Cómo quieres notificar al aspirante que fue rechazado?",
                                  actions: [
                                    AlertAction(
                                      text: "Llamar",
                                      onPressed: () {
                                        llamar(
                                          context,
                                          aspirante.user.phoneNumber,
                                        );
                                      },
                                    ),
                                    AlertAction(
                                      text: "Escribir en WhatsApp",
                                      onPressed: () {
                                        launchWhatsApp(
                                          context,
                                          aspirante.user.phoneNumber,
                                        );
                                      },
                                    ),
                                    AlertAction(
                                      text: "Omitir",
                                      isDefaultAction: true,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                      child: FittedBox(
                        child: Text(
                          'Rechazar',
                          style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(fontSize: 15, color: kRedBoton)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 17, 20),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                        borderRadius: kRadiusAll,
                        border: Border.all(color: kGreenManda2Color, width: 2)),
                    child: CupertinoButton(
                      onPressed: () {
                        showAlert(
                          context: context,
                          title: "¿Aceptar aspirante a domiciliario?",
                          actions: [
                            AlertAction(text: "Volver"),
                            AlertAction(
                              text: "Aceptar",
                              isDefaultAction: true,
                              onPressed: () {
                                aspirantes.removeWhere(
                                    (asp) => asp.user.id == aspirante.user.id);
                                Navigator.pop(context, aspirantes);
                                _updateIsDomi(isAprobado: true);
                                showAlert(
                                  context: context,
                                  title: "Aspirante aceptado",
                                  body:
                                      "¿Cómo quieres notificar al aspirante que fue aceptado?",
                                  actions: [
                                    AlertAction(
                                      text: "Llamar",
                                      onPressed: () {
                                        llamar(
                                          context,
                                          aspirante.user.phoneNumber,
                                        );
                                      },
                                    ),
                                    AlertAction(
                                      text: "Escribir en WhatsApp",
                                      onPressed: () {
                                        launchWhatsApp(
                                          context,
                                          aspirante.user.phoneNumber,
                                        );
                                      },
                                    ),
                                    AlertAction(
                                      text: "Omitir",
                                      isDefaultAction: true,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                      child: FittedBox(
                        child: Text(
                          'Aceptar',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: kGreenManda2Color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _updateIsDomi({@required bool isAprobado}) async {
    Map<String, dynamic> userMap = {
      "roles.isDomi": isAprobado ? true : false,
      "roles.estadoRegistroDomi": isAprobado ? 1 : 2,
    };
    print("⏳ ACTUALIZARÉ USER");
    Firestore.instance
        .document("users/${aspirante.user.id}")
        .updateData(userMap)
        .then((r) {
      print("✔️ USER ACTUALIZADO");
    }).catchError((e) {
      print("💩 ERROR AL ACTUALIZAR USER: $e");
    });
  }
}
