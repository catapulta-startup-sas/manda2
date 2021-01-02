import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_editar.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/paquete_model.dart';
import 'package:manda2/view_controllers/Admins/Paquete/paquetes_disponibles.dart';

class EditarPaquete extends StatefulWidget {
  EditarPaquete({
    this.paquete,
    this.position,
  });

  Paquete paquete;
  int position;

  @override
  _EditarPaqueteState createState() => _EditarPaqueteState(
        paquete: paquete,
        position: position,
      );
}

class _EditarPaqueteState extends State<EditarPaquete> {
  _EditarPaqueteState({
    this.paquete,
    this.position,
  });

  String precioStringLocal;
  String cantidadStringLocal;
  bool isLoading;

  Paquete paquete;
  int position;

  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kBlackColorOpacity.withOpacity(0.5);

  @override
  void initState() {
    precioStringLocal = "${paquete.precio}";
    cantidadStringLocal = "${paquete.cantidad}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: kWhiteColor,
        actionsForegroundColor: kGreenManda2Color,
        border: Border(
          bottom: BorderSide(
            color: kBlackColor.withOpacity(0.2),
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: Text(
          "Editar",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 17, color: kBlackColor, fontWeight: FontWeight.w500),
          ),
        ),
        trailing: paquete.cantidad > 1
            ? GestureDetector(
                onTap: () {
                  showAlert(
                    context: context,
                    title: "¿Quieres eliminar este paquete?",
                    actions: [
                      AlertAction(
                        text: "Volver",
                        isDefaultAction: true,
                      ),
                      AlertAction(
                        text: "Eliminar",
                        isDestructiveAction: true,
                        onPressed: _deletePaqueteDB,
                      ),
                    ],
                  );
                },
                child: Text(
                  'Eliminar',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: kRedActive,
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              )
            : Container(
                width: 0,
              ),
      ),
      body: CatapultaScrollView(
        child: Container(
          color: kWhiteColor,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'images/crearPaq.png',
                        ),
                        fit: BoxFit.fitWidth)),
              ),
              _setupCantidad(),
              M2Editar(
                titulo: 'Precio total',
                initialValue: "$precioStringLocal",
                imageRoute: 'images/precio.png',
                keyboardType: TextInputType.number,
                iconColor: kBlackColor,
                colorLabel: kBlackColor,
                onChanged: (text) {
                  precioStringLocal = text;
                  if (paquete.cantidad == 1) {
                    if (cantidadStringLocal != null &&
                        cantidadStringLocal != "" &&
                        precioStringLocal != null &&
                        precioStringLocal != "") {
                      setState(() {
                        buttonBackgroundColor = kGreenManda2Color;
                        buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                      });
                    } else {
                      setState(() {
                        buttonBackgroundColor = kBlackColorOpacity;
                        buttonShadowColor = kBlackColorOpacity.withOpacity(0.4);
                      });
                    }
                  } else {
                    if (cantidadStringLocal != null &&
                        cantidadStringLocal != "" &&
                        precioStringLocal != null &&
                        precioStringLocal != "" &&
                        int.parse(cantidadStringLocal) != 1) {
                      setState(() {
                        buttonBackgroundColor = kGreenManda2Color;
                        buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                      });
                    } else {
                      setState(() {
                        buttonBackgroundColor = kBlackColorOpacity;
                        buttonShadowColor = kBlackColorOpacity.withOpacity(0.4);
                      });
                    }
                  }
                },
              ),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(17, 30, 20, 17),
                child: M2Button(
                  isLoading: isLoading,
                  width: MediaQuery.of(context).size.width - 34,
                  title: 'Guardar',
                  backgroundColor: buttonBackgroundColor,
                  shadowColor: buttonShadowColor,
                  onPressed: () {
                    if (buttonBackgroundColor == kGreenManda2Color) {
                      _updatePaquetesDB();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deletePaqueteDB() async {
    print("ELIMINARÉ PAQUETE");
    Firestore.instance.document("paquetes/${paquete.id}").delete().then((r) {
      Navigator.pop(context);
      print("PAQUETE ELIMINADO");
    }).catchError((e) {
      showBasicAlert(
          context, "Hubo un error.", "Por favor, intenta más tarde.");
      print("ERROR AL ELIMINAR PAQUETE: $e");
    });
  }

  void _updatePaquetesDB() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> paqueteMap = {
      "cantidad": int.parse(cantidadStringLocal),
      "precio": int.parse(precioStringLocal),
    };

    print("ACTUALIZARÉ PAQUETE");
    Firestore.instance
        .document("paquetes/${paquete.id}")
        .updateData(paqueteMap)
        .then((r) {
      print("PAQUETE ACTUALIZADO");
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      showBasicAlert(
          context, "Hubo un error.", "Por favor, intenta más tarde.");
      print("ERROR AL ACTUALIZAR PAQUETE: $e");
    });
  }

  Widget _setupCantidad() {
    if (paquete.cantidad != null) {
      if (paquete.cantidad > 1) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 44, 0, 30),
          child: M2Editar(
            titulo: 'Cantidad de envíos',
            initialValue: "${paquete.cantidad}",
            imageRoute: 'images/id.png',
            keyboardType: TextInputType.number,
            iconColor: kBlackColor,
            colorLabel: kBlackColor,
            onChanged: (text) {
              cantidadStringLocal = text;

              if (cantidadStringLocal != null &&
                  cantidadStringLocal != "" &&
                  precioStringLocal != null &&
                  precioStringLocal != "" &&
                  int.parse(cantidadStringLocal) != 1) {
                setState(() {
                  buttonBackgroundColor = kGreenManda2Color;
                  buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                });
              } else {
                setState(() {
                  buttonBackgroundColor = kBlackColorOpacity;
                  buttonShadowColor = kBlackColorOpacity.withOpacity(0.4);
                });
              }
            },
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.fromLTRB(17, 44, 17, 30),
          child: Row(
            children: <Widget>[
              Container(
                height: 25,
                width: 200,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      'Cantidad de envíos',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: kBlackColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                height: 25,
                width: 20,
                child: FittedBox(
                  child: Text(
                    'x${paquete.cantidad}',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: kBlackColorOpacity,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(17, 44, 17, 30),
        child: Row(
          children: <Widget>[
            Container(
              height: 25,
              width: 200,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                    'Cantidad de envíos',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 15, color: kBlackColor)),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            Container(
              height: 25,
              width: 20,
              child: FittedBox(
                child: Text(
                  'x${paquete.cantidad}',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: kBlackColorOpacity,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
