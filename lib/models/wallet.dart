import 'package:flutter/material.dart';
import 'package:where_is_my_money_app/models/wallet_type.dart';

import 'currency.dart';

class Wallet {
  final String id;
  final String name;
  double balance;
  Currency currency;
  final String type;

  Wallet({
    required this.id,
    required this.name,
    required this.currency,
    required this.type,
    required this.balance,
  });

  get uaType {
    return type == WalletType.card ? 'карта' : 'кєш';
  }

  IconData get icon {
    return type == WalletType.card ? Icons.credit_card_outlined : Icons.money_outlined;
  }

  Map<String, dynamic> get newWalletDto {
    return {
      'name': name,
      'currency': currency.dto,
      'type': type,
      'balance': balance,
    };
  }

  Map<String, dynamic> get updateWalletDto {
    return {
      'id': id,
      'name': name,
      'currency': currency.dto,
      'type': type,
      'balance': balance,
    };
  }

  static Wallet fromResponse(w) {
    return Wallet(
      id: w['_id'],
      name: w['name'],
      balance: w['balance'] != null ? w['balance'].toDouble() : 0,
      type: w['type'],
      currency: Currency.fromResponse(w['currency'])
    );
  }

  static Wallet empty() {
    return Wallet(
        id: '',
        name: '',
        balance: 0,
        type: WalletType.card,
        currency: Currency.empty()
    );
  }
}
