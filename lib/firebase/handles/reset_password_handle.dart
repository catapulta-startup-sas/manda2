import 'package:flutter/cupertino.dart';
import 'package:manda2/functions/m2_alert.dart';

enum ResetPasswordError {
  ERROR_INVALID_EMAIL,
  ERROR_USER_NOT_FOUND,
  ERROR_TOO_MANY_REQUESTS,
  ERROR_OPERATION_NOT_ALLOWED,
}

ResetPasswordError resetPasswordErrorFromString(String errorCode) {
  if (errorCode == "ERROR_INVALID_EMAIL") {
    return ResetPasswordError.ERROR_INVALID_EMAIL;
  } else if (errorCode == "ERROR_USER_NOT_FOUND") {
    return ResetPasswordError.ERROR_USER_NOT_FOUND;
  } else if (errorCode == "ERROR_TOO_MANY_REQUESTS") {
    return ResetPasswordError.ERROR_TOO_MANY_REQUESTS;
  } else if (errorCode == "ERROR_OPERATION_NOT_ALLOWED") {
    return ResetPasswordError.ERROR_OPERATION_NOT_ALLOWED;
  }
}

void handleResetPasswordError(BuildContext context, String errorCode) {
  ResetPasswordError authError = resetPasswordErrorFromString(errorCode);
  switch (authError) {
    case ResetPasswordError.ERROR_INVALID_EMAIL:
      showBasicAlert(context, "Por favor, ingresa un email válido.", "");
      break;
    case ResetPasswordError.ERROR_USER_NOT_FOUND:
      showBasicAlert(context, "Usuario inexistente.",
          "Por favor, ingresa el email de un usuario existente.");
      break;
    case ResetPasswordError.ERROR_TOO_MANY_REQUESTS:
      showBasicAlert(context, "Demasiados intentos.",
          "Por favor, intenta de nuevo más tarde.");
      break;
    case ResetPasswordError.ERROR_OPERATION_NOT_ALLOWED:
      showBasicAlert(context, "Recuperación de contraseña inhabilitado.",
          "Las recuperaciones de contraseña actualmente se encuentran inhabilitadas. Por favor, intenta de nuevo más tarde.");
      break;
    default:
      showBasicAlert(context, "Sin conexión a internet.",
          "Por favor, conecta tu dispositivo a internet e intenta de nuevo.");
      break;
  }
}
