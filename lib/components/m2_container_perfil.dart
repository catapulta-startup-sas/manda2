import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class ContainerPerfil extends StatelessWidget {
  ContainerPerfil({
    @required this.imageRoute1,
    @required this.text,
    this.padding,
    this.onTap,
    this.width,
    this.color,
    this.iconColor,
    this.image,
  });

  String text;
  String imageRoute1;
  double padding;
  double width;
  Function onTap;
  Color color;
  Color iconColor;
  bool image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          children: <Widget>[
            Container(
              width: 10,
              height: 50,
              color: kLightGreyColor,
            ),
            Container(
              height: 50,
              child: Image(
                image: AssetImage('$imageRoute1'),
                fit: BoxFit.fitWidth,
                color: iconColor ?? kBlackColor,
                width: 22,
              ),
            ),
            Container(
              width: 10,
              height: 50,
              color: kLightGreyColor,
            ),
            Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$text',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 13,
                        color: color ?? kBlackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container(color: kLightGreyColor)),
            Image.asset("images/adelante.png", height: 12),
            Container(
              width: 10,
              height: 50,
              color: kLightGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
