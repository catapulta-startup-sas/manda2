import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:manda2/firebase/authentication.dart';
import 'package:manda2/firebase/handles/reset_password_handle.dart';
import 'package:manda2/firebase/handles/sign_out_handle.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_container_configuracion.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/view_controllers/registro/iniciar_sesion/iniciar_sesion.dart';
import 'package:manda2/view_controllers/Perfil/configuracion/reportar/reportar.dart';
import 'package:manda2/view_controllers/Terminos_y_condiciones/terminos_y_condiciones.dart';
import 'package:manda2/internet_connection.dart';

class Configuracion extends StatefulWidget {
  @override
  _ConfiguracionState createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  @override
  void initState() {
    super.initState();
  }

  bool successContainerIsHidden = true;
  String successContainerMessage;

  bool isChangingPassword = false;

  @override
  Widget build(BuildContext context) {
    bool hasConnection = Provider.of<InternetStatus>(context).connected;
    return Scaffold(
      backgroundColor: kLightGreyColor,
        appBar: CupertinoNavigationBar(
          backgroundColor: kLightGreyColor,
          actionsForegroundColor: kBlackColor,
          border: Border(
            bottom: BorderSide(
              color: kTransparent,
              width: 1.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
          middle: Text(
            "Configuración",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            color: kLightGreyColor,
            child: CatapultaScrollView(
              child: Column(
                children: <Widget>[
                  M2AnimatedContainer(
                    height: hasConnection ? 0 : 50,
                    width: MediaQuery.of(context).size.width,
                  ),
                  M2AnimatedContainer(
                    height: successContainerIsHidden ? 0 : 50,
                    backgroundColor: kGreenManda2Color.withOpacity(0.85),
                    text: successContainerMessage ?? "",
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Container(
                      color: kLightGreyColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          /// Cambiar contraseña
                          ContainerConfiguracion(
                            text: 'Cambiar contraseña',
                            isLoading: isChangingPassword,
                            onTap: () {
                              setState(() {
                                isChangingPassword = true;
                              });
                              print("⏳ ENVIARÉ EMAIL");
                              FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: user.email)
                                  .then((r) {
                                print("✔️ EMAIL ENVIADO");
                                showBasicAlert(
                                  context,
                                  "Mensaje enviado",
                                  "Hemos enviado un correo electrónico a ${user.email} con un enlace para restablecer la contraseña.",
                                );
                                setState(() {
                                  isChangingPassword = false;
                                });
                              }).catchError((e) {
                                print("💩 ERROR AL ENVIAR EMAIL: $e");
                                if (e is PlatformException) {
                                  handleResetPasswordError(context, e.code);
                                }
                                setState(() {
                                  isChangingPassword = false;
                                });
                              });
                            },
                          ),

                          /// Documentos
                          ContainerConfiguracion(
                            text: 'Documentación legal',
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => DocumentacionLegal(),
                                ),
                              );
                            },
                          ),

                          /// Eliminar cuenta
                          ContainerConfiguracion(
                            text: 'Eliminar cuenta',
                            onTap: () {
                              if (hasConnection) {
                                showAlert(
                                  context: context,
                                  title: "¿Te vas? 😣",
                                  body:
                                      "¿Qué tal si primero nos dices cómo podríamos mejorar? Nos encantaría conocer tu opinión.",
                                  actions: [
                                    AlertAction(
                                      text: "Eliminar cuenta",
                                      isDestructiveAction: true,
                                      onPressed: deleteUserBack,
                                    ),
                                    AlertAction(
                                      text: "Mejoremos juntos",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => Reportar(),
                                          ),
                                        );
                                      },
                                    ),
                                    AlertAction(
                                      text: "Volver",
                                      isDefaultAction: true,
                                    ),
                                  ],
                                );
                              } else {
                                showBasicAlert(
                                  context,
                                  "Sin internet",
                                  "Por favor, conéctate a internet para poder eliminar tu cuenta",
                                );
                              }
                            },
                          ),

                          /// Cerar sesion
                          ContainerConfiguracion(
                            flecha: false,
                            text: 'Cerrar sesión',
                            color: kRedActive,
                            onTap: () {
                              if (hasConnection) {
                                _alertLogOut();
                              } else {
                                showBasicAlert(
                                  context,
                                  "Sin internet",
                                  "Por favor, conéctate a internet para poder cerrar esta sesión",
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _alertLogOut() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text("¿Quieres cerrar sesión?"),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Cerrar sesión"),
            isDestructiveAction: true,
            onPressed: () {
              cerrarSesionBack();
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

  void deleteUserBack() async {
    print("⏳ ELIMINARÉ USER");
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    firebaseUser.delete().then((r) {
      print("✔️ USER ELIMINADO");
      print("⏳ ELIMINARÉ DATOS USER");
      Firestore.instance.document("users/${user.id}").delete().then((r) {
        print("✔️ USER ELIMINADO");
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => IniciarSesion(),
          ),
        );
        user = User();
      }).catchError((e) {
        print("💩 ERROR AL ELIMINAR DATOS DE USER: $e");
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => IniciarSesion(),
          ),
        );
        user = User();
      });
    }).catchError((e) {
      print("💩 ERROR AL ELIMINAR USER: $e");
      if (e is PlatformException && e.code == "ERROR_REQUIRES_RECENT_LOGIN") {
        showAlert(
          context: context,
          title: "Advertencia.",
          body:
              "Esta operación es sensible y requiere autenticación reciente. Por favor, inicia sesión de nuevo antes de eliminar tu cuenta.",
          actions: [
            AlertAction(text: "Volver"),
            AlertAction(text: "Cerrar sesión", onPressed: cerrarSesionBack),
          ],
        );
      } else {
        showBasicAlert(
          context,
          "Hubo un error.",
          "Por favor, intenta de nuevo más tarde",
        );
      }
    });
  }

  void cerrarSesionBack() async {
    print("⏳ CERRARÉ SESIÓN");
    Auth().signOut().then((r) {
      print("✔️ SESIÓN CERRADA");
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IniciarSesion(),
        ),
      );
      user = User();
    }).catchError((e) {
      print("💩️ ERROR AL CERRAR SESIÓN: $e");
      handleSignOutError(context);
    });
  }
}
