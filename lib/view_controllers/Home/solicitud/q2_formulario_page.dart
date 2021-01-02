import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_text_field_iniciar_sesion.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/view_controllers/Home/solicitud/solicitud_q3_page.dart';
import 'package:manda2/view_controllers/Perfil/direcciones/direcciones.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Q2Formulario extends StatefulWidget {
  Q2Formulario({
    @required this.vieneMiDomicilio,
    this.catidad,
    this.categoria,
    this.tagLugarString,
    this.vieneResumen,
    this.origen,
  });

  final bool vieneMiDomicilio;
  bool vieneResumen;
  int catidad;
  Categoria categoria;
  Lugar origen;
  String tagLugarString;

  @override
  _Q2FormularioState createState() => _Q2FormularioState(
        vieneMiDomicilio: vieneMiDomicilio,
        cantidad: catidad,
        categoria: categoria,
        tagLugarString: tagLugarString,
        origen: origen,
        vieneResumen: vieneResumen,
      );
}

class _Q2FormularioState extends State<Q2Formulario>
    with SingleTickerProviderStateMixin {
  _Q2FormularioState({
    @required this.vieneMiDomicilio,
    this.vieneResumen,
    this.cantidad,
    this.categoria,
    this.tagLugarString,
    this.origen,
  });

  final bool vieneMiDomicilio;
  bool vieneResumen;
  Lugar origen;

  bool isLoadingBtn = false;

  Categoria categoria;

  String contactoName;
  String contactoPhoneNumber;
  String ciudad;
  String direccion;
  String barrio;
  String edificio;
  String apto;
  String notas;

  String tagLugarString;

  bool isContactoViewClosed = true;
  bool isLugarViewClosed = true;
  bool isContactoCheckHidden = true;
  bool isLugarCheckHidden = true;

  AnimationController _controller;
  CurvedAnimation _animation;

  int cantidad;

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
    if (vieneResumen != null && vieneResumen) {
      contactoName = origen.contactoName;
      contactoPhoneNumber = origen.contactoPhoneNumber;
      ciudad = origen.ciudad;
      direccion = origen.direccion;
      barrio = origen.barrio;
      edificio = origen.edificio;
      apto = origen.apto;
      notas = origen.notas;
      isLugarCheckHidden = false;
    } else if (vieneMiDomicilio) {
      vieneResumen = false;
      contactoName = user.name;
      contactoPhoneNumber = user.phoneNumber;
    } else {
      vieneResumen = false;
      contactoName = '';
      contactoPhoneNumber = '';
    }

    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          print("LISTO");
        }
      });

    if (contactoName != null &&
        contactoName != '' &&
        contactoPhoneNumber != null &&
        contactoPhoneNumber != '') {
      isContactoCheckHidden = false;
    } else {
      isContactoCheckHidden = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            "Datos de recogida",
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
              padding: EdgeInsets.all(24),
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
                                      )),
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

            /// PANEL 2
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

            SizedBox(height: 20),
            Expanded(child: Container()),
            M2Button(
              title: vieneResumen ? "Actualizar" : 'Continuar',
              isLoading: isLoadingBtn,
              backgroundColor: !isContactoCheckHidden && !isLugarCheckHidden
                  ? kGreenManda2Color
                  : kBlackColorOpacity,
              shadowColor: !isContactoCheckHidden && !isLugarCheckHidden
                  ? kGreenManda2Color.withOpacity(0.4)
                  : kBlackColorOpacity.withOpacity(0.4),
              onPressed: () {
                if (!isContactoCheckHidden && !isLugarCheckHidden) {
                  origen = Lugar(
                    contactoPhoneNumber: contactoPhoneNumber,
                    contactoName: contactoName,
                    ciudad: ciudad,
                    direccion: direccion,
                    barrio: barrio,
                    edificio: edificio,
                    apto: apto,
                    notas: notas,
                  );

                  bool lugarAlreadyExists = false;
                  user.lugares.forEach((lugar) {
                    if (lugar.contactoPhoneNumber ==
                            origen.contactoPhoneNumber &&
                        lugar.contactoName == origen.contactoName &&
                        lugar.ciudad == origen.ciudad &&
                        lugar.direccion == origen.direccion &&
                        lugar.barrio == origen.barrio &&
                        lugar.edificio == origen.edificio &&
                        lugar.apto == origen.apto &&
                        lugar.notas == origen.notas) {
                      lugarAlreadyExists = true;
                      return;
                    }
                  });

                  if (origen.contactoPhoneNumber == null ||
                      origen.contactoPhoneNumber == "") {
                    origen.contactoPhoneNumber = user.phoneNumber;
                  }

                  if (lugarAlreadyExists) {
                    _handleNavigation();
                  } else {
                    _handleNewLugar();
                  }
                } else {
                  showBasicAlert(
                    context,
                    "Campos faltantes",
                    "Por favor, completa todos los campos para continuar.",
                  );
                }
              },
            ),
            SizedBox(
              height: 48,
            )
          ],
        ),
      ),
    );
  }

  void _handleNavigation() {
    if (vieneResumen) {
      Navigator.pop(context, origen);
    } else {
      if (!isContactoCheckHidden && !isLugarCheckHidden) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SolicitudQ3(
              cantidad: cantidad,
              categoria: categoria,
              lugarString: tagLugarString,
              origen: origen,
            ),
          ),
        );
      } else {
        showBasicAlert(
          context,
          'Campos incompletos',
          'Por favor, rellena todos los campos para continuar',
        );
      }
    }
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
                    _handleNavigation();
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
      _handleNavigation();
      print("✔️ USER ACTUALIZADO");
    }).catchError((e) {
      setState(() {
        isLoadingBtn = false;
      });
      print("💩 ERROR AL ACTUALIZAR USER: $e");
    });
  }
}
