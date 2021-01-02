import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';

class Manda2AunNoView extends StatelessWidget {
  Manda2AunNoView({
    @required this.imagePath,
    @required this.title,
    @required this.subtitle,
    this.padding,
    this.height,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final EdgeInsets padding;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: padding ?? EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Image(
            image: AssetImage(imagePath),
            height: height ?? 55,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: kBlackColorOpacity
            )
          ),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: kBlackColorOpacity
              )
          ),
        ),

      ],
    );
  }
}
