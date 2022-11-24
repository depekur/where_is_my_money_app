import 'package:flutter/material.dart';
import 'package:where_is_my_money_app/helpers/http_service.dart';
import 'package:where_is_my_money_app/models/currency.dart';
import 'package:where_is_my_money_app/models/wallet.dart';
import 'package:where_is_my_money_app/models/category.dart';
import 'package:where_is_my_money_app/models/transaction.dart';

import '../helpers/date_filter.dart';
import '../helpers/transactions_page_size.dart';

class AppProvider with ChangeNotifier {
  String _totalEur = '0';
  List<Wallet> _wallets = [];
  List<Category> _categories = [];
  List<Transaction> _transactions = [];
  List<Currency> _currency = [];

  dynamic _statistic;

  dynamic get statistic {
    return _statistic;
  }

  List<Wallet> get wallets {
    return [..._wallets];
  }

  List<Category> get categories {
    return [..._categories];
  }

  List<Transaction> get transactions {
    return [..._transactions];
  }

  List<Currency> get currency {
    return [..._currency];
  }

  String get total {
    return _totalEur;
  }

  Future<dynamic> fetchAndSetStatistics({
    required String filterType,
    required String startDate,
    required String endDate,
  }) async {
    String url = 'transaction/statistic?filterType=${filterType}&startDate=${startDate}&endDate=${endDate}';
    final statistic = await HttpService.get(url);

    if (statistic != null) {
      _statistic = statistic;
      notifyListeners();
    }
  }

  Future<dynamic> fetchAndSetTotal() async {
    final total = await HttpService.get('wallet/total');

    if (total.isNotEmpty && total['totalEur'] != null) {
      _totalEur = double.parse(total['totalEur']).toStringAsFixed(2);
      notifyListeners();
    }
  }

  Future<void> fetchAndSetWallets() async {
    final List<dynamic> wallets = await HttpService.get('wallet');

    if (wallets.isNotEmpty) {
      _wallets = wallets.map((w) => Wallet.fromResponse(w)).toList();
    }

    notifyListeners();
  }

  Future<void> fetchAndSetCategories() async {
    final List<dynamic> categories = await HttpService.get('category');

    if (categories.isNotEmpty) {
      _categories = categories.map((c) => Category.fromResponse(c)).toList();
    }

    notifyListeners();
  }

  Future<void> fetchAndSetTransactions() async {
    final String url =
        'transaction?offset=${_transactions.length}&size=$transactionPageSize';
    final List<dynamic> transactions = await HttpService.get(url);

    if (transactions.isNotEmpty) {
      if (_transactions.isNotEmpty) {
        _transactions = [
          ..._transactions,
          ...transactions.map((t) => Transaction.fromResponse(t)).toList()
        ];
      } else {
        _transactions =
            transactions.map((t) => Transaction.fromResponse(t)).toList();
      }
    }

    notifyListeners();
  }

  Future<void> fetchAndSetCurrency() async {
    final List<dynamic> currency = await HttpService.get('wallet/currency');

    if (currency.isNotEmpty) {
      _currency = currency.map((t) => Currency.fromResponse(t)).toList();
    }

    notifyListeners();
  }

  Future<void> addWallet(Wallet wallet) async {
    final Map<String, dynamic> resData = await HttpService.post(
      'wallet/new',
      wallet.newWalletDto,
    );

    if (resData.isNotEmpty) {
      final wallet = Wallet.fromResponse(resData);
      _wallets.insert(0, wallet);

      await fetchAndSetTotal();

      notifyListeners();
    } else {
      throw Exception('Something goes wrong');
    }
  }

  Future<void> updateWallet(Wallet wallet) async {
    final Map<String, dynamic> resData = await HttpService.post(
      'wallet/update/${wallet.id}',
      wallet.updateWalletDto,
    );

    if (resData.isNotEmpty) {
      final wallet = Wallet.fromResponse(resData);
      final index = _wallets.indexWhere((el) => el.id == wallet.id);

      if (index >= 0) {
        _wallets[index] = wallet;
      } else {
        print('No such wallet');
      }

      await fetchAndSetTotal();

      notifyListeners();
    } else {
      throw Exception('Something goes wrong');
    }
  }

  Future<void> addCategory(Category category) async {
    final Map<String, dynamic> resData = await HttpService.post(
      'category',
      category.createDto,
    );

    if (resData.isNotEmpty) {
      final category = Category.fromResponse(resData);
      _categories.add(category);
      notifyListeners();
    } else {
      throw Exception('Something goes wrong');
    }
  }

  Future<void> updateCategory(Category category) async {
    final Map<String, dynamic> resData = await HttpService.post(
      'category/update/${category.id}',
      category.updateDto,
    );

    if (resData.isNotEmpty) {
      final category = Category.fromResponse(resData);
      final index = _categories.indexWhere((el) => el.id == category.id);

      if (index >= 0) {
        _categories[index] = category;
      } else {
        print('No such category');
      }
      notifyListeners();
    } else {
      throw Exception('Something goes wrong');
    }
  }

  Future<void> addTransaction(Map<String, dynamic> transaction) async {
    final Map<String, dynamic> resData = await HttpService.post(
      'transaction',
      transaction,
    );

    if (resData.isNotEmpty) {
      final transaction = Transaction.fromResponse(resData);
      _transactions.insert(0, transaction);

      await fetchAndSetTotal();
      await fetchAndSetWallets();

      notifyListeners();
    } else {
      throw Exception('Something goes wrong');
    }
  }

  Future<void> exchange(Map<String, dynamic> transaction) async {
    final Map<String, dynamic> resData = await HttpService.post(
      'transaction/exchange',
      transaction,
    );

    if (resData.isNotEmpty) {

      print(resData);

      final transaction = Transaction.fromResponse(resData);

      _transactions.insert(0, transaction);

      await fetchAndSetTotal();
      await fetchAndSetWallets();

      notifyListeners();
    } else {
      throw Exception('Something goes wrong');
    }
  }

  Future<void> deleteTransaction(String id) async {
    final dynamic resData = await HttpService.delete('transaction/$id');

    if (resData.isNotEmpty) {
      _transactions.removeWhere((t) => t.id == id);

      await fetchAndSetTotal();
      await fetchAndSetWallets();

      notifyListeners();
    } else {
      throw Exception('Something goes wrong');
    }
  }
}
