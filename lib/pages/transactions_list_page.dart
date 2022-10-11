import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:where_is_my_money_app/providers/app_provider.dart';

import '../models/transaction_type.dart';
import '../widgets/exchange_transaction_card.dart';
import '../widgets/home_page_block.dart';
import '../widgets/main_drawer.dart';
import '../widgets/new_transaction_nav.dart';
import '../widgets/transaction_card.dart';

class TransactionsListPage extends StatefulWidget {
  const TransactionsListPage({Key? key}) : super(key: key);

  @override
  State<TransactionsListPage> createState() => _TransactionsListPageState();
}

class _TransactionsListPageState extends State<TransactionsListPage> {
  bool _isInit = false;

  void _showNewTransactionNav(ctx) {
    showModalBottomSheet(
        constraints: const BoxConstraints(maxHeight: 200, minHeight: 200),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: const NewTransactionNav(),
          );
        });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isInit = true;
      });

      final appProvider = Provider.of<AppProvider>(context, listen: false);

      appProvider.fetchAndSetWallets();
      appProvider.fetchAndSetCategories();
      appProvider.fetchAndSetTransactions();
      appProvider.fetchAndSetCurrency();
    }

    super.didChangeDependencies();
  }

  Widget _body() {
    return Column(
      children: [
        const HomePageBlock(),
        const Divider(),
        Consumer<AppProvider>(
          builder: (ctx, data, child) {
            return Container(
              // height: (mediaQuery.size.height -
              //         appBar.preferredSize.height -
              //         mediaQuery.padding.top) *
              //     0.8,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: data.transactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (data.transactions[index].type == TransactionType.exchange) {
                        return ExchangeTransactionCard(transaction: data.transactions[index]);
                      } else {
                        return TransactionCard(transaction: data.transactions[index]);
                      }
                    },
                  ),
                ));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final PreferredSizeWidget appBar = AppBar(
      title: const Text('Де мої гроші?'),
      actions: [
        IconButton(
          onPressed: () {
            _showNewTransactionNav(context);
          },
          icon: const Icon(Icons.add),
        )
      ],
    );

    return Scaffold(
      body: SafeArea(child: _body(),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewTransactionNav(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}