import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_editar.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/m2_alert.dart';

class NuevoPaquete extends StatefulWidget {
  @override
  _NuevoPaqueteState createState() => _NuevoPaqueteState();
}

class _NuevoPaqueteState extends State<NuevoPaquete> {
  String cantidadStringLocal;
  String precioStringLocal;
  Color btnBackgroundColor = kBlackColorOpacity;
  Color btnShadowColor = kTransparent;
  bool isLoadingBtn = false;

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
          "Crear paquete",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 17,
              color: kBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
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
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              M2Editar(
                titulo: 'Cantidad de envíos',
                text: 'xN',
                imageRoute: 'images/id.png',
                keyboardType: TextInputType.number,
                iconColor: kBlackColor,
                colorLabel: kBlackColor,
                onChanged: (text) {
                  cantidadStringLocal = text;
                  if (cantidadStringLocal != "" &&
                      cantidadStringLocal != null &&
                      precioStringLocal != null &&
                      precioStringLocal != "") {
                    setState(() {
                      btnBackgroundColor = kGreenManda2Color;
                      btnShadowColor = kGreenManda2Color.withOpacity(0.4);
                    });
                  } else {
                    setState(() {
                      btnBackgroundColor = kBlackColorOpacity;
                      btnShadowColor = kTransparent;
                    });
                  }
                },
              ),
              M2Editar(
                titulo: 'Precio total',
                text: '\$X COP',
                imageRoute: 'images/precio.png',
                keyboardType: TextInputType.number,
                iconColor: kBlackColor,
                colorLabel: kBlackColor,
                onChanged: (text) {
                  precioStringLocal = text;
                  if (cantidadStringLocal != "" &&
                      cantidadStringLocal != null &&
                      precioStringLocal != null &&
                      precioStringLocal != "") {
                    setState(() {
                      btnBackgroundColor = kGreenManda2Color;
                      btnShadowColor = kGreenManda2Color.withOpacity(0.4);
                    });
                  } else {
                    setState(() {
                      btnBackgroundColor = kBlackColorOpacity;
                      btnShadowColor = kTransparent;
                    });
                  }
                },
              ),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(17, 30, 20, 17),
                child: M2Button(
                  width: MediaQuery.of(context).size.width - 34,
                  isLoading: isLoadingBtn,
                  title: 'Crear',
                  backgroundColor: btnBackgroundColor,
                  shadowColor: btnShadowColor,
                  onPressed: _createPaquete,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _createPaquete() {
    setState(() {
      isLoadingBtn = true;
    });
    Map<String, dynamic> paqueteMap = {
      "cantidad": int.parse(cantidadStringLocal),
      "precio": int.parse(precioStringLocal),
    };
    print("CREARÉ PAQUETE");
    Firestore.instance.collection("paquetes").add(paqueteMap).then((value) {
      print("PAQUETE CREADO");
      Navigator.pop(context);
      setState(() {
        isLoadingBtn = false;
      });
    }).catchError((e) {
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor, intenta más tarde.",
      );
      setState(() {
        isLoadingBtn = false;
      });
      print("ERROR AL CREAR PAQUETE: $e");
    });
  }
}
