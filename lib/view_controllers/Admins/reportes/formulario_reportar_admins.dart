import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_container_reporte.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/formato_fecha.dart';
import 'package:manda2/model/reporte_model.dart';
import 'package:manda2/model/user_model.dart';
import 'package:manda2/view_controllers/Admins/reportes/vista_usuario.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class FormularioReportarAdmin extends StatefulWidget {
  String tipoReporte;

  FormularioReportarAdmin({this.tipoReporte});

  @override
  _FormularioReportarAdminState createState() =>
      _FormularioReportarAdminState(tipoReporte: tipoReporte);
}

class _FormularioReportarAdminState extends State<FormularioReportarAdmin> {
  _FormularioReportarAdminState({this.tipoReporte});

  String tipoReporte;
  List<Reporte> reportes = [];
  bool isLoadingReportes = true;

  @override
  void initState() {
    super.initState();
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
          tipoReporte == 'Algo no funciona'
              ? "Algo no funciona"
              : tipoReporte == 'Comentarios generales'
                  ? 'Comentarios generales'
                  : 'Problema con el servicio',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 17, color: kBlackColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: SafeArea(
        child: isLoadingReportes
            ? _loadingLayout()
            : reportes.isEmpty
                ? _aunNoLayout()
                : _loadedLayout(),
      ),
    );
  }

  Widget _loadedLayout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position) {
                return _setupList(position);
              },
              itemCount: reportes.length,
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
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ContainerReporte(
            nombre: reportes[position].reportante.name,
            comentario: reportes[position].comentario,
            fotoPerfilURL: reportes[position].reportante.fotoPerfilURL,
            isDomi: reportes[position].reportante.isDomi,
            fecha: dateFormattedFromDateTime(reportes[position].fecha),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => VistaPerfil(
                    reporte: reportes[position],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget _loadingLayout() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 0, 17, 20),
                    child: Container(
                      height: 121,
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
                                        EdgeInsets.fromLTRB(21, 32, 10, 41),
                                    child: Row(
                                      children: <Widget>[
                                        Shimmer.fromColors(
                                          baseColor:
                                              kBlackColor.withOpacity(0.5),
                                          highlightColor:
                                              kBlackColor.withOpacity(0.2),
                                          child: Container(
                                            height: 48,
                                            width: 46,
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
                                                top: 28, bottom: 9),
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
                                                              width: 70,
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
                                                    Expanded(
                                                      child: Container(),
                                                    ),
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
                                                              width: 70,
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
                                              height: 40,
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
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  200,
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
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Shimmer.fromColors(
                                                        baseColor: kBlackColor
                                                            .withOpacity(0.5),
                                                        highlightColor:
                                                            kBlackColor
                                                                .withOpacity(
                                                                    0.2),
                                                        child: Container(
                                                          height: 15,
                                                          width: 15,
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
            itemCount: 1,
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
              'No hay reportes',
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
    _getReportes();
  }

  void _getReportes() async {
    setState(() {
      isLoadingReportes = true;
    });

    Firestore.instance
        .collection("reportes")
        .where("tipoReporte", isEqualTo: tipoReporte)
        .snapshots()
        .listen((querySnapshot) async {
      reportes.clear();
      if (querySnapshot.documents.isEmpty) {
        setState(() {
          isLoadingReportes = false;
        });
      } else {
        querySnapshot.documents.forEach((reporteDoc) {
          Reporte reporte = Reporte(reportante: User());
          reporte.id = reporteDoc.documentID;
          reporte.comentario = reporteDoc.data["comentario"];
          reporte.fecha = DateTime.fromMillisecondsSinceEpoch(
            reporteDoc.data["created"],
          );
          Firestore.instance
              .document("users/${reporteDoc.data["ownerId"]}")
              .get()
              .then((userDoc) {
            if (userDoc.exists) {
              User reportante = User();
              reportante.name = userDoc.data["name"];
              reportante.phoneNumber = userDoc.data["phoneNumber"];
              reportante.fotoPerfilURL = userDoc.data["fotoPerfilURL"];
              reportante.email = userDoc.data["email"];
              reportante.isDomi = userDoc.data["roles"]["isDomi"];
              reporte.reportante = reportante;
            } else {
              User reportante = User();
              reportante.name = "[Eliminó cuenta]";
              reportante.phoneNumber = "xxxx";
              reportante.email = "xxxx@xxxxx.xxx";
              reportante.fotoPerfilURL =
                  "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png";
              reportante.isDomi = false;
              reporte.reportante = reportante;
            }
            setState(() {
              reportes.add(reporte);
              isLoadingReportes = false;
            });
          });
        });
      }
    }).onError((e) {
      print("ERROR DESCARGANDO REPORTES: $e");
      setState(() {
        isLoadingReportes = false;
      });
    });
  }
}
