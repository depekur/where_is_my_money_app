import 'package:where_is_my_money_app/models/wallet.dart';

class ExchangeData {
  Wallet? fromWallet;
  final double fromSum;
  final double commission;
  Wallet? toWallet;
  final double toSum;

  ExchangeData({
    this.fromWallet,
    required this.fromSum,
    required this.commission,
    this.toWallet,
    required this.toSum,
  });

  static ExchangeData empty() {
    return ExchangeData(
      fromWallet: null,
      toWallet: null,
      fromSum: 0,
      toSum: 0,
      commission: 0,
    );
  }
}
