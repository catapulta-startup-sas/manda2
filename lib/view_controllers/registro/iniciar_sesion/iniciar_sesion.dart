import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/components/m2_text_field_iniciar_sesion.dart';
import 'package:manda2/firebase/authentication.dart';
import 'package:manda2/firebase/handles/sign_in_handle.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/internet_connection.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/view_controllers/Home/home.dart';
import 'package:manda2/view_controllers/banned_page.dart';
import 'package:manda2/view_controllers/registro/crear_cuenta/crear_cuenta.dart';
import 'package:manda2/view_controllers/registro/recuperar_contrasena/olvide_contrasena_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:manda2/constants.dart';

class IniciarSesion extends StatefulWidget {
  final bool isHaciendoTutorial;

  IniciarSesion({
    this.isHaciendoTutorial,
  });
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => IniciarSesion(),
    );
  }

  @override
  _IniciarSesionState createState() =>
      _IniciarSesionState(isHaciendoTutorial: isHaciendoTutorial);
}

class _IniciarSesionState extends State<IniciarSesion> {
  String email;
  String password;
  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;
  RegExp emailRegExp = RegExp("[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+");
  Color emailIconColor = kBlackColor;
  Color passwordIconColor = kBlackColor;

  bool succesfulLogin = false;
  bool isLoadingBtn = false;
  bool isHaciendoTutorial;

  _IniciarSesionState({
    this.isHaciendoTutorial,
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasConnection = Provider.of<InternetStatus>(context).connected;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              color: kGreenManda2Color,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            color: kLightGreyColor,
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.asset(
                                              "images/iniciarSesionCompradores.png"),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(17, 0, 0, 6),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                height: 20,
                                                child: FittedBox(
                                                  child: Text(
                                                    'Bienvenido a',
                                                    style: GoogleFonts.poppins(
                                                      textStyle:
                                                          ksubtituloInicioSesion,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 44,
                                                child: FittedBox(
                                                  child: Text(
                                                    'Manda2',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      textStyle:
                                                          kTituloInicioSesion,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.038,
                                ),
                                M2TextFieldIniciarSesion(
                                  placeholder: 'E-mail',
                                  imageRoute: 'images/mail.png',
                                  iconColor: emailIconColor,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (text) {
                                    setState(() {
                                      email = text;
                                      if (emailRegExp.hasMatch(text)) {
                                        emailIconColor = kGreenManda2Color;
                                      } else if (email == '') {
                                        emailIconColor = kBlackColor;
                                      } else {
                                        emailIconColor = kRedActive;
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                ),
                                M2TextFieldIniciarSesion(
                                  placeholder: 'Contraseña',
                                  imageRoute: 'images/password.png',
                                  isPassword: true,
                                  keyboardType: TextInputType.text,
                                  onChanged: (text) {
                                    setState(() {
                                      password = text;
                                      if (password == '') {
                                        passwordIconColor = kBlackColor;
                                      } else {
                                        passwordIconColor = kGreenManda2Color;
                                      }
                                    });
                                  },
                                  iconColor: passwordIconColor,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                                Container(
                                  height: 25,
                                  width:
                                      MediaQuery.of(context).size.width * 0.89,
                                  child: Stack(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Text(
                                              'Crear cuenta',
                                              style: GoogleFonts.poppins(
                                                textStyle: kCrearCuenta,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      CrearCuenta(
                                                          isHaciendoTutorial:
                                                              isHaciendoTutorial),
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Text(
                                              '¿Olvidaste tu contraseña?',
                                              style: GoogleFonts.poppins(
                                                textStyle: kOlvidoInicioSesion,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      OlvidePassword(),
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                M2Button(
                                  title: "Iniciar sesión",
                                  isLoading: isLoadingBtn,
                                  width: MediaQuery.of(context).size.width - 34,
                                  onPressed: () {
                                    if (email == null || email == "") {
                                      showBasicAlert(context,
                                          "Por favor, ingresa tu email.", "");
                                    } else {
                                      if (password == null || password == "") {
                                        //Alerta password
                                        showBasicAlert(
                                            context,
                                            "Por favor, ingresa tu contraseña.",
                                            "");
                                      } else if (emailRegExp.hasMatch(email)) {
                                        loginUser();
                                      } else {
                                        showBasicAlert(
                                            context,
                                            "E-mail incorrecto",
                                            "Por favor, ingresa un email correcto.");
                                      }
                                    }
                                  },
                                  backgroundColor: emailIconColor ==
                                              kGreenManda2Color &&
                                          passwordIconColor == kGreenManda2Color
                                      ? buttonBackgroundColor =
                                          kGreenManda2Color
                                      : buttonBackgroundColor =
                                          kBlackColorOpacity,
                                  shadowColor: emailIconColor ==
                                              kGreenManda2Color &&
                                          passwordIconColor == kGreenManda2Color
                                      ? buttonShadowColor =
                                          kGreenManda2Color.withOpacity(0.4)
                                      : buttonShadowColor = kTransparent,
                                ),
                                SizedBox(height: 48),
                              ],
                            ),
                          ),
                          M2AnimatedContainer(
                            height: hasConnection ? 0 : 50,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }

  void loginUser() {
    print("⏳ INICIARÉ SESIÓN");
    setState(() {
      isLoadingBtn = true;
    });

    Auth().signIn(email, password).then((firebaseUser) async {
      Firestore.instance
          .document("users/${firebaseUser?.uid}")
          .get()
          .then((userDoc) {
        if (userDoc.data["roles"]["isBloqueado"] == true) {
          // Usuario bloqueado
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => BannedPage(),
            ),
          );
        } else {
          user.id = userDoc.documentID;
          user.name = userDoc.data["name"];
          user.hasReviewedBuyers = userDoc.data['hasReviewedBuyers'];
          user.email = userDoc.data['email'];
          user.numEnvios = userDoc.data['numEnvios'];
          user.favoriteCreditCard = userDoc.data['favoriteCreditCard'];
          user.isAdmin = userDoc.data["roles"]["isAdmin"];
          user.numTarjetas = userDoc.data['numTarjetas'];
          user.numLugares = userDoc.data['numDirecciones'];
          user.payCount = userDoc.data['payCount'];
          user.phoneNumber = userDoc.data['phoneNumber'];
          user.userTks = userDoc.data['creditCards'];
          user.fotoPerfilURL = userDoc.data['fotoPerfilURL'];
          user.lugares = [];
          List<dynamic> direccionesTemp = userDoc.data["direcciones"];
          if (direccionesTemp != null && direccionesTemp.isNotEmpty) {
            direccionesTemp.forEach((direccion) {
              user.lugares.add(
                Lugar(
                  notas: direccion["notas"],
                  ciudad: direccion["ciudad"],
                  barrio: direccion["barrio"],
                  direccion: direccion["calle"],
                  edificio: direccion["edificio"],
                  contactoName: direccion["contacto"]["name"],
                  contactoPhoneNumber: direccion["contacto"]["phoneNumber"],
                ),
              );
            });
          }

          user.categorias = [];
          user.numCategorias = 0;
          List<dynamic> categoriasTemp = userDoc.data["categorias"];
          if (categoriasTemp != null && categoriasTemp.isNotEmpty) {
            categoriasTemp.reversed.toList().forEach((categoria) {
              user.categorias.add(
                Categoria(
                  emoji: categoria["emoji"],
                  title: categoria["title"],
                  numMandados: categoria["numMandados"],
                  isHidden: categoria["isHidden"],
                ),
              );
              if (!categoria["isHidden"]) {
                user.numCategorias++;
              }
            });
            user.categorias.sort((a, b) {
              if (a.isHidden) {
                return 1;
              } else {
                return -1;
              }
            });
          } else {
            print("🍪 NO TENGO GALLETAS");
            Map<String, dynamic> userMap = {
              "categorias": [
                {
                  "emoji": "🍪",
                  "title": "Galletas",
                  "numMandados": 0,
                  "isHidden": false,
                }
              ],
            };
            print("🍪 ENTREGARÉ GALLETAS");
            Firestore.instance
                .document("users/${user.id}")
                .updateData(userMap)
                .then((r) {
              print("✔️ GALLETAS ENTREGADAS");
              user.categorias.add(
                Categoria(
                  emoji: "🍪",
                  title: "Galletas",
                  numMandados: 0,
                  isHidden: false,
                ),
              );
              user.numCategorias++;
            }).catchError((e) {
              print("💩 ERROR AL ENTREGAR GALLETAS: $e");
              user.categorias.add(
                Categoria(
                  emoji: "🍪",
                  title: "Galletas",
                  numMandados: 0,
                  isHidden: false,
                ),
              );
              user.numCategorias++;
            });
          }

          print("✔️ USER DESCARGADO");
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) =>
                  Home(isHaciendoTutorial: isHaciendoTutorial),
            ),
          );
        }
        setState(() {
          isLoadingBtn = false;
        });
      }).catchError((e) {
        print("💩 ERROR AL OBTENER USUARIO: $e");
      });

      print("✔️ SESIÓN INICIADA");
    }).catchError((e) {
      print("💩️ ERROR AL INICIAR SESIÓN: $e");
      if (e is PlatformException) {
        handleSignInError(context, e.code);
      }
      setState(() {
        isLoadingBtn = false;
      });
    });
  }
}
