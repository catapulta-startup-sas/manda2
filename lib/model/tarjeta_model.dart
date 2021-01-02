import 'package:flutter_credit_card/credit_card_widget.dart';

class Tarjeta {
  Tarjeta({
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.type,
    this.isFavorite,
  });

  String cardNumber;
  String expiryDate;
  String cardHolderName;
  CardType type;
  bool isFavorite;
}
