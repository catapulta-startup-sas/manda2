import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_container_aspitante.dart';
import 'package:manda2/components/m2_container_usuarios_admin.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/model/domiciliario_model.dart';
import 'package:manda2/model/user_model.dart';
import 'package:manda2/view_controllers/Admins/aspirantes/aceptar_rechazar_aspirante.dart';
import 'package:manda2/view_controllers/Admins/reportes/formulario_reportar_admins.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class Aspirantes extends StatefulWidget {
  @override
  _AspirantesState createState() => _AspirantesState();
}

List<Domiciliario> aspirantes = [];

class _AspirantesState extends State<Aspirantes> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  bool isLoadingAspirantes = true;

  @override
  void initState() {
    super.initState();

    _getAspirantes();
    _getReportes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Notificaciones",
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
        child: !isLoadingAspirantes ? _loadedLayout() : _loadingLayout(),
      ),
    );
  }

  int reportesA = 0;
  int reportesB = 0;
  int reportesC = 0;

  void _getReportes() async {
    /// REPORTES A
    Firestore.instance
        .collection("reportes")
        .where("tipoReporte", isEqualTo: "Algo no funciona")
        .snapshots()
        .listen((querySnapshot) async {
      setState(() {
        reportesA = querySnapshot.documents.length;
      });
    }).onError((e) {
      print("ERROR DESCARGANDO REPORTES: $e");
    });

    /// REPORTES B
    Firestore.instance
        .collection("reportes")
        .where("tipoReporte", isEqualTo: "Comentarios generales")
        .snapshots()
        .listen((querySnapshot) async {
      setState(() {
        reportesB = querySnapshot.documents.length;
      });
    }).onError((e) {
      print("ERROR DESCARGANDO REPORTES: $e");
    });

    /// REPORTES C
    Firestore.instance
        .collection("reportes")
        .where("tipoReporte", isEqualTo: "Problema con la calidad del servicio")
        .snapshots()
        .listen((querySnapshot) async {
      setState(() {
        reportesC = querySnapshot.documents.length;
      });
    }).onError((e) {
      print("ERROR DESCARGANDO REPORTES: $e");
    });
  }

  Widget _loadedLayout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 30),
            child: Text(
              'Reportes',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: kBlackColor,
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ContainerUser(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => FormularioReportarAdmin(
                          tipoReporte: "Algo no funciona",
                        ),
                      ),
                    );
                  },
                  title:
                      '$reportesA ${reportesA == 1 ? "reporte" : "reportes"}',
                  subtitle: 'Algo no funciona',
                  flecha: true,
                ),
                ContainerUser(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => FormularioReportarAdmin(
                          tipoReporte: "Comentarios generales",
                        ),
                      ),
                    );
                  },
                  title:
                      '$reportesB ${reportesB == 1 ? "reporte" : "reportes"}',
                  subtitle: 'Comentarios generales',
                  flecha: true,
                ),
                ContainerUser(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => FormularioReportarAdmin(
                          tipoReporte: "Problema con la calidad del servicio",
                        ),
                      ),
                    );
                  },
                  title:
                      '$reportesC ${reportesC == 1 ? "reporte" : "reportes"}',
                  subtitle: 'Problema con servicio',
                  flecha: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          aspirantes.length < 1
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Text(
                    'Aspirantes a colaborador',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: kBlackColor,
                      ),
                    ),
                  ),
                ),
          Container(
            height: 25,
          ),
          Expanded(
            child: aspirantes.length < 1
                ? Center(
                    child: Text(
                      'No hay solicitudes\npendientes a revisar.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: kBlackColorOpacity,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, position) {
                      return _setupList(position);
                    },
                    itemCount: aspirantes.length,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _setupList(int position) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: ContainerAspirante(
            nombre: aspirantes[position].user.name,
            vehiculo: aspirantes[position].vehiculo,
            fotoPerfilUrl: aspirantes[position].user.fotoPerfilURL,
            onTap: () async {
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => VistaAspirante(
                    aspirante: aspirantes[position],
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  aspirantes = result as List<Domiciliario>;
                });
              }
            },
          ),
        )
      ],
    );
  }

  Widget _loadingLayout() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(17, 30, 17, 30),
          child: Row(
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: kBlackColor.withOpacity(0.5),
                highlightColor: kBlackColor.withOpacity(0.2),
                child: Container(
                  height: 15,
                  width: 160,
                  decoration: BoxDecoration(
                    color: kBlackColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 17),
                height: 110,
                width: MediaQuery.of(context).size.width * 0.42,
                decoration: BoxDecoration(
                  borderRadius: kRadiusAll,
                  color: kWhiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Shimmer.fromColors(
                      baseColor: kBlackColor.withOpacity(0.5),
                      highlightColor: kBlackColor.withOpacity(0.2),
                      child: Container(
                        height: 15,
                        width: 90,
                        decoration: BoxDecoration(
                          color: kBlackColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Shimmer.fromColors(
                      baseColor: kBlackColor.withOpacity(0.5),
                      highlightColor: kBlackColor.withOpacity(0.2),
                      child: Container(
                        height: 15,
                        width: 60,
                        decoration: BoxDecoration(
                          color: kBlackColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 17),
                height: 110,
                width: MediaQuery.of(context).size.width * 0.42,
                decoration: BoxDecoration(
                  borderRadius: kRadiusAll,
                  color: kWhiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Shimmer.fromColors(
                      baseColor: kBlackColor.withOpacity(0.5),
                      highlightColor: kBlackColor.withOpacity(0.2),
                      child: Container(
                        height: 15,
                        width: 90,
                        decoration: BoxDecoration(
                          color: kBlackColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Shimmer.fromColors(
                      baseColor: kBlackColor.withOpacity(0.5),
                      highlightColor: kBlackColor.withOpacity(0.2),
                      child: Container(
                        height: 15,
                        width: 60,
                        decoration: BoxDecoration(
                          color: kBlackColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(17, 40, 17, 24),
          child: Row(
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: kBlackColor.withOpacity(0.5),
                highlightColor: kBlackColor.withOpacity(0.2),
                child: Container(
                  height: 15,
                  width: 160,
                  decoration: BoxDecoration(
                    color: kBlackColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 0, 17, 20),
                    child: Container(
                      height: 89,
                      width: MediaQuery.of(context).size.width - 34,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: kShadowGreyColor,
                            blurRadius: 6,
                            spreadRadius: 1,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    EdgeInsets.fromLTRB(17, 18, 10, 16),
                                    child: Row(
                                      children: <Widget>[
                                        Shimmer.fromColors(
                                          baseColor:
                                          kBlackColor.withOpacity(0.5),
                                          highlightColor:
                                          kBlackColor.withOpacity(0.2),
                                          child: Container(
                                            height: 55,
                                            width: 53,
                                            decoration: BoxDecoration(
                                              color:
                                              kBlackColor.withOpacity(0.1),
                                              borderRadius:
                                              BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      ///Nombre y comprador
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 2),
                                            child: Container(
                                                height: 25,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                    130,
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 17),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Shimmer.fromColors(
                                                            baseColor:
                                                            kBlackColor
                                                                .withOpacity(
                                                                0.5),
                                                            highlightColor:
                                                            kBlackColor
                                                                .withOpacity(
                                                                0.2),
                                                            child: Container(
                                                              height: 15,
                                                              width: 140,
                                                              decoration:
                                                              BoxDecoration(
                                                                color: kBlackColor
                                                                    .withOpacity(
                                                                    0.1),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    4),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),

                                      /// Comentario
                                      Row(
                                        children: <Widget>[
                                          Container(
                                              height: 20,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                                  130,
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    height: 40,
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                        150,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 17),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Shimmer.fromColors(
                                                            baseColor:
                                                            kBlackColor
                                                                .withOpacity(
                                                                0.5),
                                                            highlightColor:
                                                            kBlackColor
                                                                .withOpacity(
                                                                0.2),
                                                            child: Container(
                                                              height: 15,
                                                              width: 120,
                                                              decoration:
                                                              BoxDecoration(
                                                                color: kBlackColor
                                                                    .withOpacity(
                                                                    0.1),
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    4),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: aspirantes.length,
          ),
        ),
      ],
    );
  }

  Widget _aunNoLayout() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(
              'No hay solicitudes pendientes a revisar.',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: kBlackColorOpacity,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onRefresh() async {
    _getAspirantes();

    /// Este bool representa si el getData fue exitoso o no
    bool success = true;
    if (success) {
      refreshController.refreshCompleted();
      print("succeeded");
    } else {
      refreshController.refreshFailed();
      print("failed");
    }
  }

  /// Función que descarga las solicitudes de usuarios para ser domiciliario y las almacena en una lista llamada solicitudesDomi :
  /// (es necesario el modelo de SolicitudDomi)
  void _getAspirantes() {
    Firestore.instance
        .collection("users")
        .where("roles.isDomi", isEqualTo: false)
        .where("roles.estadoRegistroDomi", isEqualTo: 1)
        .snapshots()
        .listen((querySnapshot) async {
      aspirantes.clear();
      if (querySnapshot.documents.isEmpty) {
        print("${querySnapshot.documents.length} ASPIRANTES");
        setState(() {
          isLoadingAspirantes = false;
        });
      } else {
        print("${querySnapshot.documents.length} ASPIRANTES");
        querySnapshot.documents.forEach((userDoc) {
          Firestore.instance
              .document("domiciliarios/${userDoc.documentID}")
              .get()
              .then((domiDoc) {
            setState(() {
              aspirantes.add(
                Domiciliario(
                  user: User(
                    id: userDoc.documentID,
                    name: userDoc.data["name"],
                    email: userDoc.data["email"],
                    phoneNumber: userDoc.data["phoneNumber"],
                    fotoPerfilURL: userDoc.data["fotoPerfilURL"],
                  ),
                  banco: domiDoc.data["cuentaBancaria"]["banco"],
                  numeroCuentaBancaria: domiDoc.data["cuentaBancaria"]
                      ["numero"],
                  tipoCuentaBancaria: domiDoc.data["cuentaBancaria"]["tipo"],
                  dniNumber: domiDoc.data["dni"]["numero"],
                  dniType: domiDoc.data["dni"]["tipo"],
                  vehiculo: domiDoc.data["vehiculo"],
                ),
              );
              isLoadingAspirantes = false;
            });
          }).catchError((e) {
            setState(() {
              isLoadingAspirantes = false;
            });
            print("ERROR: $e");
          });
        });
      }
    }).onError((e) {
      setState(() {
        isLoadingAspirantes = false;
      });
      print("ERROR DESCARGANDO SOLICITUDES PARA SER DOMI: $e");
    });
  }
}
