import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_text_field_iniciar_sesion.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/formato_fecha.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:manda2/view_controllers/Perfil/direcciones/direcciones.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Q3Formulario extends StatefulWidget {
  Q3Formulario({
    this.posicion,
    this.mandado,
  });
  int posicion;
  Mandado mandado;

  @override
  _Q3FormularioState createState() => _Q3FormularioState(
        posicion: posicion,
        mandado: mandado,
      );
}

class _Q3FormularioState extends State<Q3Formulario>
    with SingleTickerProviderStateMixin {
  _Q3FormularioState({
    this.posicion,
    this.mandado,
  });

  int posicion;
  Mandado mandado;

  AnimationController _controller;
  CurvedAnimation _animation;

  bool isIdentificadorViewClosed = true;
  bool isContactoViewClosed = true;
  bool isLugarViewClosed = true;
  bool isFechaMaxViewClosed = true;
  bool isInfoViewClosed = true;
  bool isIdentificadorCheckHidden = true;
  bool isContactoCheckHidden = true;
  bool isLugarCheckHidden = true;
  bool isFechaMaxCheckHidden = false;
  bool isInfoCheckHidden = false;

  DateTime fecha;
  DateTime fechaMin;
  DateTime fechaMax;

  String identificador = '';
  String contactoName;
  String contactoPhoneNumber;
  String ciudad;
  String direccion;
  String barrio;
  String edificio;
  String apto;
  String notas;
  String fechaMaxEntregaStringFormatted;
  String descripcion;

  bool isLoadingBtn = false;

  AlertStyle alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: true,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: kRadiusAll,
    ),
    overlayColor: Color(0x66000000),
  );

  @override
  void initState() {
    super.initState();

    if (mandado != null) {
      identificador = mandado.identificador;
      contactoName = mandado.destino.contactoName;
      ciudad = mandado.destino.ciudad;
      direccion = mandado.destino.direccion;
      barrio = mandado.destino.barrio;
      edificio = mandado.destino.edificio;
      apto = mandado.destino.apto;
      notas = mandado.destino.notas;
      fechaMaxEntregaStringFormatted = mandado.fechaMaxEntregaStringFormatted;
      descripcion = mandado.descripcion;

      if (mandado.destino.contactoPhoneNumber != user.phoneNumber) {
        contactoPhoneNumber = mandado.destino.contactoPhoneNumber;
      }

      isIdentificadorCheckHidden = false;
      isContactoCheckHidden = false;
      isLugarCheckHidden = false;
    }

    initializeDateFormatting();
    fecha = DateTime.now().add(Duration(days: 1));
    fechaMin = DateTime.now().add(Duration(minutes: 30));
    fechaMax = DateTime.now().add(Duration(days: 365));
    fechaMaxEntregaStringFormatted = dateFormattedFromDateTime(fecha);
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) ;
      });
  }

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
            "Destino ${posicion + 1}",
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text(
                "Los datos opcionales facilitan la entrega de tus mandados.",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 15,
                    color: kBlackColorOpacity,
                  ),
                ),
              ),
            ),

            /// PANEL 1
            AnimatedBuilder(
              animation: _animation,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isIdentificadorViewClosed = !isIdentificadorViewClosed;
                  });
                },
                child: Container(),
              ),
              builder: (BuildContext context, Widget child) {
                return new Transform.translate(
                  offset: Offset(0, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isIdentificadorViewClosed = !isIdentificadorViewClosed;
                        isLugarViewClosed = true;
                        isContactoViewClosed = true;
                        isFechaMaxViewClosed = true;
                        isInfoViewClosed = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: kRadiusQ2Formulario,
                        border: Border.all(color: kUnderLineColor),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      height: isIdentificadorViewClosed ? 67 : 200,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 23),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17),
                            child: Row(
                              children: <Widget>[
                                !isIdentificadorCheckHidden
                                    ? Image.asset(
                                        'images/check.png',
                                        height: 15,
                                      )
                                    : Container(),
                                !isIdentificadorCheckHidden
                                    ? SizedBox(width: 10)
                                    : Container(),
                                Text(
                                  'Identificador',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 15, color: kBlackColor)),
                                ),
                                Expanded(child: Container()),
                                Image.asset(
                                  'images/arrow${isIdentificadorViewClosed ? 'Down' : 'Up'}Botones.png',
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                          isIdentificadorViewClosed
                              ? Container()
                              : SizedBox(
                                  height: 24,
                                ),
                          isIdentificadorViewClosed
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: Text(
                                      'Úsalo para identificar más rápido tu mandado.',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: kBlackColorOpacity,
                                      )),
                                    ),
                                  ),
                                ),
                          isIdentificadorViewClosed
                              ? Container()
                              : M2TextFieldIniciarSesion(
                                  lineColor: kUnderLineColor,
                                  height: 70,
                                  placeholder: 'Ej: 123',
                                  initialValue: identificador,
                                  onChanged: (text) {
                                    setState(() {
                                      identificador = text;
                                      if (identificador != null &&
                                          identificador != '') {
                                        isIdentificadorCheckHidden = false;
                                      } else {
                                        isIdentificadorCheckHidden = true;
                                      }
                                    });
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            /// PANEL 2
            AnimatedBuilder(
              animation: _animation,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isContactoViewClosed = !isContactoViewClosed;
                  });
                },
                child: Container(),
              ),
              builder: (BuildContext context, Widget child) {
                return new Transform.translate(
                  offset: Offset(0, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isContactoViewClosed = !isContactoViewClosed;
                        isLugarViewClosed = true;
                        isIdentificadorViewClosed = true;
                        isFechaMaxViewClosed = true;
                        isInfoViewClosed = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: kRadiusQ2Formulario,
                        border: Border.all(color: kUnderLineColor),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      height: isContactoViewClosed
                          ? 67
                          : user.numLugares == 0
                              ? 270
                              : 340,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 23),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17),
                            child: Row(
                              children: <Widget>[
                                !isContactoCheckHidden
                                    ? Image.asset(
                                        'images/check.png',
                                        height: 15,
                                      )
                                    : Container(),
                                !isContactoCheckHidden
                                    ? SizedBox(width: 10)
                                    : Container(),
                                Text(
                                  'Contacto',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 15, color: kBlackColor)),
                                ),
                                Expanded(child: Container()),
                                Image.asset(
                                  'images/arrow${isContactoViewClosed ? 'Down' : 'Up'}Botones.png',
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                          isContactoViewClosed
                              ? Container()
                              : user.numLugares == 0
                                  ? SizedBox(
                                      height: 24,
                                    )
                                  : SizedBox(
                                      height: 10,
                                    ),
                          isContactoViewClosed
                              ? Container()
                              : user.numLugares == 0
                                  ? Container()
                                  : CupertinoButton(
                                      child: Container(
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: kRadiusAll,
                                          border: Border.all(
                                            color: kGreenManda2Color,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Elegir contacto guardado",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: kGreenManda2Color,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => Direcciones(
                                              vieneSetPlaces: true,
                                            ),
                                          ),
                                        );

                                        if (result != null && result is Lugar) {
                                          setState(() {
                                            contactoName = result.contactoName;
                                            contactoPhoneNumber =
                                                result.contactoPhoneNumber;
                                            ciudad = result.ciudad;
                                            direccion = result.direccion;
                                            barrio = result.barrio;
                                            edificio = result.edificio;
                                            apto = result.apto;
                                            notas = result.notas;

                                            isLugarCheckHidden = false;
                                            isLugarViewClosed = true;

                                            isContactoCheckHidden = false;
                                            isContactoViewClosed = true;
                                          });
                                        }
                                      },
                                    ),
                          isContactoViewClosed
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: Text(
                                      'Nombre completo',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: kBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          isContactoViewClosed
                              ? Container()
                              : M2TextFieldIniciarSesion(
                                  lineColor: kUnderLineColor,
                                  height: 70,
                                  textCapitalization: TextCapitalization.words,
                                  initialValue: contactoName,
                                  onChanged: (text) {
                                    setState(() {
                                      contactoName = text;
                                      if (contactoName != null &&
                                          contactoName != '') {
                                        isContactoCheckHidden = false;
                                      } else {
                                        isContactoCheckHidden = true;
                                      }
                                    });
                                  },
                                ),
                          isContactoViewClosed
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: Text(
                                      'Celular (Opcional)',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: kBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          isContactoViewClosed
                              ? Container()
                              : M2TextFieldIniciarSesion(
                                  keyboardType: TextInputType.number,
                                  lineColor: kUnderLineColor,
                                  height: 70,
                                  initialValue: contactoPhoneNumber,
                                  onChanged: (text) {
                                    setState(() {
                                      contactoPhoneNumber = text;
                                      if (contactoName != null &&
                                          contactoName != '') {
                                        isContactoCheckHidden = false;
                                      } else {
                                        isContactoCheckHidden = true;
                                      }
                                    });
                                  },
                                )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            /// PANEL 3
            AnimatedBuilder(
              animation: _animation,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isLugarViewClosed = !isLugarViewClosed;
                  });
                },
                child: Container(),
              ),
              builder: (BuildContext context, Widget child) {
                return new Transform.translate(
                  offset: Offset(0, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLugarViewClosed = !isLugarViewClosed;
                        isContactoViewClosed = true;
                        isIdentificadorViewClosed = true;
                        isFechaMaxViewClosed = true;
                        isInfoViewClosed = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: kRadiusQ2Formulario,
                        border: Border.all(color: kUnderLineColor),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      height: isLugarViewClosed
                          ? 67
                          : user.numLugares == 0
                              ? 660
                              : 720,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 23),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17),
                            child: Row(
                              children: <Widget>[
                                !isLugarCheckHidden
                                    ? Image.asset(
                                        'images/check.png',
                                        height: 15,
                                      )
                                    : Container(),
                                !isLugarCheckHidden
                                    ? SizedBox(width: 10)
                                    : Container(),
                                Text(
                                  'Lugar',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 15, color: kBlackColor)),
                                ),
                                Expanded(child: Container()),
                                Image.asset(
                                  'images/arrow${isLugarViewClosed ? 'Down' : 'Up'}Botones.png',
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                          isLugarViewClosed
                              ? Container()
                              : user.numLugares == 0
                                  ? SizedBox(
                                      height: 24,
                                    )
                                  : SizedBox(
                                      height: 10,
                                    ),
                          isLugarViewClosed
                              ? Container()
                              : user.numLugares == 0
                                  ? Container()
                                  : CupertinoButton(
                                      child: Container(
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: kRadiusAll,
                                          border: Border.all(
                                            color: kGreenManda2Color,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Elegir lugar guardado",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: kGreenManda2Color,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => Direcciones(
                                              vieneSetPlaces: true,
                                            ),
                                          ),
                                        );

                                        if (result != null && result is Lugar) {
                                          setState(() {
                                            contactoName = result.contactoName;
                                            contactoPhoneNumber =
                                                result.contactoPhoneNumber;
                                            ciudad = result.ciudad;
                                            direccion = result.direccion;
                                            barrio = result.barrio;
                                            edificio = result.edificio;
                                            apto = result.apto;
                                            notas = result.notas;

                                            isLugarCheckHidden = false;
                                            isLugarViewClosed = true;

                                            isContactoCheckHidden = false;
                                            isContactoViewClosed = true;
                                          });
                                        }
                                      },
                                    ),
                          isLugarViewClosed
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: Text(
                                      'Ciudad',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: kBlackColor,
                                      )),
                                    ),
                                  ),
                                ),
                          isLugarViewClosed
                              ? Container()
                              : M2TextFieldIniciarSesion(
                                  textCapitalization: TextCapitalization.words,
                                  lineColor: kUnderLineColor,
                                  height: 70,
                                  initialValue: ciudad,
                                  onChanged: (text) {
                                    setState(() {
                                      ciudad = text;
                                      if (ciudad != null &&
                                          ciudad != '' &&
                                          direccion != null &&
                                          direccion != '') {
                                        isLugarCheckHidden = false;
                                      } else {
                                        isLugarCheckHidden = true;
                                      }
                                    });
                                  },
                                ),
                          isLugarViewClosed
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: Text(
                                      'Dirección',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: kBlackColor,
                                      )),
                                    ),
                                  ),
                                ),
                          isLugarViewClosed
                              ? Container()
                              : M2TextFieldIniciarSesion(
                                  lineColor: kUnderLineColor,
                                  height: 70,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  initialValue: direccion,
                                  onChanged: (text) {
                                    setState(() {
                                      direccion = text;
                                      if (ciudad != null &&
                                          ciudad != '' &&
                                          direccion != null &&
                                          direccion != '') {
                                        isLugarCheckHidden = false;
                                      } else {
                                        isLugarCheckHidden = true;
                                      }
                                    });
                                  },
                                ),
                          isLugarViewClosed
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: Text(
                                      'Barrio (Opcional)',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: kBlackColor,
                                      )),
                                    ),
                                  ),
                                ),
                          isLugarViewClosed
                              ? Container()
                              : M2TextFieldIniciarSesion(
                                  textCapitalization: TextCapitalization.words,
                                  lineColor: kUnderLineColor,
                                  height: 70,
                                  onChanged: (text) {
                                    setState(() {
                                      barrio = text;
                                    });
                                  },
                                ),
                          isLugarViewClosed
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: Text(
                                      'Edificio (Opcional)',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: kBlackColor,
                                      )),
                                    ),
                                  ),
                                ),
                          isLugarViewClosed
                              ? Container()
                              : M2TextFieldIniciarSesion(
                                  textCapitalization: TextCapitalization.words,
                                  lineColor: kUnderLineColor,
                                  height: 70,
                                  onChanged: (text) {
                                    setState(() {
                                      edificio = text;
                                    });
                                  },
                                ),
                          isLugarViewClosed
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: Text(
                                      'Interior / Apto (Opcional) ',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: kBlackColor,
                                      )),
                                    ),
                                  ),
                                ),
                          isLugarViewClosed
                              ? Container()
                              : M2TextFieldIniciarSesion(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  lineColor: kUnderLineColor,
                                  height: 70,
                                  onChanged: (text) {
                                    setState(() {
                                      apto = text;
                                    });
                                  },
                                ),
                          isLugarViewClosed
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: Text(
                                      'Información adicional (Opcional)',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: kBlackColor,
                                      )),
                                    ),
                                  ),
                                ),
                          isLugarViewClosed
                              ? Container()
                              : M2TextFieldIniciarSesion(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  lineColor: kUnderLineColor,
                                  height: 70,
                                  onChanged: (text) {
                                    setState(() {
                                      notas = text;
                                    });
                                  },
                                )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            /// PANEL 4
            AnimatedBuilder(
              animation: _animation,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isFechaMaxViewClosed = !isFechaMaxViewClosed;
                  });
                },
                child: Container(),
              ),
              builder: (BuildContext context, Widget child) {
                return new Transform.translate(
                  offset: Offset(0, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFechaMaxViewClosed = !isFechaMaxViewClosed;
                        isLugarViewClosed = true;
                        isContactoViewClosed = true;
                        isIdentificadorViewClosed = true;
                        isInfoViewClosed = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: kRadiusQ2Formulario,
                        border: Border.all(color: kUnderLineColor),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      height: isFechaMaxViewClosed ? 67 : 150,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 23),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17),
                            child: Row(
                              children: <Widget>[
                                !isFechaMaxCheckHidden
                                    ? Image.asset(
                                        'images/check.png',
                                        height: 15,
                                      )
                                    : Container(),
                                !isFechaMaxCheckHidden
                                    ? SizedBox(width: 10)
                                    : Container(),
                                Text(
                                  'Fecha máxima de entrega',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      color: kBlackColor,
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                Image.asset(
                                  'images/arrow${isFechaMaxViewClosed ? 'Down' : 'Up'}Botones.png',
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                          isFechaMaxViewClosed
                              ? Container()
                              : SizedBox(height: 32),
                          isFechaMaxViewClosed
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 17),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        '$fechaMaxEntregaStringFormatted',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            color: kBlackColor,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                      GestureDetector(
                                        onTap: () {
                                          DatePicker.showDateTimePicker(
                                            context,
                                            showTitleActions: true,
                                            minTime: fechaMin,
                                            maxTime: fechaMax,
                                            onConfirm: (date) {
                                              setState(() {
                                                fecha = date;
                                                fechaMaxEntregaStringFormatted =
                                                    dateFormattedFromDateTime(
                                                        date);
                                                isFechaMaxCheckHidden = false;
                                              });
                                            },
                                            currentTime: fechaMin,
                                            locale: LocaleType.es,
                                          );
                                        },
                                        child: Text(
                                          'Cambiar',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: kGreenManda2Color,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            /// PANEL 5
            AnimatedBuilder(
              animation: _animation,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isInfoViewClosed = !isInfoViewClosed;
                  });
                },
                child: Container(),
              ),
              builder: (BuildContext context, Widget child) {
                return new Transform.translate(
                  offset: Offset(0, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isInfoViewClosed = !isInfoViewClosed;
                        isIdentificadorViewClosed = true;
                        isLugarViewClosed = true;
                        isContactoViewClosed = true;
                        isFechaMaxViewClosed = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: kRadiusQ2Formulario,
                        border: Border.all(color: kUnderLineColor),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      height: isInfoViewClosed ? 67 : 180,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 23),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17),
                            child: Row(
                              children: <Widget>[
                                !isInfoCheckHidden
                                    ? Image.asset(
                                        'images/check.png',
                                        height: 15,
                                      )
                                    : Container(),
                                !isInfoCheckHidden
                                    ? SizedBox(width: 10)
                                    : Container(),
                                Text(
                                  'Notas del mandado',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      color: kBlackColor,
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                Image.asset(
                                  'images/arrow${isInfoViewClosed ? 'Down' : 'Up'}Botones.png',
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                          isInfoViewClosed
                              ? Container()
                              : Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 17),
                                    child: Text(
                                      '(Opcional)',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: kBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          isInfoViewClosed ? Container() : SizedBox(height: 24),
                          isInfoViewClosed
                              ? Container()
                              : M2TextFieldIniciarSesion(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  lineColor: kUnderLineColor,
                                  height: 70,
                                  placeholder: 'Ej: El contenido es frágil',
                                  initialValue: descripcion,
                                  onChanged: (text) {
                                    setState(() {
                                      descripcion = text;
                                    });
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Expanded(child: Container()),
            SizedBox(height: 20),

            /// BTN
            M2Button(
              title: mandado != null ? "Actualizar" : 'Continuar',
              isLoading: isLoadingBtn,
              backgroundColor: !isIdentificadorCheckHidden &&
                      !isContactoCheckHidden &&
                      !isLugarCheckHidden &&
                      !isFechaMaxCheckHidden
                  ? kGreenManda2Color
                  : kBlackColorOpacity,
              shadowColor: !isIdentificadorCheckHidden &&
                      !isContactoCheckHidden &&
                      !isLugarCheckHidden &&
                      !isFechaMaxCheckHidden
                  ? kGreenManda2Color.withOpacity(0.4)
                  : kBlackColorOpacity.withOpacity(0.4),
              onPressed: () {
                if (!isIdentificadorCheckHidden &&
                    !isContactoCheckHidden &&
                    !isLugarCheckHidden &&
                    !isFechaMaxCheckHidden) {
                  mandado = Mandado(
                    identificador: identificador,
                    descripcion: descripcion,
                    destino: Lugar(
                      contactoName: contactoName,
                      contactoPhoneNumber: contactoPhoneNumber,
                      ciudad: ciudad,
                      direccion: direccion,
                      barrio: barrio,
                      edificio: edificio,
                      apto: apto,
                      notas: notas,
                    ),
                    fechaMaxEntrega: fecha,
                  );

                  bool lugarAlreadyExists = false;
                  user.lugares.forEach((lugar) {
                    if (lugar.contactoPhoneNumber ==
                            mandado.destino.contactoPhoneNumber &&
                        lugar.contactoName == mandado.destino.contactoName &&
                        lugar.ciudad == mandado.destino.ciudad &&
                        lugar.direccion == mandado.destino.direccion &&
                        lugar.barrio == mandado.destino.barrio &&
                        lugar.edificio == mandado.destino.edificio &&
                        lugar.apto == mandado.destino.apto &&
                        lugar.notas == mandado.destino.notas) {
                      lugarAlreadyExists = true;
                      return;
                    }
                  });

                  if (mandado.destino.contactoPhoneNumber == null ||
                      mandado.destino.contactoPhoneNumber == "") {
                    mandado.destino.contactoPhoneNumber = user.phoneNumber;
                  }

                  if (lugarAlreadyExists) {
                    Navigator.pop(context, mandado);
                  } else {
                    _handleNewLugar();
                  }
                } else if (isIdentificadorCheckHidden &&
                    isContactoCheckHidden &&
                    isLugarCheckHidden &&
                    isFechaMaxCheckHidden) {
                  showBasicAlert(context, 'Campos incompletos',
                      'Por favor, rellena todos los campos para continuar.');
                } else if (isIdentificadorCheckHidden) {
                  showBasicAlert(context, 'Campos incompletos',
                      'Por favor, determina un identificador.');
                } else if (isContactoCheckHidden) {
                  showBasicAlert(context, 'Campos incompletos',
                      'Por favor, rellena todos los datos de contacto.');
                } else if (ciudad != null && ciudad == '') {
                  showBasicAlert(context, 'Campos incompletos',
                      'Por favor, determina la ciudad de entrega.');
                } else if (direccion != null && direccion == '') {
                  showBasicAlert(context, 'Campos incompletos',
                      'Por favor, determina la dirección de entrega.');
                }
              },
            ),
            SizedBox(height: 48)
          ],
        ),
      ),
    );
  }

  void _handleNewLugar() {
    Alert(
      context: context,
      style: alertStyle,
      title: '',
      content: Column(
        children: <Widget>[
          Image.asset(
            "images/noHayDirecciones.png",
            height: 89,
          ),
          SizedBox(height: 30),
          Text(
            "¿Quieres guardar esta dirección para futuras solicitudes?",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: kBlackColor,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.all(0),
                  color: kTransparent,
                  child: Text(
                    "Omitir",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: kBlackColorOpacity,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, mandado);
                  },
                ),
              ),
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.all(0),
                  color: kTransparent,
                  child: Text(
                    "Guardar",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: kGreenManda2Color,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _agregarDireccion();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      buttons: [
        DialogButton(
          height: 0,
          color: kTransparent,
          child: Container(height: 0),
        ),
      ],
      closeFunction: () {},
    ).show();
  }

  void _agregarDireccion() {
    setState(() {
      isLoadingBtn = true;
    });

    Map<String, dynamic> userMap = {
      "numDirecciones": user.numLugares + 1,
      "direcciones": FieldValue.arrayUnion([
        {
          "calle": direccion,
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
            direccion: direccion,
            edificio: edificio,
            apto: apto,
            contactoName: contactoName,
            contactoPhoneNumber: contactoPhoneNumber,
          ),
        );
        user.lugares = misLugares;
      });
      Navigator.pop(context, mandado);
      print("✔️ USER ACTUALIZADO");
    }).catchError((e) {
      setState(() {
        isLoadingBtn = false;
      });
      print("💩 ERROR AL ACTUALIZAR USER: $e");
    });
  }
}
