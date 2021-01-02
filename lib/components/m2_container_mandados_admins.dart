import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/formatted_money_value.dart';

class ContainerMandados extends StatelessWidget {
  ContainerMandados({
    this.numMandados,
    this.title,
    this.onTap
  });
  Function onTap;
  int numMandados;
  String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,

          decoration: BoxDecoration(
              borderRadius: kRadiusAll,
              color: kWhiteColor
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 70, 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 22
                      )
                  ),
                ),
                Text(numMandados == 1
                    ?'$numMandados mandado'
                    :'$numMandados mandados',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 12,
                            color: kBlackColor.withOpacity(0.5))
                    )
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
