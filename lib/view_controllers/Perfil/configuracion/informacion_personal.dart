import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/slide_right_route.dart';
import 'dart:io';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_editar.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/internet_connection.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class EditarPerfil extends StatefulWidget {
  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  String name;
  String phoneNumber;

  bool isSavingChanges = false;

  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;
  Color passwordIconColor = kBlackColor;

  bool fotoChanged = false;
  File newFotoPerfilFile;
  bool deleteProfilePicPending = false;
  bool updateProfilePicPending = false;
  String newFotoPerfilURL;
  ImageProvider imageProvider = NetworkImage(user.fotoPerfilURL);

  @override
  void initState() {
    name = user.name;
    phoneNumber = user.phoneNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasConnection = Provider.of<InternetStatus>(context).connected;
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kBlackColor,
        backgroundColor: kLightGreyColor,
        border: Border(
          bottom: BorderSide(
            color: kTransparent,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: FittedBox(
          child: Text(
            "Cuenta",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: CatapultaScrollView(
          child: Column(
            children: <Widget>[
              M2AnimatedContainer(
                height: hasConnection ? 0 : 50,
              ),
              SizedBox(
                height: 45,
              ),
              Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kTransparent),
                        borderRadius: kRadiusAll,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Color(0x50D1D1D1),
                        highlightColor: Color(0x01D1D1D1),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kTransparent),
                            borderRadius: kRadiusAll,
                            color: Colors.lightBlue[100],
                          ),
                          height: MediaQuery.of(context).size.width * 0.2,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Image(
                              image: imageProvider,
                            ),
                          ),
                        ),
                      ),
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kTransparent),
                        borderRadius: kRadiusAll,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ],
                ),
              ),
              Center(
                child: CupertinoButton(
                  child: Text(
                    'Cambiar foto de perfil',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: kGreenManda2Color,
                      ),
                    ),
                  ),
                  onPressed: _handleProfilePicture,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              M2Editar(
                titulo: 'Nombre completo',
                initialValue: '${user.name}',
                capitalization: TextCapitalization.words,
                imageRoute: 'images/user.png',
                onChanged: (text) {
                  name = text;
                  setState(() {
                    if ((name != user.name ||
                            phoneNumber != user.phoneNumber ||
                            fotoChanged) &&
                        (name != null &&
                            name != "" &&
                            phoneNumber != null &&
                            phoneNumber != "")) {
                      buttonBackgroundColor = kGreenManda2Color;
                      buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                    } else {
                      buttonBackgroundColor = kBlackColorOpacity;
                      buttonShadowColor = kTransparent;
                    }
                  });
                },
              ),
              M2Editar(
                titulo: 'Celular',
                initialValue: '${user.phoneNumber}',
                imageRoute: 'images/celular.png',
                onChanged: (text) {
                  phoneNumber = text;
                  setState(() {
                    if ((name != user.name ||
                            phoneNumber != user.phoneNumber ||
                            fotoChanged) &&
                        (name != null &&
                            name != "" &&
                            phoneNumber != null &&
                            phoneNumber != "")) {
                      buttonBackgroundColor = kGreenManda2Color;
                      buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                    } else {
                      buttonBackgroundColor = kBlackColorOpacity;
                      buttonShadowColor = kTransparent;
                    }
                  });
                },
              ),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(17, 0, 17, 48),
                child: M2Button(
                  title: "Guardar cambios",
                  isLoading: isSavingChanges,
                  backgroundColor: buttonBackgroundColor,
                  shadowColor: buttonShadowColor,
                  onPressed: () async {
                    if (hasConnection &&
                        buttonBackgroundColor == kGreenManda2Color) {
                      setState(() {
                        isSavingChanges = true;
                      });

                      Map<String, dynamic> userMap = {};
                      if (deleteProfilePicPending) {
                        userMap = {
                          "phoneNumber": phoneNumber,
                          "name": name,
                          "fotoPerfilURL":
                              "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png",
                        };
                        _updateUser(userMap);
                      } else if (updateProfilePicPending) {
                        print("⏳ GUARDARÉ FOTO PERFIL");
                        Random random = Random();
                        StorageTaskSnapshot snapshot = await FirebaseStorage
                            .instance
                            .ref()
                            .child(
                                "fotosPerfil/${user.id}${random.nextInt(1000000000)}")
                            .putFile(newFotoPerfilFile)
                            .onComplete;

                        if (snapshot.error == null) {
                          print("✔️ FOTO PERFIL GUARDADA");

                          newFotoPerfilURL =
                              await snapshot.ref.getDownloadURL();

                          userMap = {
                            "phoneNumber": phoneNumber,
                            "name": name,
                            "fotoPerfilURL": newFotoPerfilURL,
                          };

                          _updateUser(userMap);
                        } else {
                          print(
                              "💩 ERROR AL OBTENER RESPONSE: ${snapshot.error}");
                        }
                      } else {
                        userMap = {
                          "phoneNumber": phoneNumber,
                          "name": name,
                        };
                        _updateUser(userMap);
                      }
                    } else {
                      if (name == null || name == "") {
                        showBasicAlert(
                            context, "Por favor, ingresa tu nombre.", "");
                      } else if (phoneNumber == null || phoneNumber == "") {
                        showBasicAlert(
                            context, "Por favor, ingresa tu teléfono.", "");
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _updateUser(Map<String, dynamic> userMap) {
    print("⏳ ACTUALIZARÉ USER");
    Firestore.instance
        .document("users/${user.id}")
        .updateData(userMap)
        .then((r) {
      print("✔️ USER ACTUALIZADO");
      setState(() {
        user.phoneNumber = phoneNumber;
        user.name = name;
        if (deleteProfilePicPending) {
          user.fotoPerfilURL =
              "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png";
        } else if (updateProfilePicPending) {
          user.fotoPerfilURL = newFotoPerfilURL;
        }
        isSavingChanges = false;
      });
      Navigator.pop(context, "Cambios guardados");
    }).catchError((e) {
      print("💩 ERROR AL ACTUALIZAR USER: $e");
      setState(() {
        isSavingChanges = false;
      });
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor, intenta más tarde.",
      );
    });
  }

  Future _openCamera() async {
    var img = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    setState(() {
      fotoChanged = true;
      buttonBackgroundColor = kGreenManda2Color;
      buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
      newFotoPerfilFile = img;
      imageProvider = FileImage(newFotoPerfilFile);
      updateProfilePicPending = true;
    });
    Navigator.pop(context);
  }

  Future _openGallery() async {
    var img = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    setState(() {
      fotoChanged = true;
      buttonBackgroundColor = kGreenManda2Color;
      buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
      newFotoPerfilFile = img;
      imageProvider = FileImage(newFotoPerfilFile);
      updateProfilePicPending = true;
    });
    Navigator.pop(context);
  }

  void _handleProfilePicture() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              "Tomar foto",
            ),
            onPressed: _openCamera,
          ),
          CupertinoActionSheetAction(
            child: Text("Seleccionar de galería"),
            onPressed: _openGallery,
          ),
          user.fotoPerfilURL !=
                  "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png"
              ? CupertinoActionSheetAction(
                  child: Text("Eliminar imagen"),
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      deleteProfilePicPending = true;
                      imageProvider = AssetImage("images/fotoPerfil.png");
                      fotoChanged = true;
                      buttonBackgroundColor = kGreenManda2Color;
                      buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                    });
                  },
                )
              : Container(),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, "Volver");
          },
        ),
      ),
    );
  }
}
