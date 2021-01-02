import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/components/m2_text_field_iniciar_sesion.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/first_word_from_paragraph.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/internet_connection.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:provider/provider.dart';

class Calificar extends StatefulWidget {
  Calificar({this.mandado});
  Mandado mandado;

  @override
  _CalificarState createState() => _CalificarState(mandado: mandado);
}

class _CalificarState extends State<Calificar> {
  _CalificarState({this.mandado});
  Mandado mandado;

  int estrellas = -1;
  Color colorEstrella = kBlackColorOpacity.withOpacity(0.5);
  Color colorEstrella2 = kBlackColorOpacity.withOpacity(0.5);
  Color colorEstrella3 = kBlackColorOpacity.withOpacity(0.5);
  Color colorEstrella4 = kBlackColorOpacity.withOpacity(0.5);
  Color colorEstrella5 = kBlackColorOpacity.withOpacity(0.5);

  bool isLoadingBtn = false;
  String resena;

  @override
  Widget build(BuildContext context) {
    bool hasConnection = Provider.of<InternetStatus>(context).connected;
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kBlackColor,
        backgroundColor: kLightGreyColor,
        border: Border(
          bottom: BorderSide(
            color: kTransparent,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: FittedBox(
          child: Text(
            "Calificar",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: CatapultaScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          hasConnection
              ? M2AnimatedContainer(
                  height: 0,
                  width: MediaQuery.of(context).size.width,
                )
              : M2AnimatedContainer(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                ),
          Padding(
            padding: EdgeInsets.fromLTRB(17, 36, 17, 0),
            child: Text(
              'Calificar a ${firstWordFromParagraph(mandado.domiciliario.user.name)}.',
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15)),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
            child: Text(
              'Por favor, califica al colaborador que realizó el mandado.',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 13, color: kBlackColor.withOpacity(0.5))),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Center(
            child: Text(
              '${mandado.domiciliario.user.name}',
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      HapticFeedback.selectionClick();
                      estrellas = 1;
                      colorEstrella = kGreenManda2Color;
                      colorEstrella2 = kBlackColorOpacity.withOpacity(0.5);
                      colorEstrella3 = kBlackColorOpacity.withOpacity(0.5);
                      colorEstrella4 = kBlackColorOpacity.withOpacity(0.5);
                      colorEstrella5 = kBlackColorOpacity.withOpacity(0.5);
                    });
                  },
                  child: Image(
                    image: AssetImage('images/estrella.png'),
                    color: colorEstrella,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      HapticFeedback.selectionClick();
                      estrellas = 2;
                      colorEstrella = kGreenManda2Color;
                      colorEstrella2 = kGreenManda2Color;
                      colorEstrella3 = kBlackColorOpacity.withOpacity(0.5);
                      colorEstrella4 = kBlackColorOpacity.withOpacity(0.5);
                      colorEstrella5 = kBlackColorOpacity.withOpacity(0.5);
                    });
                  },
                  child: Image(
                    image: AssetImage('images/estrella.png'),
                    color: colorEstrella2,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      HapticFeedback.selectionClick();
                      estrellas = 3;
                      colorEstrella = kGreenManda2Color;
                      colorEstrella2 = kGreenManda2Color;
                      colorEstrella3 = kGreenManda2Color;
                      colorEstrella4 = kBlackColorOpacity.withOpacity(0.5);
                      colorEstrella5 = kBlackColorOpacity.withOpacity(0.5);
                    });
                  },
                  child: Image(
                    image: AssetImage('images/estrella.png'),
                    color: colorEstrella3,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      HapticFeedback.selectionClick();
                      estrellas = 4;
                      colorEstrella = kGreenManda2Color;
                      colorEstrella2 = kGreenManda2Color;
                      colorEstrella3 = kGreenManda2Color;
                      colorEstrella4 = kGreenManda2Color;
                      colorEstrella5 = kBlackColorOpacity.withOpacity(0.5);
                    });
                  },
                  child: Image(
                    image: AssetImage('images/estrella.png'),
                    color: colorEstrella4,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      estrellas = 5;
                      colorEstrella = kGreenManda2Color;
                      colorEstrella2 = kGreenManda2Color;
                      colorEstrella3 = kGreenManda2Color;
                      colorEstrella4 = kGreenManda2Color;
                      colorEstrella5 = kGreenManda2Color;
                    });
                  },
                  child: Image(
                    image: AssetImage('images/estrella.png'),
                    color: colorEstrella5,
                  ),
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
          ),
          SizedBox(
            height: 48,
          ),
          Padding(
            padding: EdgeInsets.all(17),
            child: Row(
              children: <Widget>[
                Text(
                  'Escribir reseña ',
                  style:
                      GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15)),
                ),
                Text(
                  '(Opcional)',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 15, color: kBlackColor.withOpacity(0.4))),
                ),
              ],
            ),
          ),
          M2TextFieldIniciarSesion(
            textCapitalization: TextCapitalization.sentences,
            onChanged: (text) {
              setState(() {
                resena = text;
              });
            },
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(17, 0, 17, 48),
            child: M2Button(
              title: 'Enviar calificación',
              isLoading: isLoadingBtn,
              backgroundColor: estrellas < 0 && hasConnection
                  ? kBlackColorOpacity
                  : kGreenManda2Color,
              shadowColor: estrellas < 0 && hasConnection
                  ? kTransparent
                  : kGreenManda2Color.withOpacity(0.4),
              width: MediaQuery.of(context).size.width - 34,
              onPressed: () {
                if (estrellas > 0) {
                  calificarDomiciliario();
                } else {
                  showBasicAlert(
                    context,
                    "Por favor, toca una estrella para continuar.",
                    "",
                  );
                }
              },
            ),
          )
        ],
      )),
    );
  }

  void calificarDomiciliario() {
    HapticFeedback.lightImpact();

    setState(() {
      isLoadingBtn = true;
    });

    Firestore.instance
        .document("domiciliarios/${mandado.domiciliario.user.id}")
        .get()
        .then((domiDoc) {
      print("DOMI OBTENIDO");

      int oldNumCalificaciones = domiDoc.data["calificaciones"]["cantidad"];
      int newNumCalificaciones = oldNumCalificaciones + 1;
      double oldCalifPromedio =
          domiDoc.data["calificaciones"]["promedio"].toDouble();

      double newCalifPromedio =
          (oldCalifPromedio * oldNumCalificaciones + estrellas) /
              newNumCalificaciones;

      Map<String, dynamic> mandadoMap = {
        "estados.isCalificado": true,
        "domiciliario.numCalificaciones": newNumCalificaciones,
        "domiciliario.califPromedio": newCalifPromedio,
        "resena": {
          "calificacion": estrellas,
          "resena": resena,
          "created": DateTime.now().millisecondsSinceEpoch,
        }
      };

      print("ACTUALIZARÉ MANDADO");

      Firestore.instance
          .document("mandadosDesarrollo/${mandado.id}")
          .updateData(mandadoMap)
          .then((r) {
        print("MANDADO ACTUALIZADO");

        Map<String, dynamic> domiMap = {
          "calificaciones": {
            "cantidad": newNumCalificaciones,
            "promedio": newCalifPromedio,
          },
          "resenas": FieldValue.arrayUnion([
            {
              "calificacion": estrellas,
              "resena": resena,
              "created": DateTime.now().millisecondsSinceEpoch,
              "name": user.name,
            }
          ])
        };

        print("ACTUALIZARÉ DOMI");
        Firestore.instance
            .document("domiciliarios/${mandado.domiciliario.user.id}")
            .updateData(domiMap)
            .then((value) {
          print("DOMI ACTUALIZADO");
          Navigator.pop(context, newCalifPromedio);
          setState(() {
            isLoadingBtn = false;
          });
        }).catchError((e) {
          print("ERROR AL ACTUALIZAR DOMI: $e");
          Navigator.pop(context, newCalifPromedio);
          setState(() {
            isLoadingBtn = false;
          });
        });
      }).catchError((e) {
        print("ERROR AL ACTUALIZAR MANDADO: $e");
        setState(() {
          isLoadingBtn = false;
        });
        showBasicAlert(
          context,
          "Hubo un error.",
          "Por favor, intenta más tarde.",
        );
      });
    }).catchError((e) {
      print("ERROR AL OBTENER DOMI: $e");
      setState(() {
        isLoadingBtn = false;
      });
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor, intenta más tarde.",
      );
    });
  }
}
