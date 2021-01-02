import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:manda2/firebase/authentication.dart';
import 'package:manda2/firebase/handles/reset_password_handle.dart';
import 'package:manda2/firebase/handles/sign_out_handle.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/launch_whatsapp.dart';
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

class Soporte extends StatefulWidget {
  @override
  _SoporteState createState() => _SoporteState();
}

class _SoporteState extends State<Soporte> {
  @override
  void initState() {
    super.initState();
  }

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
            "Soporte",
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
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Container(
                      color: kLightGreyColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          /// Escribir a soporte
                          ContainerConfiguracion(
                            text: 'Escribir a soporte',
                            onTap: () {
                              launchWhatsApp(context,
                                  "$contactoSoporte".replaceAll("+", ""));
                            },
                          ),

                          /// Reportar problema
                          ContainerConfiguracion(
                            text: 'Reportar un problema',
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Reportar(),
                                ),
                              );
                            },
                          ),
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
}
