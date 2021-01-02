import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/components/m2_text_field_iniciar_sesion.dart';
import 'package:manda2/firebase/authentication.dart';
import 'package:manda2/firebase/handles/sign_up_handle.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/view_controllers/Home/home.dart';
import 'package:manda2/view_controllers/Terminos_y_condiciones/terminos_y_condiciones.dart';
import 'package:provider/provider.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/internet_connection.dart';

class CrearCuenta extends StatefulWidget {
  final bool isHaciendoTutorial;

  CrearCuenta({
    this.isHaciendoTutorial,
  });
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => CrearCuenta(),
    );
  }

  @override
  _CrearCuentaState createState() => _CrearCuentaState(isHaciendoTutorial: isHaciendoTutorial);
}

class _CrearCuentaState extends State<CrearCuenta> {
  String name;
  String phoneNumber;
  String email;
  String password;

  Color nameIconColor = kBlackColor;
  Color numberIconColor = kBlackColor;
  Color emailIconColor = kBlackColor;
  Color passwordIconColor = kBlackColor;

  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;
  RegExp emailRegExp = RegExp("[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+");

  bool isLoadingBtn = false;
  final bool isHaciendoTutorial;

  _CrearCuentaState({
    this.isHaciendoTutorial,
  });

  TapGestureRecognizer _gestureRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    _gestureRecognizer.onTap = () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => DocumentacionLegal(),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    bool hasConnection = Provider.of<InternetStatus>(context).connected;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kBlackColor,
        middle: Text(" "),
        border: Border.all(color: kTransparent),
        backgroundColor: kLightGreyColor,
      ),
      body: CatapultaScrollView(
        child: Column(
          children: <Widget>[
            M2AnimatedContainer(
              height: hasConnection ? 0 : 50,
              width: MediaQuery.of(context).size.width,
            ),
            Text(
              'Crear cuenta',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(textStyle: kTituloInicioSesion),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            M2TextFieldIniciarSesion(
              placeholder: 'Nombre completo',
              textCapitalization: TextCapitalization.words,
              imageRoute: 'images/user.png',
              keyboardType: TextInputType.text,
              iconColor: nameIconColor,
              onChanged: (text) {
                setState(() {
                  name = text;
                  if (name == '') {
                    nameIconColor = kBlackColor;
                  } else {
                    nameIconColor = kGreenManda2Color;
                  }
                });
              },
            ),
            M2TextFieldIniciarSesion(
              placeholder: 'Celular',
              imageRoute: 'images/celular.png',
              keyboardType: TextInputType.number,
              iconColor: numberIconColor,
              onChanged: (text) {
                setState(() {
                  phoneNumber = text;
                  if (phoneNumber == '') {
                    numberIconColor = kBlackColor;
                  } else {
                    numberIconColor = kGreenManda2Color;
                  }
                });
              },
            ),
            M2TextFieldIniciarSesion(
              placeholder: 'E-mail',
              imageRoute: 'images/mail.png',
              keyboardType: TextInputType.emailAddress,
              iconColor: emailIconColor,
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
            M2TextFieldIniciarSesion(
              placeholder: 'Contraseña',
              imageRoute: 'images/password.png',
              isPassword: true,
              keyboardType: TextInputType.text,
              iconColor: passwordIconColor,
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
            ),
            Expanded(child: Container()),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: kBlackColorOpacity,
                    ),
                  ),
                  children: [
                    TextSpan(
                      text: 'Al continuar, declaras que conoces y aceptas los ',
                    ),
                    TextSpan(
                      text: 'Términos y Condiciones ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kGreenManda2Color,
                      ),
                      recognizer: _gestureRecognizer,
                    ),
                    TextSpan(
                      text: 'y las ',
                    ),
                    TextSpan(
                      text: 'Políticas de Privacidad.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kGreenManda2Color,
                      ),
                      recognizer: _gestureRecognizer,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.020,
            ),
            M2Button(
              title: "Crear cuenta",
              isLoading: isLoadingBtn,
              width: MediaQuery.of(context).size.width - 34,
              onPressed: () {
                if (name == null || name == "") {
                  //Alerta email
                  showBasicAlert(context, "Por favor, ingresa tu nombre.", "");
                } else {
                  if (phoneNumber == null || phoneNumber == "") {
                    //Alerta password
                    showBasicAlert(context,
                        "Por favor, ingresa tu número de teléfono.", "");
                  } else if (email == null || email == "") {
                    //Alerta email
                    showBasicAlert(context, "Por favor, ingresa tu email.", "");
                  } else if (password == null || password == "") {
                    //Alerta email
                    showBasicAlert(
                        context, "Por favor, ingresa tu contraseña.", "");
                  } else if (emailRegExp.hasMatch(email)) {
                    registerUser();
                  } else {
                    showBasicAlert(context, "E-mail incorrecto",
                        "Por favor, ingresa un e-mail correcto.");
                  }
                }
              },
              backgroundColor: emailIconColor == kGreenManda2Color &&
                      passwordIconColor == kGreenManda2Color &&
                      numberIconColor == kGreenManda2Color &&
                      nameIconColor == kGreenManda2Color
                  ? buttonBackgroundColor = kGreenManda2Color
                  : buttonBackgroundColor = kBlackColorOpacity,
              shadowColor: emailIconColor == kGreenManda2Color &&
                      passwordIconColor == kGreenManda2Color &&
                      numberIconColor == kGreenManda2Color &&
                      nameIconColor == kGreenManda2Color
                  ? buttonShadowColor = kGreenManda2Color.withOpacity(0.4)
                  : buttonShadowColor = kTransparent,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.89,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      '¿Ya tienes una cuenta?',
                      style: GoogleFonts.poppins(textStyle: kNoCuenta),
                    ),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    child: FittedBox(
                      child: Text(
                        'Iniciar sesión',
                        style: GoogleFonts.poppins(textStyle: kInicioSesion),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  void registerUser() {
    setState(() {
      isLoadingBtn = true;
    });

    print("⏳ REGISTRARÉ USER");

    Auth().signUp(email, password).then((userId) async {
      Map<String, dynamic> userMap = {
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "roles": {
          "isAdmin": false,
          "isDomi": false,
          "estadoRegistroDomi": 0,
        },
        "creditCards": {
          "creditCardA": null,
          "creditCardB": null,
          "creditCardC": null,
        },
        "direcciones": FieldValue.arrayUnion([]),
        "dispositivos": FieldValue.arrayUnion([]),
        "favoriteCreditCard": null,
        "fotoPerfilURL":
            "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png",
        "hasReviewedBuyers": false,
        "hasReviewedDomis": false,
        "numEnvios": 0,
        "numTarjetas": 0,
        "numDirecciones": 0,
        "numSolicitudes": 0,
        "numTomados": 0,
        "payCount": 0,
        "categorias": [
          {
            "emoji": "📦",
            "title": "Paquetes",
            "numMandados": 0,
            "isHidden": false,
          },
          {
            "emoji": "✉️",
            "title": "Mensajería",
            "numMandados": 0,
            "isHidden": false,
          }
        ]
      };

      FirebaseUser firebaseUser = await Auth().getCurrentUser();
      Firestore.instance
          .collection("users")
          .document(userId)
          .setData(userMap)
          .then((r) {
        Firestore.instance
            .document("users/${firebaseUser?.uid}")
            .get()
            .then((userDoc) {
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

          /// Categorías
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
                  "emoji": "📦",
                  "title": "Paquetes",
                  "numMandados": 0,
                  "isHidden": false,
                },
                {
                  "emoji": "✉️",
                  "title": "Mensajería",
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
                  emoji: "📦",
                  title: "Paquetes",
                  numMandados: 0,
                  isHidden: false,
                ),
              );
              user.categorias.add(
                Categoria(
                  emoji: "✉️",
                  title: "Mensajería",
                  numMandados: 0,
                  isHidden: false,
                ),
              );
              user.numCategorias = 2;
            }).catchError((e) {
              print("💩 ERROR AL ENTREGAR GALLETAS: $e");
              user.categorias.add(
                Categoria(
                  emoji: "📦",
                  title: "Paquetes",
                  numMandados: 0,
                  isHidden: false,
                ),
              );
              user.categorias.add(
                Categoria(
                  emoji: "✉️",
                  title: "Mensajería",
                  numMandados: 0,
                  isHidden: false,
                ),
              );
              user.numCategorias = 2;
            });
          }

          print("✔️ USER DESCARGADO");
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Home(isHaciendoTutorial: isHaciendoTutorial,),
            ),
          );
          setState(() {
            isLoadingBtn = false;
          });
        }).catchError((e) {
          print("💩 ERROR AL OBTENER USUARIO: $e");
        });
        print("✔️️ USER REGISTRADO");
      });
    }).catchError((e) {
      print("💩️ ERROR AL REGISTRARSE: $e");
      if (e is PlatformException) {
        handleSignUpError(context, e.code);
      }
      setState(() {
        isLoadingBtn = false;
      });
    });
  }
}
