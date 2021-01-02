/*
import 'package:backendless_sdk/backendless_sdk.dart';
import 'm2_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int usersWithID = 0;
IDataStore<Map> userTable = Backendless.data.of('Users');

void handleUnexpected(error) {
  var code = error.code.toString();
  switch (code) {
    case "9999":
      break;
  }
}

void handleRegistrationException(BuildContext context, error) async {
  var code = error.code.toString();
  switch (code) {
    case "3033":
      showBasicAlert(context, "Ya existe un usuario con este email",
          "Por favor, elige un email distinto e intenta de nuevo.");
      break;
  }
}

void handleLoginError(email, context, error) {
  print("Estoy en handling login error");

  var code = error.code.toString();
  print('codigo error:' + code );

  switch (code) {
    case "3003":

      DataQueryBuilder query = DataQueryBuilder();
      query.whereClause = "email = '$email'";
      userTable.find(query).then((users) {
        for (Map user in users) {

          usersWithID = usersWithID + 1;
        }

        if (usersWithID == 1) {
          showBasicAlert(
              context, "Contraseña incorrecta", "Por favor, intenta de nuevo.");

          usersWithID = 0;
        } else {
          showBasicAlert(context, "Usuario inexistente",
              "Por favor, regístrate o inicia sesión con un usuario registrado.");

          usersWithID = 0;
        }
      });


      break;
    case "3064":
      DataQueryBuilder query = DataQueryBuilder();
      query.whereClause = "email = '$email'";
      userTable.find(query).then((users) {
        for (Map user in users) {
          usersWithID = usersWithID + 1;
        }
        if (usersWithID == 1) {
          showBasicAlert(
              context, "Contraseña incorrecta", "Por favor, intenta de nuevo.");
          usersWithID = 0;
        } else {
          showBasicAlert(context, "Usuario inexistente",
              "Por favor, regístrate o inicia sesión con un usuario registrado.");
          usersWithID = 0;
        }
      });
      break;
    default:
      print("Este es el error que se está dando: ${error}");
      showBasicAlert(
          context, "Error de envío", "Por favor revisa tu conexión a Internet");
      break;
  }
}


void handleReestablecerCode(context, error) {
  showBasicAlert(context, "Código incorrecto", "Por favor, intenta de nuevo.");
}

void handleReestablecerPass(context, error) {
  showBasicAlert(context, "Hubo un error", "Por favor, intenta más tarde.");
}

void handleReestablecerGuardar(context, error) {
  showBasicAlert(context, "Hubo un error", "Por favor, intenta más tarde.");
}

 */
