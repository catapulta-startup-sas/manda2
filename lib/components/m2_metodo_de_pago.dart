import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';

class TipoPagoContainer extends StatelessWidget {
  TipoPagoContainer({this.imageRoute, this.text, this.onTap});
  String text;
  String imageRoute;
  Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 65,
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: kRadiusAll,
            boxShadow: [
              BoxShadow(
                color: kBlackColorOpacity.withOpacity(0.17),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Image(
                  image: AssetImage('$imageRoute'),
                  height: 25,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                height: 25,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      '$text',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15,
                              color: kBlackColor,
                              fontWeight: FontWeight.w300)),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
