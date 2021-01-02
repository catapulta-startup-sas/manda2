import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/llamar.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/reporte_model.dart';
import 'package:shimmer/shimmer.dart';

class VistaPerfil extends StatefulWidget {
  VistaPerfil({this.reporte});

  Reporte reporte;

  @override
  _VistaPerfilState createState() => _VistaPerfilState(
        reporte: reporte,
      );
}

class _VistaPerfilState extends State<VistaPerfil> {
  _VistaPerfilState({this.reporte});

  Reporte reporte;

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
          "${reporte.reportante.name}",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 17, color: kBlackColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: CatapultaScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Comentario label
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: Container(
                  height: 30,
                  width: 195,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      child: Text(
                        'Comentario',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: kBlackColor)),
                      ),
                    ),
                  ),
                ),
              ),

              /// Comentario
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 34),
                child: Text(
                  reporte.comentario,
                  style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(color: kBlackColorOpacity, fontSize: 13)),
                ),
              ),

              ///Contactar
              GestureDetector(
                onTap: () {
                  llamar(context, reporte.reportante.phoneNumber);
                },
                child: Text(
                  'Llamar usuario',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: kGreenManda2Color,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ///Marcar solucionado
              GestureDetector(
                child: Text(
                  'Eliminar reporte',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: kRedActive,
                    ),
                  ),
                ),
                onTap: () {
                  showAlert(
                    context: context,
                    title: "Eliminar reporte",
                    body: "¿Quieres eliminar este reporte?",
                    actions: [
                      AlertAction(
                        text: "Volver",
                        isDefaultAction: true,
                      ),
                      AlertAction(
                        text: "Eliminar",
                        isDestructiveAction: true,
                        onPressed: () {
                          Firestore.instance
                              .document("reportes/${reporte.id}")
                              .delete()
                              .then((value) {
                            Navigator.pop(context);
                          }).catchError((e) {
                            print("ERROR AL ELIMINAR REPORTE: $e");
                            showBasicAlert(
                              context,
                              "Hubo un error.",
                              "Por favor, intenta más tarde.",
                            );
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
