import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';

class M2AnimatedContainer extends StatelessWidget {
  M2AnimatedContainer({
    @required this.height,
    this.width,
    this.text,
    this.backgroundColor,
  });

  String text;
  Color backgroundColor;
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: height,
      width: width,
      color: backgroundColor ?? Colors.redAccent.withOpacity(0.85),
      child: Center(
        child: Text(
          text ?? "Sin conexión a internet",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }
}
