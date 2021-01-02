import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';

class InternetStatus extends ChangeNotifier {
  int contador = 0;
  bool connected = true;

  Future<bool> checkCurrentConnection() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 8), () async {
        connected = await checkInternet();
      });
      if (connected) {
        if (contador != 0) {
          isBack();
        }
      } else {
        if (contador == 0) {
          isGone();
        }
      }
    }
  }

  Future<bool> isBack() async {
    connected = true;
    contador = 0;
    notifyListeners();
  }

  Future<bool> isGone() async {
    connected = false;
    contador++;
    notifyListeners();
  }
}

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}
