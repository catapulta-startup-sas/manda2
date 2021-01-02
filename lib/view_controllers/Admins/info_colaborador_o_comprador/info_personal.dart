import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_container_configuracion.dart';
import 'package:manda2/functions/llamar.dart';
import 'package:manda2/model/user_model.dart';

import '../../../constants.dart';

class InfoPersonal extends StatefulWidget {
  InfoPersonal({this.user});
  User user;
  @override
  _InfoPersonalState createState() => _InfoPersonalState(user: user);
}

class _InfoPersonalState extends State<InfoPersonal> {
  _InfoPersonalState({this.user});
  User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kLightGreyColor,
        appBar: CupertinoNavigationBar(
          backgroundColor: kLightGreyColor,
          actionsForegroundColor: kBlackColor,
          border: Border(
            bottom: BorderSide(
              color: kTransparent,
              width: 1.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
          middle: Text(
            "Información personal",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(17, 30, 17, 0),
            child: Container(
              color: kLightGreyColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Nombre completo',
                    style: GoogleFonts.poppins(
                        textStyle:
                            TextStyle(fontSize: 15, color: kBlackColorOpacity)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${user.name}',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 15, color: kBlackColor)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'E-mail',
                    style: GoogleFonts.poppins(
                        textStyle:
                            TextStyle(fontSize: 15, color: kBlackColorOpacity)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${user.email}',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 15, color: kBlackColor)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Celular',
                    style: GoogleFonts.poppins(
                        textStyle:
                            TextStyle(fontSize: 15, color: kBlackColorOpacity)),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${user.phoneNumber}',
                        style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(fontSize: 15, color: kBlackColor)),
                      ),
                      GestureDetector(
                        onTap: () {
                          llamar(context, user.phoneNumber);
                        },
                        child: Text(
                          'Llamar',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  color: kGreenManda2Color,
                                  fontWeight: FontWeight.w300)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
