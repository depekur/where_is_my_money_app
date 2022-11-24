import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:where_is_my_money_app/models/category.dart';
import 'package:where_is_my_money_app/models/currency.dart';

import '../models/wallet.dart';
import '../models/wallet_type.dart';
import '../providers/app_provider.dart';

class NewWalletPage extends StatefulWidget {
  static const route = '/new-wallet';

  final Wallet? wallet;

  const NewWalletPage({Key? key, this.wallet}) : super(key: key);

  @override
  State<NewWalletPage> createState() => _NewWalletPageState();
}

class _NewWalletPageState extends State<NewWalletPage> {
  final _form = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _balanceFocusNode = FocusNode();

  bool get isEditing {
    return widget.wallet != null && widget.wallet!.id.isNotEmpty;
  }

  var _wallet = Wallet.empty();

  final walletNameMaxLength = 30;
  var walletNameLength = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.wallet != null) {
      _wallet = widget.wallet!;
    }

    setState(() {
      walletNameLength = 0;
    });

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.fetchAndSetCurrency();
  }

  @override
  void dispose() {
    super.dispose();
    _balanceFocusNode.dispose();
    _nameFocusNode.dispose();
    walletNameLength = 0;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.left,
      ),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    ));
  }

  void _save(context) async {
    final isValid = _form.currentState!.validate();

    if (!isValid || _loading) {
      return;
    }

    setState(() {
      _loading = true;
    });

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    if (_wallet.id.isEmpty) {
      try {
        await appProvider.addWallet(_wallet);
        _showSnackBar('Тепер в тебе э новий гаманець');
        Navigator.of(context).pop();
      } catch (err) {
        _showSnackBar('Дідько! Шось трапилось. Спробуй ще раз');
      } finally {
        setState(() {
          _loading = false;
        });
      }
    } else {
      await appProvider.updateWallet(_wallet);

      Navigator.of(context).pop();
      setState(() {
        _loading = false;
      });
      _showSnackBar('Гаманець оновлено');
    }
  }

  Widget _currencySelect() {
    final currency = Provider.of<AppProvider>(context, listen: false).currency;

    return Container(
      height: 50,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: currency.map((c) {
            return Row(children: [
              ChoiceChip(
                selectedColor: Colors.green.shade100,
                elevation: 3,
                avatar: Text(
                  c.symbol,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                label: Text(
                  c.code,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: _wallet.currency.code == c.code,
                onSelected: (bool selected) {
                  if (_loading || isEditing) {
                    return;
                  }

                  setState(() {
                    _wallet = Wallet(
                      id: _wallet.id,
                      name: _wallet.name,
                      balance: _wallet.balance,
                      type: _wallet.type,
                      currency: c,
                    );
                  });
                },
              ),
              const SizedBox(
                width: 15,
              ),
            ]);
          }).toList()),
    );
  }

  List<Widget> _walletTypeSelect() {
    return [
      ChoiceChip(
        selectedColor: Colors.green.shade100,
        elevation: 3,
        avatar: const Icon(Icons.credit_card),
        label: const Text('КАРТА'),
        selected: _wallet.type == WalletType.card,
        onSelected: (bool selected) {
          if (_loading || isEditing) {
            return;
          }

          setState(() {
            _wallet = Wallet(
              id: _wallet.id,
              name: _wallet.name,
              balance: _wallet.balance,
              type: WalletType.card,
              currency: _wallet.currency,
            );
          });
        },
      ),
      const SizedBox(
        width: 15,
      ),
      ChoiceChip(
        selectedColor: Colors.green.shade100,
        elevation: 3,
        avatar: Icon(Icons.attach_money),
        label: const Text('КЄШ'),
        selected: _wallet.type == WalletType.cash,
        onSelected: (bool selected) {
          if (_loading || isEditing) {
            return;
          }

          setState(() {
            _wallet = Wallet(
              id: _wallet.id,
              name: _wallet.name,
              balance: _wallet.balance,
              type: WalletType.cash,
              currency: _wallet.currency,
            );
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редагувати гаманець' : 'Новий гаманець'),
        actions: [
          IconButton(
              onPressed: _loading
                  ? null
                  : () {
                      _save(context);
                    },
              icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          onChanged: () {
            Form.of(primaryFocus!.context!)!.save();
          },
          child: ListView(
            children: [
              TextFormField(
                maxLength: 30,
                enabled: !_loading,
                focusNode: _nameFocusNode,
                initialValue: _wallet.name,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Треба вигадати назву гаманця :(';
                  } else if (val.length >= 30) {
                    return 'Занадто довга назва :(';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Назва гаманця',
                    helperText: 'Зарплатна картка. Заначка. ',
                    counterText: '$walletNameLength/$walletNameMaxLength'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_balanceFocusNode);
                },
                onChanged: (val) {
                  setState(() {
                    walletNameLength = val.length;
                  });
                },
                onSaved: (val) {
                  print('TextFormField Name $val');

                  if (val != null) {
                    _wallet = Wallet(
                      id: _wallet.id,
                      name: val,
                      balance: _wallet.balance,
                      type: _wallet.type,
                      currency: _wallet.currency,
                    );

                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                enabled: !_loading,
                focusNode: _balanceFocusNode,
                initialValue: _wallet.balance.toString(),
                decoration: const InputDecoration(labelText: 'Баланс'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Скільки грошей в цьому гаманці?';
                  }
                  return null;
                },
                onFieldSubmitted: (val) {
                  // FocusScope.of(context).requestFocus(_balanceFocusNode);
                },
                onSaved: (val) {
                  print('TextFormField balance $val');

                  if (val != null) {
                    _wallet = Wallet(
                      id: _wallet.id,
                      name: _wallet.name,
                      balance: double.parse(val),
                      type: _wallet.type,
                      currency: _wallet.currency,
                    );

                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 30),
              const Text('Тип гаманця. Банківьська карта чи кєш?'),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _walletTypeSelect(),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const Text('Валюта гаманця'),
              const SizedBox(height: 10),
              _currencySelect(),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () {
                        _save(context);
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save),
                    const SizedBox(width: 10),
                    Text(isEditing
                        ? 'Редагувати гаманець'
                        : 'Створити гаманець'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
