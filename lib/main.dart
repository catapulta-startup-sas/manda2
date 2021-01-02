import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/authentication.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/view_controllers/Home/home.dart';
import 'package:manda2/view_controllers/actualizar_page.dart';
import 'package:manda2/view_controllers/registro/diapositivas/diapositivas.dart';
import 'package:manda2/internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:manda2/view_controllers/registro/iniciar_sesion/iniciar_sesion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'functions/get_dispositivo_type.dart';
import 'view_controllers/banned_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = await prefs.getBool("isFirstTime") ?? true;

  InternetStatus status = new InternetStatus();
  status.checkCurrentConnection();

  getDispositivoType();

  Firestore.instance.document("constantes/doc1").snapshots().listen((doc) {
    contactoSoporte = doc.data["soporte"]["compradores"];

    ingresosTotales = doc.data["ingresosTotales"];

    pubKey = doc.data["wompi"]["pubKey"];
    prvKey = doc.data["wompi"]["prvKey"];

    linkAppStoreDomis = doc.data["tiendasURLs"]["appstore"]["domiciliarios"];
    linkPlayStoreDomis = doc.data["tiendasURLs"]["playstore"]["domiciliarios"];

    if (dispositivo == Dispositivo.ios) {
      actualizacionNecesaria =
          doc.data["actualizacionNecesaria"]["viOS"]["compradores"];
      vBack = doc.data["versiones"]["viOS"]["compradores"];
      if (vLocal < vBack) {
        updateURL = doc.data["tiendasURLs"]["appstore"]["compradores"];
        isUpdated = false;
      }
    } else if (dispositivo == Dispositivo.android) {
      actualizacionNecesaria =
          doc.data["actualizacionNecesaria"]["vAndroid"]["compradores"];
      vBack = doc.data["versiones"]["vAndroid"]["compradores"];
      if (vLocal < vBack) {
        updateURL = doc.data["tiendasURLs"]["playstore"]["compradores"];
        isUpdated = false;
      }
    }

    Firestore.instance
        .collection("paquetes")
        .where("cantidad", isEqualTo: 1)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.documents.isEmpty) {
        print("⚠️ SIN PRECIO INDIVIDUAL");
      } else {
        print("✔️ PRECIO INDIVIDUAL OBTENIDO");
        querySnapshot.documents.forEach((paqueteDoc) {
          if (paqueteDoc.data["cantidad"] == 1) {
            precioIndividual = paqueteDoc.data["precio"];
          }
        });
      }
    }).onError((e) {
      print("💩 ERROR AL OBTENER PRECIO INDIVIDUAL: $e");
      precioIndividual = 10000;
    });

    isUpdated
        ? print("✔️ v$vLocal.0 INSTALADA")
        : print("⚠️ ACTUALIZA A v$vBack");

    actualizacionNecesaria && !isUpdated
        ? print("⚠️ NECESITA ACTUALIZAR")
        : print("✔️ VERSIÓN COMPATIBLE");

    if (actualizacionNecesaria && !isUpdated) {
      runApp(
        ChangeNotifierProvider<InternetStatus>(
          create: (context) => status,
          child: MaterialApp(
            theme: ThemeData(primaryColor: kGreenManda2Color),
            home: ActualizarPage(),
          ),
        ),
      );
    } else {
      Auth().getCurrentUser().then((firebaseUser) {
        if (firebaseUser != null) {
          // Sesión activa
          Firestore.instance
              .document("users/${firebaseUser?.uid}")
              .get()
              .then((userDoc) {
            if (userDoc.data["roles"]["isBloqueado"] == true) {
              // Usuario bloqueado
              runApp(
                ChangeNotifierProvider<InternetStatus>(
                  create: (context) => status,
                  child: MaterialApp(
                    theme: ThemeData(primaryColor: kGreenManda2Color),
                    debugShowCheckedModeBanner: false,
                    home: BannedPage(),
                  ),
                ),
              );
            } else {
              // Usuario habilitado
              user.id = userDoc.documentID;
              user.name = userDoc.data["name"];
              user.hasReviewedBuyers = userDoc.data['hasReviewedBuyers'];
              user.email = userDoc.data['email'];
              user.numEnvios = userDoc.data['numEnvios'];
              user.favoriteCreditCard = userDoc.data['favoriteCreditCard'];
              user.isAdmin = userDoc.data["roles"]["isAdmin"];
              user.numTarjetas = userDoc.data['numTarjetas'];
              user.numLugares = userDoc.data['numDirecciones'];
              user.payCount = userDoc.data['payCount'];
              user.phoneNumber = userDoc.data['phoneNumber'];
              user.userTks = userDoc.data['creditCards'];
              user.fotoPerfilURL = userDoc.data['fotoPerfilURL'];

              user.lugares = [];
              List<dynamic> direccionesTemp = userDoc.data["direcciones"];
              if (direccionesTemp != null && direccionesTemp.isNotEmpty) {
                direccionesTemp.forEach((direccion) {
                  user.lugares.add(
                    Lugar(
                      notas: direccion["notas"],
                      ciudad: direccion["ciudad"],
                      barrio: direccion["barrio"],
                      direccion: direccion["calle"],
                      edificio: direccion["edificio"],
                      contactoName: direccion["contacto"]["name"],
                      contactoPhoneNumber: direccion["contacto"]["phoneNumber"],
                    ),
                  );
                });
              }

              /// Categorías
              user.categorias = [];
              user.numCategorias = 0;
              List<dynamic> categoriasTemp = userDoc.data["categorias"];
              if (categoriasTemp != null && categoriasTemp.isNotEmpty) {
                categoriasTemp.reversed.toList().forEach((categoria) {
                  user.categorias.add(
                    Categoria(
                      emoji: categoria["emoji"],
                      title: categoria["title"],
                      numMandados: categoria["numMandados"],
                      isHidden: categoria["isHidden"],
                    ),
                  );
                  if (!categoria["isHidden"]) {
                    user.numCategorias++;
                  }
                });
                user.categorias.sort((a, b) {
                  if (a.isHidden) {
                    return 1;
                  } else {
                    return -1;
                  }
                });
              } else {
                print("🍪 NO TENGO GALLETAS");
                Map<String, dynamic> userMap = {
                  "categorias": [
                    {
                      "emoji": "📦",
                      "title": "Paquetes",
                      "numMandados": 0,
                      "isHidden": false,
                    },
                    {
                      "emoji": "✉️",
                      "title": "Mensajería",
                      "numMandados": 0,
                      "isHidden": false,
                    }
                  ],
                };
                print("🍪 ENTREGARÉ GALLETAS");
                Firestore.instance
                    .document("users/${user.id}")
                    .updateData(userMap)
                    .then((r) {
                  print("✔️ GALLETAS ENTREGADAS");
                  user.categorias.add(
                    Categoria(
                      emoji: "📦",
                      title: "Paquetes",
                      numMandados: 0,
                      isHidden: false,
                    ),
                  );
                  user.categorias.add(
                    Categoria(
                      emoji: "✉️",
                      title: "Mensajería",
                      numMandados: 0,
                      isHidden: false,
                    ),
                  );
                  user.numCategorias = 2;
                }).catchError((e) {
                  print("💩 ERROR AL ENTREGAR GALLETAS: $e");
                  user.categorias.add(
                    Categoria(
                      emoji: "📦",
                      title: "Paquetes",
                      numMandados: 0,
                      isHidden: false,
                    ),
                  );
                  user.categorias.add(
                    Categoria(
                      emoji: "✉️",
                      title: "Mensajería",
                      numMandados: 0,
                      isHidden: false,
                    ),
                  );
                  user.numCategorias = 2;
                });
              }

              print("✔️ USER DESCARGADO");
              runApp(
                ChangeNotifierProvider<InternetStatus>(
                  create: (context) => status,
                  child: MaterialApp(
                    theme: ThemeData(primaryColor: kGreenManda2Color),
                    debugShowCheckedModeBanner: false,
                    home: Home(),
                  ),
                ),
              );
            }
          }).catchError((e) {
            print("💩 ERROR AL OBTENER USUARIO: $e");
          });
        } else {
          if (isFirstTime) {
            runApp(
              ChangeNotifierProvider<InternetStatus>(
                create: (context) => status,
                child: MaterialApp(
                  theme: ThemeData(primaryColor: kGreenManda2Color),
                  home: Diapositivas(),
                ),
              ),
            );
          } else {
            runApp(
              ChangeNotifierProvider<InternetStatus>(
                create: (context) => status,
                child: MaterialApp(
                  theme: ThemeData(primaryColor: kGreenManda2Color),
                  home: IniciarSesion(),
                ),
              ),
            );
          }
        }
      });
    }
  }).onError((e) {
    print("💩 ERROR AL OBTENER CONSTANTES: $e");
    isUpdated = true;

    Auth().getCurrentUser().then((firebaseUser) {
      if (firebaseUser != null) {
        Firestore.instance
            .document("users/${firebaseUser?.uid}")
            .get()
            .then((userDoc) {
          user.id = userDoc.documentID;
          user.name = userDoc.data["name"];
          user.hasReviewedBuyers = userDoc.data['hasReviewedBuyers'];
          user.email = userDoc.data['email'];
          user.numEnvios = userDoc.data['numEnvios'];
          user.favoriteCreditCard = userDoc.data['favoriteCreditCard'];
          user.isAdmin = userDoc.data["roles"]["isAdmin"];
          user.numTarjetas = userDoc.data['numTarjetas'];
          user.numLugares = userDoc.data['numDirecciones'];
          user.payCount = userDoc.data['payCount'];
          user.phoneNumber = userDoc.data['phoneNumber'];
          user.userTks = userDoc.data['creditCards'];
          user.fotoPerfilURL = userDoc.data['fotoPerfilURL'];

          user.lugares = [];
          List<dynamic> direccionesTemp = userDoc.data["direcciones"];
          if (direccionesTemp != null && direccionesTemp.isNotEmpty) {
            direccionesTemp.forEach((direccion) {
              user.lugares.add(
                Lugar(
                  notas: direccion["notas"],
                  ciudad: direccion["ciudad"],
                  barrio: direccion["barrio"],
                  direccion: direccion["calle"],
                  edificio: direccion["edificio"],
                  contactoName: direccion["contacto"]["name"],
                  contactoPhoneNumber: direccion["contacto"]["phoneNumber"],
                ),
              );
            });
          }

          /// Categorías
          user.categorias = [];
          user.numCategorias = 0;
          List<dynamic> categoriasTemp = userDoc.data["categorias"];
          if (categoriasTemp != null && categoriasTemp.isNotEmpty) {
            categoriasTemp.reversed.toList().forEach((categoria) {
              user.categorias.add(
                Categoria(
                  emoji: categoria["emoji"],
                  title: categoria["title"],
                  numMandados: categoria["numMandados"],
                  isHidden: categoria["isHidden"],
                ),
              );
              if (!categoria["isHidden"]) {
                user.numCategorias++;
              }
            });
            user.categorias.sort((a, b) {
              if (a.isHidden) {
                return 1;
              } else {
                return -1;
              }
            });
          } else {
            print("🍪 NO TENGO GALLETAS");
            Map<String, dynamic> userMap = {
              "categorias": [
                {
                  "emoji": "📦",
                  "title": "Paquetes",
                  "numMandados": 0,
                  "isHidden": false,
                },
                {
                  "emoji": "✉️",
                  "title": "Mensajería",
                  "numMandados": 0,
                  "isHidden": false,
                }
              ],
            };
            print("🍪 ENTREGARÉ GALLETAS");
            Firestore.instance
                .document("users/${user.id}")
                .updateData(userMap)
                .then((r) {
              print("✔️ GALLETAS ENTREGADAS");
              user.categorias.add(
                Categoria(
                  emoji: "📦",
                  title: "Paquetes",
                  numMandados: 0,
                  isHidden: false,
                ),
              );
              user.categorias.add(
                Categoria(
                  emoji: "✉️",
                  title: "Mensajería",
                  numMandados: 0,
                  isHidden: false,
                ),
              );
              user.numCategorias = 2;
            }).catchError((e) {
              print("💩 ERROR AL ENTREGAR GALLETAS: $e");
              user.categorias.add(
                Categoria(
                  emoji: "📦",
                  title: "Paquetes",
                  numMandados: 0,
                  isHidden: false,
                ),
              );
              user.categorias.add(
                Categoria(
                  emoji: "✉️",
                  title: "Mensajería",
                  numMandados: 0,
                  isHidden: false,
                ),
              );
              user.numCategorias = 2;
            });
          }

          print("✔️ USER DESCARGADO");
          runApp(
            ChangeNotifierProvider<InternetStatus>(
              create: (context) => status,
              child: MaterialApp(
                theme: ThemeData(primaryColor: kGreenManda2Color),
                home: Home(),
              ),
            ),
          );
        }).catchError((e) {
          print("💩 ERROR AL OBTENER USUARIO: $e");
        });
      } else {
        if (isFirstTime) {
          runApp(
            ChangeNotifierProvider<InternetStatus>(
              create: (context) => status,
              child: MaterialApp(
                theme: ThemeData(primaryColor: kGreenManda2Color),
                home: Diapositivas(),
              ),
            ),
          );
        } else {
          runApp(
            ChangeNotifierProvider<InternetStatus>(
              create: (context) => status,
              child: MaterialApp(
                theme: ThemeData(primaryColor: kGreenManda2Color),
                home: IniciarSesion(),
              ),
            ),
          );
        }
      }
    });
  });
}
