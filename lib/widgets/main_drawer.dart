import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/categories_list_page.dart';
import '../pages/wallets_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  Widget buildLink({
    required String title,
    required IconData icon,
    required Function onTap,
  }) {
    return ListTile(
      onTap: () {
        onTap();
      },
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              AppBar(
                title: const Text('Де мої гроші?'),
                automaticallyImplyLeading: false,
              ),
              const SizedBox(
                height: 30,
              ),
              buildLink(
                  icon: Icons.bar_chart,
                  title: 'Статистика',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const WalletsPage()));
                  }),
              const Divider(),
              buildLink(
                  icon: Icons.wallet,
                  title: 'Гаманці',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const WalletsPage()));
                  }),
              const Divider(),
              buildLink(
                  icon: Icons.category,
                  title: 'Категоріі витрат',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const CategoriesListPage()));
                  }),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }
}
