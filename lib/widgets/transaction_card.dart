import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.onDelete,
  }) : super(key: key);

  final Transaction transaction;
  final Function onDelete;

  Widget _transactionAmount() {
    return Text(
      '${transaction.sumText} ${transaction.wallet.currency.symbol}',
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: transaction.category?.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '${transaction.category?.name}',
          style: const TextStyle(
            fontSize: 14,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(transaction.id),
      confirmDismiss: (_) {
        return showDialog(
          barrierLabel: 'barrierLabel',
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title:
                  const Text('Для видалення транзакції потрібне підтверждення'),
              content: const Text(
                  'Видалити цю транзакцію? Баланс також буде змінено'),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Ні')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Видалити')),
              ],
            );
          },
        );
      },
      background: Container(
        color: Colors.red.shade400,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
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
                  if (transaction.category != null) _categoryText(),
                  if (transaction.name.isNotEmpty &&
                      transaction.category != null)
                    const Divider(),
                  if (transaction.name.isNotEmpty) _transactionName(),
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
      ),
    );
  }
}
