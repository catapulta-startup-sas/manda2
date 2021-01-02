import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';
import 'package:numeral/numeral.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// ignore: must_be_immutable
class ContainerEstadisticas extends StatelessWidget {
  ContainerEstadisticas(
      {this.comparacion,
      this.dinero,
      this.text,
      this.color,
      this.onTap,
      this.backgroundColor,
      this.progressColor,
      this.percent,
      this.reverse,
      this.percentText,});
  String comparacion;
  String text;
  bool dinero = false;
  Color color;
  Function onTap;
  bool reverse;
  var percent;
  Color progressColor;
  Color backgroundColor;
  Text percentText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
        child: Container(
          padding: EdgeInsets.fromLTRB(12, 26, 12, 39),
          width: 160,
          decoration: BoxDecoration(
            borderRadius: kRadiusAll,
            color: kWhiteColor,
          ),
          child: Column(
            children: <Widget>[
              CircularPercentIndicator(
                radius: 80,
                lineWidth: 5.0,
                animation: true,
                reverse: reverse ?? false,
                percent: percent ?? 0,
                center: percentText,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: progressColor,
                backgroundColor: backgroundColor,
              ),
              SizedBox(height: 12),
              Text(
                comparacion,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: kBlackColorOpacity,
                        fontSize: 13,
                        fontWeight: FontWeight.w300)),
              ),
              SizedBox(
                height: 13,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 70,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          text,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            color: kBlackColor,
                            fontSize: 18,
                          )),
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'images/adelante.png',
                    height: 10,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
