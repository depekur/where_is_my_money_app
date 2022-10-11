import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({Key? key, required this.transaction})
      : super(key: key);

  final Transaction transaction;

  Widget _transactionAmount() {
    return Text(
      '${transaction.sumText} ${transaction.wallet.currency.code}',
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w400, color: transaction.color),
    );
  }

  Widget _walletData() {
    return Row(
      children: [
        const Icon(
          Icons.wallet,
          size: 15,
        ),
        const SizedBox(width: 5),
        Text(
          transaction.wallet.name,
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }

  Widget _transactionName() {
    return SizedBox(
      width: 150,
      child: Text(
        transaction.name,
        style: const TextStyle(fontSize: 15, color: Colors.black54),
      ),
    );
  }

  Widget _categoryText() {
    return Text(
      '${transaction.category?.name}',
      style: const TextStyle(
        fontSize: 14,
      ),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (transaction.name.isNotEmpty) _transactionName(),
                if (transaction.name.isNotEmpty && transaction.category != null)
                  const Divider(),
                if (transaction.category != null) _categoryText(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _transactionAmount(),
                const SizedBox(height: 5),
                _walletData(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
