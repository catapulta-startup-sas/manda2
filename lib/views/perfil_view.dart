import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_container_perfil.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/get_dispositivo_type.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/view_controllers/Admins/admins_tab.dart';
import 'package:manda2/view_controllers/Perfil/Envios_redimibles/redimibles.dart';
import 'package:manda2/view_controllers/Perfil/configuracion/configuracion.dart';
import 'package:manda2/view_controllers/Perfil/configuracion/informacion_personal.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PerfilView extends StatefulWidget {
  PerfilView({
    this.handleRateTap,
    this.handleSerDomiciliarioTap,
    this.handleSoporteTap,
    this.handleMisTarjetasTap,
    this.handleConfiguracionTap,
    this.handleEnviosTap,
    this.handleLugaresTap,
    this.handleDescargaApp,
  });

  Function handleRateTap;
  Function handleSerDomiciliarioTap;
  Function handleSoporteTap;
  Function handleMisTarjetasTap;
  Function handleLugaresTap;
  Function handleEnviosTap;
  Function handleConfiguracionTap;
  Function handleDescargaApp;

  @override
  _PerfilViewState createState() => _PerfilViewState(
      handleRateTap: handleRateTap,
      handleSerDomiciliarioTap: handleSerDomiciliarioTap,
      handleSoporteTap: handleSoporteTap,
      handleMisTarjetasTap: handleMisTarjetasTap,
      handleConfiguracionTap: handleConfiguracionTap,
      handleEnviosTap: handleEnviosTap,
      handleLugaresTap: handleLugaresTap,
      handleDescargaApp: handleDescargaApp);
}

class _PerfilViewState extends State<PerfilView> {
  _PerfilViewState({
    this.handleRateTap,
    this.handleSerDomiciliarioTap,
    this.hasConnection,
    this.handleSoporteTap,
    this.handleMisTarjetasTap,
    this.handleEnviosTap,
    this.handleLugaresTap,
    this.handleConfiguracionTap,
    this.handleDescargaApp,
  });

  Function handleSoporteTap;
  Function handleSerDomiciliarioTap;
  Function handleRateTap;
  Function handleMisTarjetasTap;
  Function handleLugaresTap;
  Function handleEnviosTap;
  Function handleConfiguracionTap;
  Function handleDescargaApp;

  bool hasConnection;

  @override
  Widget build(BuildContext context) {
    return CatapultaScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 31),
                child: Image.asset("images/cuadrosDetrasDePerfil.png"),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kTransparent),
                            borderRadius: kRadiusAll,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Color(0x50D1D1D1),
                            highlightColor: Color(0x01D1D1D1),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: kTransparent),
                                borderRadius: kRadiusAll,
                                color: Colors.lightBlue[100],
                              ),
                              height: MediaQuery.of(context).size.width * 0.2,
                              width: MediaQuery.of(context).size.width * 0.2,
                            ),
                          ),
                          height: MediaQuery.of(context).size.width * 0.2,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kTransparent),
                            borderRadius: kRadiusAll,
                            image: DecorationImage(
                              image: NetworkImage(user.fotoPerfilURL ??
                                  "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: MediaQuery.of(context).size.width * 0.2,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ],
          ),

          FittedBox(
            child: Text(
              "${user.name}",
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15)),
            ),
          ),
          GestureDetector(
            child: Text(
              "Editar perfil",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 12,
                  color: kGreenManda2Color,
                ),
              ),
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => EditarPerfil(),
                ),
              );

              if (result != null) {
                setState(() {
                  print("AEE: $result");
                  user.fotoPerfilURL = user.fotoPerfilURL;
                });
              }
            },
          ),
          SizedBox(height: 24),

          user.isAdmin ?? false
              ? ContainerPerfil(
                  imageRoute1: 'images/admin.png',
                  iconColor: kGreenManda2Color,
                  text: 'Gestión de administrador',
                  color: kGreenManda2Color,
                  padding: 15,
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AdminsTab(),
                      ),
                    );
                  },
                )
              : Container(),

          /// Mis Tarjetas
          ContainerPerfil(
            imageRoute1: 'images/misTarjetas.png',
            text: 'Mis tarjetas',
            onTap: handleMisTarjetasTap,
          ),

          /// Mis Lugares
          ContainerPerfil(
            imageRoute1: 'images/lugares.png',
            text: 'Mis lugares',
            onTap: handleLugaresTap,
          ),

          /// Envios
          ContainerPerfil(
            imageRoute1: 'images/enviosRedimibles.png',
            text: 'Envíos redimibles',
            onTap: handleEnviosTap,
          ),

          /// Soporte
          ContainerPerfil(
            imageRoute1: 'images/soporte.png',
            text: 'Soporte',
            onTap: handleSoporteTap,
          ),

          /// Configuración
          ContainerPerfil(
            imageRoute1: 'images/configuracion.png',
            text: 'Configuración',
            onTap: handleConfiguracionTap,
          ),

          /// Quiero ser
          ContainerPerfil(
            imageRoute1: 'images/domiciliario.png',
            text: 'Quiero ser colaborador',
            onTap: handleSerDomiciliarioTap,
          ),

          Expanded(child: SizedBox(height: 24)),

          /// Versionamiento
          Text(
            "v$vLocal.\0",
            textAlign: TextAlign.left,
            style: estilo.copyWith(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          isUpdated
              ? Text(
                  'Última versión',
                  textAlign: TextAlign.left,
                  style: estilo.copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: handleDescargaApp,
                      child: Text(
                        'Actualizar app',
                        textAlign: TextAlign.left,
                        style: estilo.copyWith(
                          color: kGreenManda2Color,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
