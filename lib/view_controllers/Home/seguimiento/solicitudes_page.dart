import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_estado_mandado.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/internet_connection.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/model/domiciliario_model.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:manda2/model/user_model.dart';
import 'package:manda2/view_controllers/Home/seguimiento/resumen_detail.dart';
import 'package:manda2/view_controllers/Home/solicitud/solicitud_q1_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class Solicitudes extends StatefulWidget {
  Solicitudes({this.categoria});
  Categoria categoria;

  @override
  _SolicitudesState createState() => _SolicitudesState(categoria: categoria);
}

class _SolicitudesState extends State<Solicitudes> {
  _SolicitudesState({this.categoria});
  Categoria categoria;

  Stream mandadosStream;
  Stream usersStream;
  Stream domiciliariosStream;

  List<String> mandadosIds = List();
  bool isLoadingHistorial = false;

  @override
  void initState() {
    initializeDateFormatting();
    _getMandadosStream();
    _getDomiciliariosStream();
    _getUsersStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasConnection = Provider.of<InternetStatus>(context).connected;
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
          actionsForegroundColor: kBlackColor,
          backgroundColor: kLightGreyColor,
          border: Border(
            bottom: BorderSide(
              color: kLightGreyColor,
              width: 1.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
          middle: FittedBox(
            child: Text(
              "${categoria.emoji} ${categoria.title}",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 17,
                  color: kBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          trailing: categoria.numMandados == 0 || categoria.numMandados == null
              ? SizedBox(
                  height: 5,
                )
              : GestureDetector(
                  child: Text(
                    "Nuevo",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 15, color: kBlackColor),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SolicitudQ1(
                          categoria: categoria,
                        ),
                      ),
                    );
                  },
                )),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            M2AnimatedContainer(
              height: hasConnection ? 0 : 50,
            ),
            Expanded(
              child: categoria.numMandados == 0 || categoria.numMandados == null
                  ? _aunNoLayout()
                  : StreamBuilder(
                      stream: mandadosStream,
                      builder: (context, mandadosSnapshot) {
                        return !mandadosSnapshot.hasData
                            ? _loadingLayout()
                            : StreamBuilder(
                                stream: domiciliariosStream,
                                builder: (context, domiciliariosSnapshot) {
                                  return !domiciliariosSnapshot.hasData
                                      ? _loadingLayout()
                                      : StreamBuilder(
                                          stream: usersStream,
                                          builder: (context, usersSnapshot) {
                                            List<Mandado> mandados =
                                                mandadosSnapshot.data.toList();
                                            if (usersSnapshot.hasData) {
                                              List<Domiciliario> domiciliarios =
                                                  domiciliariosSnapshot.data
                                                      .toList();
                                              List<User> users =
                                                  usersSnapshot.data.toList();

                                              domiciliarios
                                                  .forEach((domiciliario) {
                                                domiciliario.user =
                                                    users.firstWhere(
                                                  (user) =>
                                                      domiciliario.user.id ==
                                                      user.id,
                                                  orElse: () => User(
                                                    id: "eliminado",
                                                    name:
                                                        "Domiciliario eliminado",
                                                  ),
                                                );
                                              });
                                              mandados.removeWhere((mandado) =>
                                                  mandado.isHidden);
                                              mandados.forEach((mandado) {
                                                mandado.domiciliario =
                                                    domiciliarios.firstWhere(
                                                  (domiciliario) =>
                                                      mandado.domiciliario.user
                                                          .id ==
                                                      domiciliario.user.id,
                                                  orElse: () => Domiciliario(
                                                    califPromedio: 0.0,
                                                    cantidadCalificaciones: 0,
                                                    user: User(
                                                      id: "eliminado",
                                                      name:
                                                          "Domiciliario eliminado",
                                                    ),
                                                  ),
                                                );
                                              });
                                            }
                                            return mandadosSnapshot.data
                                                    .toList()
                                                    .isEmpty
                                                ? _aunNoLayout()
                                                : !usersSnapshot.hasData
                                                    ? _loadingLayout()
                                                    : ListView.builder(
                                                        itemBuilder: (context,
                                                            position) {
                                                          return _setupList(
                                                            mandados[position],
                                                          );
                                                        },
                                                        itemCount:
                                                            mandados.length,
                                                      );
                                          });
                                });
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setupList(Mandado mandado) {
    if (mandado.fechaMaxEntrega.isBefore(DateTime.now()) && !mandado.isTomado) {
      return EstadoMandado(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ResumenDetail(
                mandado: mandado,
              ),
            ),
          );
        },
        contactoName: mandado.destino.contactoName,
        direccion: '${mandado.destino.direccion}, ${mandado.destino.ciudad}',
        estado: "Vencido",
        color: kRedActive,
        imageRoute: 'images/cancelado.png',
        identificador: mandado.identificador,
        showsProgress: false,
        isVencido: true,
      );
    } else {
      return EstadoMandado(
        onTap: () async {
          var result = await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ResumenDetail(
                mandado: mandado,
              ),
            ),
          );

          if (result != null) {
            setState(() {});
          }
        },
        contactoName: mandado.destino.contactoName,
        direccion: '${mandado.destino.direccion}, ${mandado.destino.ciudad}',
        estadoDelMandado: mandado.isEntregado
            ? EstadoDelMandado.entregado
            : mandado.isRecogido
                ? EstadoDelMandado.recogido
                : mandado.isTomado
                    ? EstadoDelMandado.tomado
                    : EstadoDelMandado.publicado,
        estado: mandado.isEntregado
            ? 'Entregado'
            : mandado.isRecogido
                ? mandado.fechaMaxEntrega.isBefore(DateTime.now())
                    ? "Recogido con retraso"
                    : "Tu mandado fue recogido"
                : mandado.isTomado
                    ? mandado.fechaMaxEntrega.isBefore(DateTime.now())
                        ? "Tomado con retraso"
                        : 'Un colaborador tomó tu mandado'
                    : 'Mandado publicado',
        color: mandado.isEntregado ? kBlackColor : kBlackColorOpacity,
        isVencido: mandado.fechaMaxEntrega.isBefore(DateTime.now()) &&
            !mandado.isEntregado,
        imageRoute: mandado.isEntregado
            ? 'images/entregado.png'
            : mandado.isTomado
                ? 'images/tomado.png'
                : 'images/solicitado.png',
        identificador: mandado.identificador,
        showsProgress: !mandado.isEntregado,
        relevantDateTimeMSE: mandado.isEntregado
            ? mandado.entregadoDateTimeMSE
            : mandado.isRecogido
                ? mandado.recogidoDateTimeMSE
                : mandado.isTomado
                    ? mandado.tomadoDateTimeMSE
                    : mandado.createdDateTimeMSE,
      );
    }
  }

  Widget _loadingLayout() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, position) {
              return Padding(
                padding: EdgeInsets.fromLTRB(17, 20, 17, 0),
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    width: MediaQuery.of(context).size.width - 34,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: kRadiusAll,
                      boxShadow: [
                        BoxShadow(
                          color: kBlackColorOpacity.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ///Contacto
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Shimmer.fromColors(
                                baseColor: kBlackColor.withOpacity(0.5),
                                highlightColor: kBlackColor.withOpacity(0.2),
                                child: Container(
                                  height: 17,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: kBlackColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 17, 0, 15),
                                child: Shimmer.fromColors(
                                  baseColor: kBlackColor.withOpacity(0.5),
                                  highlightColor: kBlackColor.withOpacity(0.2),
                                  child: Container(
                                    height: 17,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: kBlackColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///Direccion
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Shimmer.fromColors(
                                baseColor: kBlackColor.withOpacity(0.5),
                                highlightColor: kBlackColor.withOpacity(0.2),
                                child: Container(
                                  height: 17,
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

                        ///estado icono

                        Row(
                          children: <Widget>[
                            Shimmer.fromColors(
                              baseColor: kBlackColor.withOpacity(0.5),
                              highlightColor: kBlackColor.withOpacity(0.2),
                              child: Container(
                                height: 17,
                                width: 120,
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
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: kBlackColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),

                        ///identificador
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: Row(
                            children: <Widget>[
                              Shimmer.fromColors(
                                baseColor: kBlackColor.withOpacity(0.5),
                                highlightColor: kBlackColor.withOpacity(0.2),
                                child: Container(
                                  height: 17,
                                  width: 100,
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
                                  height: 17,
                                  width: 170,
                                  decoration: BoxDecoration(
                                    color: kBlackColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: categoria.numMandados ?? 4,
          ),
        ),
      ],
    );
  }

  Widget _aunNoLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: Container()),
        Text(
          'Sin mandados solicitados',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: kBlackColorOpacity,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(child: Container()),
        M2Button(
          title: 'Solicitar mandado',
          backgroundColor: kGreenManda2Color,
          shadowColor: kGreenManda2Color.withOpacity(0.4),
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SolicitudQ1(
                    categoria: categoria,
                  ),
                ));
          },
        ),
        SizedBox(height: 48)
      ],
    );
  }

  void _getMandadosStream() async {
    mandadosStream = await Firestore.instance
        .collection("mandadosDesarrollo")
        .where("clienteId", isEqualTo: user.id)
        .where(
          "categoria",
          isEqualTo: {"emoji": categoria.emoji, "title": categoria.title},
        )
        .orderBy("created", descending: true)
        .snapshots()
        .map(
          (r) => r.documents.map(
            (v) => Mandado(
              id: v.documentID,
              identificador: v.data["identificador"],
              categoria: Categoria(
                emoji: v.data["categoria"]["emoji"],
                title: v.data["categoria"]["title"],
              ),
              domiciliario:
                  Domiciliario(user: User(id: v.data["domiciliarioId"])),
              isTomado: v.data["estados"]["isTomado"] ?? false,
              isRecogido: v.data["estados"]["isRecogido"] ?? false,
              isEntregado: v.data["estados"]["isEntregado"] ?? false,
              isCalificado: v.data["estados"]["isCalificado"] ?? false,
              isHidden: v.data["estados"]["isHidden"] ?? false,
              origen: Lugar(
                apto: v.data["puntoA"]["apto"],
                barrio: v.data["puntoA"]["barrio"],
                direccion: v.data["puntoA"]["calle"],
                ciudad: v.data["puntoA"]["ciudad"],
                contactoName: v.data["puntoA"]["contacto"],
                edificio: v.data["puntoA"]["edificio"],
                notas: v.data["puntoA"]["notas"],
                contactoPhoneNumber: v.data["puntoA"]["phoneNumber"],
              ),
              destino: Lugar(
                apto: v.data["puntoB"]["apto"],
                barrio: v.data["puntoB"]["barrio"],
                direccion: v.data["puntoB"]["calle"],
                ciudad: v.data["puntoB"]["ciudad"],
                contactoName: v.data["puntoB"]["contacto"],
                edificio: v.data["puntoB"]["edificio"],
                notas: v.data["puntoB"]["notas"],
                contactoPhoneNumber: v.data["puntoB"]["phoneNumber"],
              ),
              descripcion: v.data["descripcion"],
              tipoPago: v.data["pago"]["tipoPago"],
              total: v.data["pago"]["total"],
              cuotas: v.data["pago"]["cuotas"],
              cardType: v.data["pago"]["cardType"],
              lastFourDigits: v.data["pago"]["lastFourDigits"],
              fechaMaxEntregaStringFormatted: DateFormat('EEE d').format(
                  DateTime.fromMillisecondsSinceEpoch(v.data["vencimiento"])),
              horaMaxEntregaStringFormatted: DateFormat('hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(v.data["vencimiento"])),
              tomadoDateTimeMSE: v.data["estados"]["dates"]["tomado"],
              recogidoDateTimeMSE: v.data["estados"]["dates"]["recogido"],
              entregadoDateTimeMSE: v.data["estados"]["dates"]["entregado"],
              createdDateTimeMSE: v.data["created"],
              fechaMaxEntrega:
                  DateTime.fromMillisecondsSinceEpoch(v.data["vencimiento"]),
            ),
          ),
        );

    setState(() {});
  }

  void _getUsersStream() async {
    usersStream = await Firestore.instance
        .collection("users")
        .where("roles.isDomi", isEqualTo: true)
        .snapshots()
        .map(
          (r) => r.documents.map(
            (v) => User(
              id: v.documentID,
              name: v.data["name"],
              fotoPerfilURL: v.data["fotoPerfilURL"],
              phoneNumber: v.data["phoneNumber"],
            ),
          ),
        );
  }

  void _getDomiciliariosStream() async {
    domiciliariosStream =
        await Firestore.instance.collection("domiciliarios").snapshots().map(
              (r) => r.documents.map(
                (v) => Domiciliario(
                  user: User(id: v.documentID),
                  califPromedio:
                      (v.data["calificaciones"]["promedio"] ?? 0).toDouble(),
                  cantidadCalificaciones:
                      (v.data["calificaciones"]["cantidad"] ?? 0),
                ),
              ),
            );
  }
}
