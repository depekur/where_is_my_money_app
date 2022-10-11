import 'package:flutter/material.dart';

import '../models/transaction.dart';

class ExchangeTransactionCard extends StatelessWidget {
  const ExchangeTransactionCard({Key? key, required this.transaction})
      : super(key: key);

  final Transaction transaction;

  Widget _transactionAmount(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        color: color,
      ),
    );
  }

  Widget _walletData(String name, MainAxisAlignment align) {
    return Row(
      mainAxisAlignment: align,
      children: [
        const Icon(
          Icons.wallet,
          size: 15,
        ),
        const SizedBox(width: 5),
        Text(
          name,
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _transactionAmount(
                    '- ${transaction.additional?.fromSum} ${transaction.additional?.fromWallet?.currency.code}',
                    Colors.deepOrange.shade300,
                  ),
                  const SizedBox(height: 5),
                  if (transaction.additional?.fromWallet?.name != null) _walletData(transaction.additional?.fromWallet?.name ?? '', MainAxisAlignment.start),
                ],
              ),
            ),
            const Icon(Icons.currency_exchange),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _transactionAmount(
                    '+ ${transaction.additional?.toSum} ${transaction.additional?.toWallet?.currency.code}',
                    Colors.green.shade300,
                  ),
                  const SizedBox(height: 5),
                  if (transaction.additional?.toWallet?.name != null) _walletData(transaction.additional?.toWallet?.name ?? '', MainAxisAlignment.end),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
