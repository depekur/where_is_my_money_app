import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:where_is_my_money_app/providers/app_provider.dart';
import '../helpers/show_snack_bar.dart';
import '../helpers/styles_consts.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import '../widgets/category_select.dart';
import '../widgets/wallets_carousel.dart';

class NewExpenseTransactionPage extends StatefulWidget {
  static const route = '/new-expense';

  const NewExpenseTransactionPage({Key? key}) : super(key: key);

  @override
  State<NewExpenseTransactionPage> createState() =>
      _NewExpenseTransactionPageState();
}

class _NewExpenseTransactionPageState extends State<NewExpenseTransactionPage> {
  final _form = GlobalKey<FormState>();
  bool _loading = false;
  Transaction _transaction = Transaction.emptyExpense();
  final _nameFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  int nameLength = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_transaction.wallet.id != null) {
      final appProvider = Provider.of<AppProvider>(context);

      setState(() {
        _transaction.wallet = appProvider.wallets[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Додати Витрату'),
        actions: [
          IconButton(
            onPressed: _loading
                ? null
                : () {
                    _save(context);
                  },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          onChanged: () {
            Form.of(primaryFocus!.context!)!.save();
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              WalletsCarousel(
                headerText: 'З якого гаманця була витрата?',
                onSelect: (Wallet wallet) {
                  setState(() {
                    _transaction.wallet = wallet;
                  });
                },
              ),
              ..._inputs(),
              const Divider(height: 40),
              CategorySelect(
                disabled: _loading,
                onSelect: (Category category) {
                  setState(() {
                    _transaction.category = category;
                  });
                },
              ),
              const SizedBox(height: 30),
              // const Divider(height: 30),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () {
                        _save(context);
                      },
                child: const Text('Створити витрату'),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _inputs() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: TextFormField(
          enabled: !_loading,
          focusNode: _amountFocusNode,
          initialValue: '',
          decoration: InputDecoration(
            labelText: 'Скільки грошей витрачено?',
            prefix: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(_transaction.wallet.currency.symbol),
            ),
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Треба вказати суму';
            }
            return null;
          },
          onFieldSubmitted: (val) {
            FocusScope.of(context).requestFocus(_nameFocusNode);
          },
          onSaved: (val) {
            if (val != null && val.isNotEmpty) {

              print('name TextFormField $val');

              setState(() {
                _transaction = Transaction(
                  id: _transaction.id,
                  name: _transaction.name,
                  sum: double.parse(val),
                  date: _transaction.date,
                  type: _transaction.type,
                  wallet: _transaction.wallet,
                );
              });
            }
          },
        ),
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: TextFormField(
          maxLength: 100,
          enabled: !_loading,
          focusNode: _nameFocusNode,
          initialValue: _transaction.name,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Треба вказати на що пішли гроші';
            } else if (val.length >= 100) {
              return 'Треба трохи коротше';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Шо це за витрата?',
            helperText: 'Наприклад: фрукти з ринку; податки; донат ЗСУ',
            counterText: '$nameLength/100',
          ),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (val) {
            // FocusScope.of(context).requestFocus(_amountFocusNode);
          },
          onChanged: (val) {
            print('amount TextFormField $val');

            setState(() {
              nameLength = val.length;
            });
          },
          onSaved: (val) {
            if (val != null && val.isNotEmpty) {
              setState(() {
                _transaction = Transaction(
                  id: _transaction.id,
                  name: val,
                  sum: _transaction.sum,
                  date: _transaction.date,
                  type: _transaction.type,
                  wallet: _transaction.wallet,
                );
              });
            }
          },
        ),
      ),
    ];
  }

  void _save(context) async {
    final isValid = _form.currentState!.validate();

    if (!isValid || _loading) {
      return;
    }

    if (_transaction.category == null) {
      SnackBarHelper.show(context, 'Треба вибрати категорію');
      return;
    }

    print(_transaction.expenseDto);

    // return;

    setState(() {
      _loading = true;
    });

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    try {
      await appProvider.addTransaction(_transaction.expenseDto);
      SnackBarHelper.show(context, 'Транзакція створена!');
      Navigator.of(context).pop();
    } catch (err) {
      SnackBarHelper.show(context, 'Дідько! Шось трапилось. Спробуй ще раз');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
