import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';

class M2Estado extends StatelessWidget {
  M2Estado({
    this.letra,
    this.colorTodo,
    this.colorBorde,
    this.colorLetra,
    this.colorFecha,
    this.colorEstado,
    this.fecha,
    this.texto,
  });

  String letra;
  Color colorTodo;
  Color colorBorde;
  Color colorLetra;
  Color colorFecha;
  Color colorEstado;
  String fecha;
  String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: kRadiusAll,
              color: colorTodo,
              border: Border.all(color: colorBorde, width: 2)),
          child: Center(
            child: Text(
              '$letra',
              style: GoogleFonts.poppins(
                  color: colorLetra ?? kWhiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              fecha != ""
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        '$fecha',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colorFecha ?? kGreenManda2Color)),
                      ),
                    )
                  : Expanded(child: Container()),
              Text(
                '$texto',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: colorEstado ?? kBlackColor)),
              ),
              Expanded(child: Container())
            ],
          ),
        )
      ],
    );
  }
}
