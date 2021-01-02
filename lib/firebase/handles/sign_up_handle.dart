import 'package:flutter/cupertino.dart';
import 'package:manda2/functions/m2_alert.dart';

enum SignUpError {
  ERROR_INVALID_EMAIL,
  ERROR_WEAK_PASSWORD,
  ERROR_EMAIL_ALREADY_IN_USE,
  ERROR_INVALID_CREDENTIAL,
  ERROR_OPERATION_NOT_ALLOWED,
}

SignUpError signUpErrorFromString(String errorCode) {
  if (errorCode == "ERROR_INVALID_EMAIL") {
    return SignUpError.ERROR_INVALID_EMAIL;
  } else if (errorCode == "ERROR_WEAK_PASSWORD") {
    return SignUpError.ERROR_WEAK_PASSWORD;
  } else if (errorCode == "ERROR_EMAIL_ALREADY_IN_USE") {
    return SignUpError.ERROR_EMAIL_ALREADY_IN_USE;
  } else if (errorCode == "ERROR_INVALID_CREDENTIAL") {
    return SignUpError.ERROR_INVALID_CREDENTIAL;
  } else if (errorCode == "ERROR_OPERATION_NOT_ALLOWED") {
    return SignUpError.ERROR_OPERATION_NOT_ALLOWED;
  }
}

void handleSignUpError(BuildContext context, String errorCode) {
  SignUpError authError = signUpErrorFromString(errorCode);
  switch (authError) {
    case SignUpError.ERROR_INVALID_EMAIL:
      showBasicAlert(context, "Por favor, ingresa un email válido.", "");
      break;
    case SignUpError.ERROR_WEAK_PASSWORD:
      showBasicAlert(context, "Contraseña muy débil.",
          "Por favor, elige una contraseña más segura.");
      break;
    case SignUpError.ERROR_EMAIL_ALREADY_IN_USE:
      showBasicAlert(context, "Ya existe un usuario con este email.",
          "Por favor, elige un email distinto.");
      break;
    case SignUpError.ERROR_INVALID_CREDENTIAL:
      showBasicAlert(context, "Por favor, ingresa un email válido.", "");
      break;
    case SignUpError.ERROR_OPERATION_NOT_ALLOWED:
      showBasicAlert(context, "Registros inhabilitados.",
          "Los registros actualmente se encuentran inhabilitados. Por favor, intenta de nuevo más tarde.");
      break;
    default:
      showBasicAlert(context, "Sin conexión a internet.",
          "Por favor, conecta tu dispositivo a internet e intenta de nuevo.");
      break;
  }
}
