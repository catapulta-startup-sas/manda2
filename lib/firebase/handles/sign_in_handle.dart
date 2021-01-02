import 'package:flutter/cupertino.dart';
import 'package:manda2/functions/m2_alert.dart';

enum SignInError {
  ERROR_INVALID_EMAIL,
  ERROR_USER_NOT_FOUND,
  ERROR_WRONG_PASSWORD,
  ERROR_USER_DISABLED,
  ERROR_TOO_MANY_REQUESTS,
  ERROR_OPERATION_NOT_ALLOWED,
}

SignInError signInErrorFromString(String errorCode) {
  if (errorCode == "ERROR_INVALID_EMAIL") {
    return SignInError.ERROR_INVALID_EMAIL;
  } else if (errorCode == "ERROR_USER_NOT_FOUND") {
    return SignInError.ERROR_USER_NOT_FOUND;
  } else if (errorCode == "ERROR_WRONG_PASSWORD") {
    return SignInError.ERROR_WRONG_PASSWORD;
  } else if (errorCode == "ERROR_USER_DISABLED") {
    return SignInError.ERROR_USER_DISABLED;
  } else if (errorCode == "ERROR_TOO_MANY_REQUESTS") {
    return SignInError.ERROR_TOO_MANY_REQUESTS;
  } else if (errorCode == "ERROR_OPERATION_NOT_ALLOWED") {
    return SignInError.ERROR_OPERATION_NOT_ALLOWED;
  }
}

void handleSignInError(BuildContext context, String errorCode) {
  SignInError authError = signInErrorFromString(errorCode);
  switch (authError) {
    case SignInError.ERROR_INVALID_EMAIL:
      showBasicAlert(context, "Por favor, ingresa un email válido.", "");
      break;
    case SignInError.ERROR_USER_NOT_FOUND:
      showBasicAlert(context, "Usuario inexistente.",
          "Por favor, regístrate o inicia sesión con un usuario existente.");
      break;
    case SignInError.ERROR_WRONG_PASSWORD:
      showBasicAlert(context, "Contraseña incorrecta.",
          "Por favor, ingresa la contraseña correcta.");
      break;
    case SignInError.ERROR_USER_DISABLED:
      showBasicAlert(context, "Usuario inhabilitado.",
          "Por favor, inicia sesión con un usuario habilitado.");
      break;
    case SignInError.ERROR_TOO_MANY_REQUESTS:
      showBasicAlert(context, "Demasiados intentos.",
          "Por favor, intenta de nuevo más tarde.");
      break;
    case SignInError.ERROR_OPERATION_NOT_ALLOWED:
      showBasicAlert(context, "Inicios de sesión inhabilitados.",
          "Los inicios de sesión actualmente se encuentran inhabilitados. Por favor, intenta de nuevo más tarde.");
      break;
    default:
      showBasicAlert(context, "Sin conexión a internet.",
          "Por favor, conecta tu dispositivo a internet e intenta de nuevo.");
      break;
  }
}
