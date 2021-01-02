import 'dart:io' show Platform;

enum Dispositivo {
  ios,
  android,
  otro,
}

Dispositivo dispositivo;

void getDispositivoType() {
  if (Platform.isIOS) {
    dispositivo = Dispositivo.ios;
  } else if (Platform.isAndroid) {
    dispositivo = Dispositivo.android;
  } else {
    dispositivo = Dispositivo.otro;
  }
}
