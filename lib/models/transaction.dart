import 'package:flutter/material.dart';
import 'package:where_is_my_money_app/models/transaction_type.dart';

import 'category.dart';
import 'wallet.dart';
import 'exchange_data.dart';

class Transaction {
  final String id;
  final String name;
  final double sum;
  final String date;
  final String type;
  Wallet wallet;
  Category? category;
  ExchangeData? additional;

  String get sumText {
    final s = sum.toStringAsFixed(2).toString();

    if (type == TransactionType.expense) {
      return '- $s';
    } else if (type == TransactionType.income) {
      return '+ $s';
    } else {
      return '';
    }
  }

  Color get color {
    return type == TransactionType.expense
        ? Colors.deepOrange.shade300
        : Colors.green.shade300;
  }

  Map<String, dynamic> get expenseDto {
    return {
      'name': name,
      'sum': sum,
      'date': date,
      'category': category!.id,
      'wallet': wallet.id,
      'type': TransactionType.expense
    };
  }

  Map<String, dynamic> get incomeDto {
    return {
      'name': name,
      'sum': sum,
      'date': date,
      'wallet': wallet.id,
      'type': TransactionType.income
    };
  }

  Map<String, dynamic> get exchangeDto {
    return {
      'name': name,
      'sum': sum,
      'date': date,
      'wallet': wallet.id,
      'type': TransactionType.exchange,
      'additional': {
        'fromWalletId': additional?.fromWallet?.id,
        'fromSum': additional?.fromSum,
        'commission': 0,
        'toWalletId': additional?.toWallet?.id,
        'toSum': additional?.toSum
      }
    };
  }

  Transaction({
    required this.id,
    required this.name,
    required this.sum,
    required this.date,
    required this.type,
    required this.wallet,
    this.category,
    this.additional,
  });

  static Transaction emptyExchange() {
    return Transaction(
      id: '',
      name: '',
      sum: 0,
      date: DateTime.now().toIso8601String(),
      type: TransactionType.expense,
      wallet: Wallet.empty(),
      category: null,
      additional: ExchangeData.empty()
    );
  }

  static Transaction emptyExpense() {
    return Transaction(
      id: '',
      name: '',
      sum: 0,
      date: DateTime.now().toIso8601String(),
      type: TransactionType.expense,
      wallet: Wallet.empty(),
      category: null,
    );
  }

  static Transaction emptyIncome() {
    return Transaction(
      id: '',
      name: '',
      sum: 0,
      date: DateTime.now().toIso8601String(),
      type: TransactionType.income,
      wallet: Wallet.empty(),
      category: null,
    );
  }

  static Transaction fromResponse(dynamic t) {
    Transaction transaction = Transaction(
      id: t['_id'],
      name: t['name'],
      sum: t['sum'] != null ? t['sum'].toDouble() : 0,
      date: t['date'],
      type: t['type'],
      wallet: t['wallet'] != null ? Wallet.fromResponse(t['wallet']) : Wallet.empty(),
      category:
          t['category'] != null ? Category.fromResponse(t['category']) : null,
    );

    if (t['additional'] != null) {
      transaction.additional = ExchangeData(
        fromWallet: Wallet.fromResponse(t['additional']['fromWallet']),
        fromSum: t['additional']['fromSum'].toDouble(),
        commission: t['additional']['commission'].toDouble(),
        toWallet: Wallet.fromResponse(t['additional']['toWallet']),
        toSum: t['additional']['toSum'].toDouble(),
      );
    }

    return transaction;
  }
}
