class Transaccion {
  Transaccion({
    this.id,
    this.userId,
    this.valor,
    this.transaccionType,
    this.created,
  });

  String id;
  String userId;
  int valor;
  TransaccionType transaccionType;
  DateTime created;
}

enum TransaccionType {
  efectivo,
  tarjeta,
  paquetes,
}
