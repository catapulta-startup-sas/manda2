import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/formato_fecha.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:manda2/view_controllers/Admins/info_colaborador_o_comprador/resumen_detail.dart';

class Mandados extends StatefulWidget {
  Mandados({
    this.mandados,
    this.isDomi,
  });

  List<Mandado> mandados = [];
  bool isDomi;
  @override
  _MandadosState createState() =>
      _MandadosState(mandados: mandados, isDomi: isDomi);
}

class _MandadosState extends State<Mandados> {
  _MandadosState({
    this.mandados,
    this.isDomi,
  });

  List<Mandado> mandados = [];
  bool isDomi;

  double calificacion = 0.0;

  @override
  void initState() {
    super.initState();
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
          'Mandados ${isDomi ? "tomados" : "solicitados"}',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 17, color: kBlackColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: SafeArea(
        child: _loadedLayout(),
      ),
    );
  }

  Widget _loadedLayout() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isDomi ? "Calificación promedio" : 'Experiencia de cliente',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: kBlackColor,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                _getUserExperience() == null
                    ? const SizedBox.shrink()
                    : Image(
                        image: AssetImage('images/estrella.png'),
                        height: 12,
                        color: kGreenManda2Color,
                      ),
                const SizedBox(width: 5),
                _getUserExperience() == null
                    ? Text(
                        isDomi ? "Sin calificaciones" : 'No ha calificado',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: kBlackColorOpacity,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    : Text(
                        '${_getUserExperience()}',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: kBlackColor,
                          ),
                        ),
                      ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, position) {
                  return _setupList(mandados[position], position);
                },
                itemCount: mandados.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setupList(Mandado mandado, int position) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ResumenAdmin(
              mandado: mandado,
              isDomi: isDomi,
            ),
          ),
        );
      },
      child: Padding(
          padding: EdgeInsets.only(bottom: 10, top: 20),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration:
                BoxDecoration(color: kWhiteColor, borderRadius: kRadiusAdmins),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${mandado.categoria.title}',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 14, color: kBlackColor)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mandado.isTomado &&
                                mandado.isRecogido &&
                                mandado.isEntregado
                            ? 'Entregado ${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.entregadoDateTimeMSE)).toLowerCase()}'
                            : mandado.isTomado && mandado.isRecogido
                                ? 'En camino ${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.recogidoDateTimeMSE)).toLowerCase()}'
                                : 'Tomado ${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.tomadoDateTimeMSE)).toLowerCase()}'
                                    .length,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 12,
                                color: kBlackColor.withOpacity(0.5))),
                      ),
                      mandado.review.calification == null ||
                              mandado.review.calification == -1.0
                          ? const SizedBox()
                          : Row(
                              children: [
                                Image(
                                  image: AssetImage('images/estrella.png'),
                                  height: 12,
                                  color: kGreenManda2Color,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${mandado.review.calification}',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      color: kBlackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      Image(
                        image: AssetImage('images/adelante.png'),
                        height: 12,
                        color: kBlackColor,
                      )
                    ],
                  ),
                ),
                Text(
                  'Identificador: ${mandado.identificador}',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 12, color: kBlackColor.withOpacity(0.5))),
                )
              ],
            ),
          )),
    );
  }

  double _getUserExperience() {
    double acumulado = 0;
    List<Mandado> mandadosCalificados = mandados
        .where((mandado) =>
            mandado.review.calification != null &&
            mandado.review.calification != -1)
        .toList();
    if (mandadosCalificados.isNotEmpty) {
      mandadosCalificados.forEach((mandado) {
        acumulado = acumulado + mandado.review.calification;
      });
      return ((acumulado * 10 / mandadosCalificados.length).round() / 10);
    } else {
      return null;
    }
  }
}
