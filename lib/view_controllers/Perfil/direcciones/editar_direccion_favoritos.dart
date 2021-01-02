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

class EditarDireccionFavoritos extends StatefulWidget {
  EditarDireccionFavoritos({
    this.posicionLista,
  });

  int posicionLista;

  @override
  _EditarDireccionFavoritosState createState() =>
      _EditarDireccionFavoritosState(
        position: posicionLista,
      );
}

class _EditarDireccionFavoritosState extends State<EditarDireccionFavoritos> {
  _EditarDireccionFavoritosState({
    this.position,
  });

  int position;
  String calle;
  String barrio;
  String edificio;
  String apto;
  String ciudad;
  String notas;
  String contactoName;
  String contactoPhoneNumber;
  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;

  bool isLoadingBtn = false;

  @override
  void initState() {
    super.initState();
    calle = misLugares[position].direccion ?? "";
    barrio = misLugares[position].barrio ?? "";
    edificio = misLugares[position].edificio ?? "";
    ciudad = misLugares[position].ciudad ?? "";
    apto = misLugares[position].apto ?? "";
    notas = misLugares[position].notas ?? "";
    contactoName = misLugares[position].contactoName ?? "";
    contactoPhoneNumber = misLugares[position].contactoPhoneNumber ?? "";
  }

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
            "Editar dirección",
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
                    handleColorChange();
                  });
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
                    handleColorChange();
                  });
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
                initialValue: misLugares[position].ciudad ?? "",
                height: 55,
                textCapitalization: TextCapitalization.words,
                placeholder: 'Medellín',
                onChanged: (text) {
                  ciudad = text;
                  handleColorChange();
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
                initialValue: misLugares[position].direccion ?? "",
                height: 55,
                textCapitalization: TextCapitalization.words,
                placeholder: 'Calle 10 #38-26',
                onChanged: (text) {
                  setState(() {
                    calle = text;
                    handleColorChange();
                  });
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
                  handleColorChange();
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
                initialValue: misLugares[position].edificio ?? "",
                height: 55,
                textCapitalization: TextCapitalization.words,
                placeholder: 'El Sol',
                onChanged: (text) {
                  edificio = text;
                  handleColorChange();
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
                initialValue: misLugares[position].apto ?? "",
                height: 55,
                textCapitalization: TextCapitalization.words,
                placeholder: 'Apto. 202',
                onChanged: (text) {
                  apto = text;
                  handleColorChange();
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
                initialValue: misLugares[position].notas ?? "",
                textCapitalization: TextCapitalization.sentences,
                placeholder: 'Notas al colaborador',
                title: '',
                height: 98,
                width: MediaQuery.of(context).size.width - 34,
                onChanged: (text) {
                  notas = text;
                  handleColorChange();
                },
              ),

              /// Esto arregla el problema
              Expanded(child: Container()),
              SizedBox(height: 28,),
              /// Botón
              Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: Center(
                  child: M2Button(
                    title: 'Guardar cambios',
                    width: MediaQuery.of(context).size.width - 34,
                    backgroundColor: buttonBackgroundColor,
                    shadowColor: buttonShadowColor,
                    isLoading: isLoadingBtn,
                    onPressed: () {
                      if (contactoName == null || contactoName == "") {
                        showBasicAlert(
                          context,
                          "Por favor, ingresa un contacto.",
                          "",
                        );
                      } else if (contactoPhoneNumber == null ||
                          contactoPhoneNumber == "") {
                        showBasicAlert(
                          context,
                          "Por favor, ingresa un número de contacto.",
                          "",
                        );
                      } else if (ciudad == null || ciudad == "") {
                        showBasicAlert(
                          context,
                          "Por favor, ingresa una ciudad.",
                          "",
                        );
                      } else if (calle == null || calle == "") {
                        showBasicAlert(
                          context,
                          "Por favor, ingresa una dirección.",
                          "",
                        );
                      } else {
                        _actualizarDireccion();
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

  void handleColorChange() {
    setState(() {
      if (calle != null &&
          calle != "" &&
          ciudad != null &&
          ciudad != "" &&
          contactoName != "" &&
          contactoName != null &&
          contactoPhoneNumber != "" &&
          contactoPhoneNumber != null &&
          (contactoPhoneNumber != misLugares[position].contactoPhoneNumber ||
              contactoName != misLugares[position].contactoName ||
              calle != misLugares[position].direccion ||
              apto != misLugares[position].apto ||
              ciudad != misLugares[position].ciudad ||
              barrio != misLugares[position].barrio ||
              edificio != misLugares[position].edificio ||
              notas != misLugares[position].notas)) {
        buttonBackgroundColor = kGreenManda2Color;
        buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
      } else {
        buttonBackgroundColor = kBlackColorOpacity;
        buttonShadowColor = kTransparent;
      }
    });
  }

  void _actualizarDireccion() {
    if (buttonBackgroundColor == kGreenManda2Color) {
      setState(() {
        isLoadingBtn = true;
      });

      List<Lugar> misDireccionesTemp = misLugares;

      misDireccionesTemp[position] = Lugar(
        ciudad: ciudad,
        notas: notas,
        barrio: barrio,
        direccion: calle,
        edificio: edificio,
        contactoName: contactoName,
        contactoPhoneNumber: contactoPhoneNumber,
        apto: apto,
      );

      List<Map<String, dynamic>> misDireccionesMapList = [];
      misDireccionesTemp.forEach((direccion) {
        misDireccionesMapList.add(
          {
            "calle": direccion.direccion,
            "barrio": direccion.barrio,
            "edificio": direccion.edificio,
            "ciudad": direccion.ciudad,
            "notas": direccion.notas,
            "apto": direccion.apto,
            "contacto": {
              "name": direccion.contactoName,
              "phoneNumber": direccion.contactoPhoneNumber,
            },
          },
        );
      });

      print(misDireccionesMapList);

      Map<String, dynamic> userMap = {
        "direcciones": misDireccionesMapList,
      };

      print("⏳ ACTUALIZARÉ USER");
      Firestore.instance
          .document("users/${user.id}")
          .updateData(userMap)
          .then((value) {
        setState(() {
          isLoadingBtn = false;
          misLugares = misDireccionesTemp;
        });
        Navigator.pop(context, misLugares);
        print("✔️ USER ACTUALIZADO");
      }).catchError((e) {
        setState(() {
          isLoadingBtn = false;
        });
        print("💩 ERROR AL ACTUALIZAR USER: $e");
      });
    } else {
      showBasicAlert(context, "No hay cambios que guardar.", "");
    }
  }
}
