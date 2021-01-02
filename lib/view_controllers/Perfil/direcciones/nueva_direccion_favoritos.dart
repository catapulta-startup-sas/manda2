import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_text_field.dart';
import 'package:manda2/components/m2_text_field_iniciar_sesion.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/view_controllers/Perfil/direcciones/direcciones.dart';

class NuevaDireccionFavoritos extends StatefulWidget {
  bool desdeSolicitud;

  NuevaDireccionFavoritos({
    this.desdeSolicitud,
  });

  @override
  _NuevaDireccionFavoritosState createState() => _NuevaDireccionFavoritosState(
        isRecogida: desdeSolicitud,
      );
}

class _NuevaDireccionFavoritosState extends State<NuevaDireccionFavoritos> {
  _NuevaDireccionFavoritosState({
    this.isRecogida,
  });

  bool isRecogida;

  String ciudad;
  String calle;
  String barrio;
  String edificio;
  String apto;
  String notas;
  String contactoName;
  String contactoPhoneNumber;
  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;

  bool isLoadingBtn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kBlackColor,
        border: Border(
          bottom: BorderSide(
            color: kTransparent,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        backgroundColor: kLightGreyColor,
        middle: FittedBox(
          child: Text(
            "Agregar dirección",
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
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Contacto.Name
              Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 0, 8),
                child: Text(
                  'Contacto',
                  style: GoogleFonts.poppins(textStyle: kLabelPedido),
                ),
              ),
              M2TextFieldIniciarSesion(
                initialValue: contactoName ?? "",
                height: 55,
                textCapitalization: TextCapitalization.words,
                placeholder: '${user.name}',
                onChanged: (text) {
                  setState(() {
                    contactoName = text;
                  });
                  if (calle != null &&
                      calle != "" &&
                      ciudad != null &&
                      ciudad != "" &&
                      contactoName != "" &&
                      contactoName != null &&
                      contactoPhoneNumber != "" &&
                      contactoPhoneNumber == null) {
                    buttonBackgroundColor = kGreenManda2Color;
                    buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                  } else {
                    buttonBackgroundColor = kBlackColorOpacity;
                    buttonShadowColor = kTransparent;
                  }
                },
              ),

              /// Contacto.PhoneNumber
              Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 0, 8),
                child: Text(
                  'Celular de contacto',
                  style: GoogleFonts.poppins(textStyle: kLabelPedido),
                ),
              ),
              M2TextFieldIniciarSesion(
                initialValue: contactoPhoneNumber ?? "",
                height: 55,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                placeholder: '${user.phoneNumber}',
                onChanged: (text) {
                  setState(() {
                    contactoPhoneNumber = text;
                  });
                  if (calle != null &&
                      calle != "" &&
                      ciudad != null &&
                      ciudad != "" &&
                      contactoName != "" &&
                      contactoName != null &&
                      contactoPhoneNumber != "" &&
                      contactoPhoneNumber == null) {
                    buttonBackgroundColor = kGreenManda2Color;
                    buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                  } else {
                    buttonBackgroundColor = kBlackColorOpacity;
                    buttonShadowColor = kTransparent;
                  }
                },
              ),

              /// Ciudad
              Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 0, 8),
                child: Text(
                  'Ciudad',
                  style: GoogleFonts.poppins(textStyle: kLabelPedido),
                ),
              ),
              M2TextFieldIniciarSesion(
                initialValue: ciudad ?? "",
                height: 55,
                textCapitalization: TextCapitalization.words,
                placeholder: 'Medellín',
                onChanged: (text) {
                  setState(() {
                    ciudad = text;
                  });
                  if (calle != null &&
                      calle != "" &&
                      ciudad != null &&
                      ciudad != "") {
                    buttonBackgroundColor = kGreenManda2Color;
                    buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                  } else {
                    buttonBackgroundColor = kBlackColorOpacity;
                    buttonShadowColor = kTransparent;
                  }
                },
              ),

              /// Direccion
              Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 0, 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Dirección',
                      style: GoogleFonts.poppins(textStyle: kLabelPedido),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              M2TextFieldIniciarSesion(
                initialValue: calle ?? "",
                height: 55,
                textCapitalization: TextCapitalization.words,
                placeholder: 'Calle 10 #38-26',
                onChanged: (text) {
                  setState(() {
                    calle = text;
                  });
                  if (calle != null &&
                      calle != "" &&
                      ciudad != null &&
                      ciudad != "") {
                    buttonBackgroundColor = kGreenManda2Color;
                    buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                  } else {
                    buttonBackgroundColor = kBlackColorOpacity;
                    buttonShadowColor = kTransparent;
                  }
                },
              ),

              /// Barrio
              Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 0, 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Barrio ',
                      style: GoogleFonts.poppins(textStyle: kLabelPedido),
                    ),
                    Text(
                      '(opcional)',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: kBlackColorOpacity,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              M2TextFieldIniciarSesion(
                initialValue: barrio ?? "",
                height: 55,
                textCapitalization: TextCapitalization.words,
                placeholder: 'Provenza',
                onChanged: (text) {
                  barrio = text;
                },
              ),

              /// Edificio
              Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 0, 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Edificio ',
                      style: GoogleFonts.poppins(textStyle: kLabelPedido),
                    ),
                    Text(
                      '(opcional)',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: kBlackColorOpacity,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              M2TextFieldIniciarSesion(
                initialValue: edificio ?? "",
                height: 55,
                textCapitalization: TextCapitalization.words,
                placeholder: 'El Sol',
                onChanged: (text) {
                  edificio = text;
                },
              ),

              /// Interior
              Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 0, 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Interior ',
                      style: GoogleFonts.poppins(textStyle: kLabelPedido),
                    ),
                    Text(
                      '(opcional)',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: kBlackColorOpacity,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              M2TextFieldIniciarSesion(
                initialValue: apto ?? "",
                height: 55,
                textCapitalization: TextCapitalization.words,
                placeholder: 'Apto. 202',
                onChanged: (text) {
                  apto = text;
                },
              ),

              /// NOTAS
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 13, top: 35),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Instrucciones adicionales ',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: kBlackColor,
                        ),
                      ),
                    ),
                    Container(
                      child: FittedBox(
                        child: Text(
                          '(opcional)',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: kBlackColorOpacity,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              M2TextField(
                textCapitalization: TextCapitalization.sentences,
                placeholder: 'Notas al colaborador',
                title: '',
                height: 98,
                width: MediaQuery.of(context).size.width - 34,
                onChanged: (text) {
                  notas = text;
                },
              ),

              /// Esto arregla el problema
              Expanded(child: Container()),
              SizedBox(height: 28),

              /// Botón
              Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: Center(
                  child: M2Button(
                    title: 'Agregar',
                    width: MediaQuery.of(context).size.width - 34,
                    backgroundColor: buttonBackgroundColor,
                    shadowColor: buttonShadowColor,
                    isLoading: isLoadingBtn,
                    onPressed: () {
                      if (ciudad == null || ciudad == "") {
                        showBasicAlert(
                          context,
                          "Por favor, ingresa una ciudad.",
                          "",
                        );
                      } else if (ciudad == null || calle == "") {
                        showBasicAlert(
                          context,
                          "Por favor, ingresa una dirección.",
                          "",
                        );
                      } else {
                        _agregarDireccion();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _agregarDireccion() {
    setState(() {
      isLoadingBtn = true;
    });

    Map<String, dynamic> userMap = {
      "numDirecciones": user.numLugares + 1,
      "direcciones": FieldValue.arrayUnion([
        {
          "calle": calle,
          "barrio": barrio,
          "edificio": edificio,
          "ciudad": ciudad,
          "notas": notas,
          "apto": apto,
          "contacto": {
            "name": contactoName,
            "phoneNumber": contactoPhoneNumber,
          },
        },
      ]),
    };

    print("⏳ ACTUALIZARÉ USER");
    Firestore.instance
        .document("users/${user.id}")
        .updateData(userMap)
        .then((value) {
      setState(() {
        isLoadingBtn = false;
        user.numLugares = user.numLugares + 1;
        misLugares.add(
          Lugar(
            ciudad: ciudad,
            notas: notas,
            barrio: barrio,
            direccion: calle,
            edificio: edificio,
            apto: apto,
            contactoName: contactoName,
            contactoPhoneNumber: contactoPhoneNumber,
          ),
        );
        user.lugares = misLugares;
      });
      Navigator.pop(context, misLugares);
      print("✔️ USER ACTUALIZADO");
    }).catchError((e) {
      setState(() {
        isLoadingBtn = false;
      });
      print("💩 ERROR AL ACTUALIZAR USER: $e");
    });
  }
}
