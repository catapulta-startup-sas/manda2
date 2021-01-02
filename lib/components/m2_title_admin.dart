import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class TitleAdmin extends StatelessWidget {
  String title;
  Color color;
  TitleAdmin({this.title, this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(17, 20, 17, 20),
      child: Container(
        height: 25,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 18,
                  color: color ?? kBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
