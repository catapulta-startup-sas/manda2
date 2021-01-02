import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/formatted_money_value.dart';

class ContainerUser extends StatelessWidget {
  ContainerUser({
    this.subtitle,
    this.title,
    this.onTap,
    this.flecha
  });
  Function onTap;
  String subtitle;
  String title;
  bool flecha = true;
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
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 22
                          )
                      ),
                    ),
                    Text(
                      subtitle,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 12,
                                color: kBlackColor.withOpacity(0.5))
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(width: 50),
              flecha ?? true
              ?Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset('images/adelante.png',height: 10,),
              )
                  : const SizedBox()

            ],
          ),
        ),

      ),
    );
  }
}