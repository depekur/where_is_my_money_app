import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:where_is_my_money_app/pages/categories_list_page.dart';
import 'package:where_is_my_money_app/pages/new_exchange_page.dart';
import 'package:where_is_my_money_app/pages/new_expense_transaction_page.dart';
import 'package:where_is_my_money_app/pages/new_income_transaction_page.dart';
import 'package:where_is_my_money_app/pages/new_wallet_page.dart';
import 'package:where_is_my_money_app/pages/statistics_page.dart';
import 'package:where_is_my_money_app/pages/transactions_list_page.dart';
import 'package:where_is_my_money_app/pages/wallets_page.dart';
import 'package:where_is_my_money_app/providers/app_provider.dart';
import 'package:where_is_my_money_app/providers/auth_provider.dart';
import 'package:where_is_my_money_app/widgets/loading.dart';

void main() async {
  await dotenv.load(fileName: "environments/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => AppProvider()),
        ],
        builder: (ctx, _) {
          return MaterialApp(
            title: 'Where Is My Money?',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: FutureBuilder(
              future: Provider.of<AuthProvider>(ctx, listen: false).signIn(),
              builder: (ctx, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingScreen();
                } else {
                  return const TransactionsListPage();
                }
              },
            ),
            routes: {
              WalletsPage.route: (ctx) => const WalletsPage(),
              NewWalletPage.route: (ctx) => const NewWalletPage(),
              StatisticsPage.route: (ctx) => const StatisticsPage(),
              NewExpenseTransactionPage.route: (ctx) => const NewExpenseTransactionPage(),
              NewIncomeTransactionPage.route: (ctx) => const NewIncomeTransactionPage(),
              ExchangePage.route: (ctx) => const ExchangePage(),
              CategoriesListPage.route: (ctx) => const CategoriesListPage(),
            },
          );
        },
    );
  }
}
