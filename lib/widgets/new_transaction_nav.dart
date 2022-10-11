import 'package:flutter/material.dart';

import '../pages/new_exchange_page.dart';
import '../pages/new_expense_transaction_page.dart';
import '../pages/new_income_transaction_page.dart';

class NewTransactionNav extends StatelessWidget {
  const NewTransactionNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(NewExpenseTransactionPage.route);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add),
                SizedBox(width: 5),
                Text('Витрата'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(NewIncomeTransactionPage.route);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add),
                SizedBox(width: 5),
                Text('Прибуток'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ExchangePage.route);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add),
                SizedBox(width: 5),
                Text('Обмін між гаманцями'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
