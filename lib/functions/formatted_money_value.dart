String formattedMoneyValue(int value, {bool showsCurrency = true}) {
  String valorString = "$value";

  int puntos = (valorString.length / 3).floor();
  int sobran;
  if (valorString.length % 3 == 0) {
    sobran = 3;
  } else {
    sobran = ((valorString.length / 3 - puntos) * 3).round();
  }

  if (sobran == 0) {
    return "\$$valorString${showsCurrency ? " COP" : ""}";
  } else {
    String sobraString = valorString.substring(0, sobran);
    String paraPuntos = valorString.substring(sobran);

    String conPunto = "";

    for (int i = 3; i <= paraPuntos.length; i = i + 3) {
      conPunto = "$conPunto.${paraPuntos.substring(i - 3, i)}";
    }

    return "\$$sobraString$conPunto${showsCurrency ? " COP" : ""}";
  }
}
