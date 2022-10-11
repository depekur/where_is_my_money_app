import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/show_snack_bar.dart';
import '../helpers/styles_consts.dart';
import '../models/exchange_data.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import '../providers/app_provider.dart';
import '../widgets/wallets_carousel.dart';

class ExchangePage extends StatefulWidget {
  static const route = '/exchange';

  const ExchangePage({Key? key}) : super(key: key);

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  final _form = GlobalKey<FormState>();
  bool _loading = false;
  Transaction _transaction = Transaction.emptyExchange();

  final _amountFromFocusNode = FocusNode();
  final _amountToFocusNode = FocusNode();
  final _commissionFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Обмін між гаманцями'),
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
              _amountFromInput(),
              WalletsCarousel(
                // headerText: 'З якого гаманця була витрата?',
                onSelect: (Wallet wallet) {
                  setState(() {
                    _transaction.additional?.fromWallet = wallet;

                    print(wallet);
                  });
                },
              ),
              const Divider(height: 20),
              _amountToInput(),
              WalletsCarousel(
                // headerText: 'На який гаманець зайшли гроші?',
                onSelect: (Wallet wallet) {
                  setState(() {
                    _transaction.additional?.toWallet = wallet;
                  });
                },
              ),
              const SizedBox(height: 30),
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

  Widget _amountFromInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        enabled: !_loading,
        focusNode: _amountFromFocusNode,
        initialValue: '',
        decoration: InputDecoration(
          labelText: 'Скільки грошей списалось з гаманця?',
          prefix: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
                _transaction.additional?.fromWallet?.currency.symbol ?? ''),
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
          FocusScope.of(context).requestFocus(_amountToFocusNode);
        },
        onSaved: (val) {
          if (val != null && val.isNotEmpty) {
            setState(() {
              _transaction = Transaction(
                id: _transaction.id,
                name: _transaction.name,
                sum: double.parse(val),
                date: _transaction.date,
                type: _transaction.type,
                wallet: Wallet.empty(),
                additional: ExchangeData(
                  fromWallet: _transaction.additional?.fromWallet,
                  toWallet: _transaction.additional?.toWallet,
                  fromSum: double.parse(val),
                  toSum: _transaction.additional?.fromSum ?? 0,
                  commission: 0,
                ),
              );
            });
          }
        },
      ),
    );
  }

  Widget _amountToInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        enabled: !_loading,
        focusNode: _amountToFocusNode,
        initialValue: '',
        decoration: InputDecoration(
          labelText: 'Скільки грошей надійшло на гаманець?',
          prefix: Padding(
            padding: const EdgeInsets.only(right: 10),
            child:
                Text(_transaction.additional?.toWallet?.currency.symbol ?? ''),
          ),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Треба вказати суму';
          }
          return null;
        },
        onSaved: (val) {
          if (val != null && val.isNotEmpty) {
            setState(() {
              _transaction = Transaction(
                id: _transaction.id,
                name: _transaction.name,
                sum: double.parse(val),
                date: _transaction.date,
                type: _transaction.type,
                wallet: Wallet.empty(),
                additional: ExchangeData(
                  fromWallet: _transaction.additional?.fromWallet,
                  toWallet: _transaction.additional?.toWallet,
                  fromSum: _transaction.additional?.fromSum ?? 0,
                  toSum: double.parse(val),
                  commission: 0,
                ),
              );
            });
          }
        },
      ),
    );
  }

  void _save(context) async {
    final isValid = _form.currentState!.validate();

    if (!isValid || _loading) {
      return;
    }

    if (_transaction.additional?.fromWallet?.id == _transaction.additional?.toWallet?.id) {
      SnackBarHelper.show(context, 'Не можна переказати гроші на той самий гаманець');
      return;
    }

    setState(() {
      _loading = true;
    });

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    try {
      await appProvider.exchange(_transaction.exchangeDto);
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_transaction.additional?.fromWallet != null || _transaction.additional?.toWallet != null) {
      final appProvider = Provider.of<AppProvider>(context);

      setState(() {
        _transaction.additional?.fromWallet = appProvider.wallets[0];
        _transaction.additional?.toWallet = appProvider.wallets[0];
      });
    }
  }
}
