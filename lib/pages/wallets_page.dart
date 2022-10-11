import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/wallet.dart';
import '../providers/app_provider.dart';
import '../widgets/wallet_item.dart';
import 'new_wallet_page.dart';

class WalletsPage extends StatefulWidget {
  static const route = '/wallets';

  const WalletsPage({Key? key}) : super(key: key);

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isInit = true;
      });

      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.fetchAndSetWallets();
    }

    super.didChangeDependencies();
  }

  void _editWallet(Wallet wallet) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => NewWalletPage(wallet: wallet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Гаманці'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const NewWalletPage()),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (ctx, data, child) {
          return ListView.builder(
            itemCount: data.wallets.length,
            itemBuilder: (BuildContext context, int index) {
              return WalletItem(
                wallet: data.wallets[index],
                onEdit: _editWallet,
              );
            },
          );
        },
      ),
    );
  }
}
