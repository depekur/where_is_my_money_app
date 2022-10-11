import 'package:flutter/material.dart';

import '../models/wallet.dart';

class WalletItem extends StatelessWidget {
  final Wallet wallet;
  final Function? onEdit;
  final bool small;

  const WalletItem({
    Key? key,
    required this.wallet,
    this.onEdit,
    this.small = false,
  }) : super(key: key);

  Widget _balance() {
    return Text(
      '${wallet.balance} ${wallet.currency.code}',
      style: TextStyle(
        fontSize: small ? 16 : 19,
        fontWeight: FontWeight.w600,
        color: Colors.green.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wallet,
                        color: Colors.indigoAccent.shade200,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        wallet.name,
                        style: TextStyle(
                          fontSize: small ? 14 : 16,
                          color: Colors.indigoAccent.shade200,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: small ? 14 : 20),
                  Row(
                    children: [
                      Text(
                        wallet.currency.symbol,
                        style: TextStyle(
                          fontSize: small ? 14 : 18 ,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        wallet.uaType,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    IconButton(
                      constraints: const BoxConstraints(
                        maxHeight: 30,
                        maxWidth: 30,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      iconSize: small ? 14 : 20,
                      onPressed: () {
                        if (onEdit != null) {
                          onEdit!(wallet);
                        }
                      },
                      icon: const Icon(Icons.settings),
                    ),
                  if (onEdit != null) const SizedBox(height: 20),
                  _balance(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
