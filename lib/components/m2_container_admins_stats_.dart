import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/formatted_money_value.dart';

class ContainerStats extends StatelessWidget {
  ContainerStats({
    this.ingreso,
    this.title,
  });
  int ingreso;
  String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: 203,
        height: 90,
        decoration: BoxDecoration(
            borderRadius: kRadiusAll,
            color: kWhiteColor,
          boxShadow: [
            BoxShadow(
              color: kBlackColorOpacity.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 22,
                      fontWeight: FontWeight.w500
                    )
                ),
              ),
              Text(formattedMoneyValue(ingreso),
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: kBlackColor.withOpacity(0.5))
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}