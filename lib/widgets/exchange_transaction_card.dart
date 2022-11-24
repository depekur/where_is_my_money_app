import 'package:flutter/material.dart';

import '../models/transaction.dart';

class ExchangeTransactionCard extends StatelessWidget {
  const ExchangeTransactionCard({
    Key? key,
    required this.transaction,
    required this.onDelete,
  }) : super(key: key);

  final Transaction transaction;
  final Function onDelete;

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
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                    if (transaction.additional?.fromWallet?.name != null)
                      _walletData(transaction.additional?.fromWallet?.name ?? '',
                          MainAxisAlignment.start),
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
                    if (transaction.additional?.toWallet?.name != null)
                      _walletData(transaction.additional?.toWallet?.name ?? '',
                          MainAxisAlignment.end),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
