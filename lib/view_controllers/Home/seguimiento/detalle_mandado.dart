import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/llamar.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/functions/slide_right_route.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:manda2/internet_connection.dart';
import 'package:manda2/view_controllers/Home/seguimiento/calificar.dart';
import 'package:manda2/view_controllers/Home/home.dart';
import 'package:manda2/view_controllers/Home/seguimiento/resumen_detail.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailMandado extends StatefulWidget {
  final Mandado mandado;

  DetailMandado({
    this.mandado,
  });

  @override
  _DetailMandadoState createState() => _DetailMandadoState(
        mandado: mandado,
      );
}

class _DetailMandadoState extends State<DetailMandado> {
  _DetailMandadoState({
    this.mandado,
  });

  final Mandado mandado;
  bool successContainerIsHidden = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

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
            "Mandado",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            if (mandado.isCalificado) {
              _alertCalificado();
            } else if (mandado.isEntregado) {
              _alertEntregado();
            } else if (mandado.isTomado) {
              _alertTomado();
            } else {
              _alertSolicitado();
            }
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.more_horiz,
              color: kGreenManda2Color,
            ),
          ),
        ),
      ),
      body: CatapultaScrollView(
        child: Stack(
          children: <Widget>[
            Container(height: MediaQuery.of(context).size.height * 0.5),
            Column(
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

                M2AnimatedContainer(
                  height: successContainerIsHidden ? 0 : 50,
                  backgroundColor: kGreenManda2Color.withOpacity(0.85),
                  text: "Calificación enviada",
                ),

                /// CONTENEDOR AQUEL DE RÍOS
                mandado.domiciliario.user.fotoPerfilURL == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.fromLTRB(17, 25, 17, 0),
                        child: Container(
                          height: 114,
                          width: MediaQuery.of(context).size.width - 34,
                          decoration: BoxDecoration(
                              color: kWhiteColor, borderRadius: kRadiusAll),
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
                                            border:
                                                Border.all(color: kTransparent),
                                            borderRadius: kRadiusAll,
                                            color: Colors.lightBlue[100],
                                          ),
                                          height: 77,
                                          width: 77,
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Image(
                                              image: NetworkImage(
                                                mandado.domiciliario.user
                                                    .fotoPerfilURL,
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
                                            mandado.domiciliario.user
                                                .fotoPerfilURL,
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
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 23,
                                      child: Row(
                                        children: <Widget>[
                                          FittedBox(
                                            child: Text(
                                              '${mandado.domiciliario.user.name}',
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                fontSize: 16,
                                              )),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 17,
                                    child: Row(
                                      children: <Widget>[
                                        Image(
                                          image: AssetImage(
                                            'images/estrella.png',
                                          ),
                                          fit: BoxFit.fitHeight,
                                          color: kGreenManda2Color,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            ' ${mandado.domiciliario.califPromedio != null ? (mandado.domiciliario.califPromedio * 10).roundToDouble() / 10 : 0.0}',
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                              fontSize: 12,
                                            )),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 23,
                                      child: Row(
                                        children: <Widget>[
                                          FittedBox(
                                            child: mandado.isCalificado
                                                ? Text(
                                                    'Calificado',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            kBlackColorOpacity,
                                                      ),
                                                    ),
                                                  )
                                                : mandado.isEntregado
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          final result =
                                                              await Navigator
                                                                  .push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Calificar(
                                                                mandado:
                                                                    mandado,
                                                              ),
                                                            ),
                                                          );
                                                          if (result != null) {
                                                            setState(() {
                                                              successContainerIsHidden =
                                                                  false;
                                                              mandado.domiciliario
                                                                      .califPromedio =
                                                                  result
                                                                      as double;
                                                              mandado.isCalificado =
                                                                  true;
                                                            });
                                                            Future.delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            3))
                                                                .then((r) {
                                                              setState(() {
                                                                successContainerIsHidden =
                                                                    true;
                                                              });
                                                            });
                                                          }
                                                        },
                                                        child: Text(
                                                          'Calificar',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  kGreenManda2Color,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          llamar(
                                                            context,
                                                            mandado
                                                                .domiciliario
                                                                .user
                                                                .phoneNumber,
                                                          );
                                                        },
                                                        child: Text(
                                                          'Llamar',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  kGreenManda2Color,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _alertSolicitado() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Ver detalles"),
            isDestructiveAction: false,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ResumenDetail(
                    mandado: mandado,
                  ),
                ),
              );
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Llamar a soporte"),
            isDestructiveAction: false,
            onPressed: () {
              llamar(context, contactoSoporte);
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Eliminar"),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showAlert(
                context: context,
                title: "¿Eliminar mandado?",
                body: "No podrás recuperarlo.",
                actions: [
                  AlertAction(text: "Volver", isDefaultAction: true),
                  AlertAction(
                    text: "Eliminar",
                    isDestructiveAction: true,
                    onPressed: _deleteMandado,
                  ),
                ],
              );
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _alertTomado() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Ver detalles"),
            isDestructiveAction: false,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ResumenDetail(
                    mandado: mandado,
                  ),
                ),
              );
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Llamar al colaborador"),
            isDestructiveAction: false,
            onPressed: () {
              Navigator.pop(context);
              llamar(context, mandado.domiciliario.user.phoneNumber);
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Llamar a soporte"),
            isDestructiveAction: false,
            onPressed: () {
              Navigator.pop(context);
              llamar(context, contactoSoporte);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _alertEntregado() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Calificar colaborador"),
            isDestructiveAction: false,
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Calificar(
                    mandado: mandado,
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  successContainerIsHidden = false;
                  mandado.domiciliario.califPromedio = result as double;
                  mandado.isCalificado = true;
                });
                Future.delayed(Duration(seconds: 3)).then((r) {
                  setState(() {
                    successContainerIsHidden = true;
                  });
                });
              }
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Ver detalles"),
            isDestructiveAction: false,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ResumenDetail(
                    mandado: mandado,
                  ),
                ),
              );
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Llamar a soporte"),
            isDestructiveAction: false,
            onPressed: () {
              Navigator.pop(context);
              llamar(context, contactoSoporte);
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Eliminar"),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showAlert(
                context: context,
                title: "¿Eliminar mandado?",
                body: "No podrás recuperarlo.",
                actions: [
                  AlertAction(text: "Volver", isDefaultAction: true),
                  AlertAction(
                    text: "Eliminar",
                    isDestructiveAction: true,
                    onPressed: _deleteMandado,
                  ),
                ],
              );
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _alertCalificado() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Ver detalles"),
            isDestructiveAction: false,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ResumenDetail(
                    mandado: mandado,
                  ),
                ),
              );
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Llamar a soporte"),
            isDestructiveAction: false,
            onPressed: () {
              Navigator.pop(context);
              llamar(context, contactoSoporte);
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Eliminar"),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showAlert(
                context: context,
                title: "¿Eliminar mandado?",
                body: "No podrás recuperarlo.",
                actions: [
                  AlertAction(text: "Volver", isDefaultAction: true),
                  AlertAction(
                    text: "Eliminar",
                    isDestructiveAction: true,
                    onPressed: _deleteMandado,
                  ),
                ],
              );
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _deleteMandado() async {
    print("⏳ CANCELARÉ MANDADO");
    Firestore.instance.document("mandados/${mandado.id}").delete().then((r) {
      print("✔️ MANDADO ELIMINADO");

      /// TODO: IDENTIFICAR CATEGORÍA E INCREMENTAR SUS [numMandados]

      Map<String, dynamic> userMap = {
        /// TODO: AQUÍ [l770]
      };

      print("⏳ ACTUALIZARÉ USER");
      Firestore.instance
          .document("users/${user.id}")
          .updateData(userMap)
          .then((r) {
        print("✔️ USER ACTUALIZADO");
        setState(() {
          /// TODO: AQUÍ [l770]
        });
        pushWithPopAnimation(context, Home());
      }).catchError((e) {
        print("💩 ERROR AL ACTUALIZAR USER: $e");
        pushWithPopAnimation(context, Home());
      });
    }).catchError((e) {
      print("💩 ERROR AL ELIMINAR MANDADO: $e");
      showBasicAlert(
        context,
        "Hubo un error.",
        "No pudimos eliminar tu mandado, por favor intenta más tarde.",
      );
    });
  }

  void pushWithPopAnimation(BuildContext context, Widget widget) {
    Navigator.push(context, SlideRightRoute(page: widget));
  }

  String setupDateFormat(int millisecondsSinceEpoch) {
    return "${DateFormat.yMMMEd('es').format(DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch))}, ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch))}";
  }
}
