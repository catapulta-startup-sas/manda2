import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/formatted_money_value.dart';

class ContainerPaquete extends StatelessWidget {
  ContainerPaquete({
    this.cantidad,
    this.precio,
    this.onTap
});
  Function onTap;
  int cantidad;
  int precio;
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
                        formattedMoneyValue(precio),
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 22
                        )
                      ),
                    ),
                    Text(cantidad == 1
                        ?'x$cantidad envío'
                        :'x$cantidad envíos',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12,
                            color: kBlackColor.withOpacity(0.5))
                          )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset('images/adelante.png',height: 10,),
              )

            ],
          ),
        ),

      ),
    );
  }
}
