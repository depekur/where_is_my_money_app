import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/categories_list_page.dart';
import '../pages/wallets_page.dart';
import '../providers/app_provider.dart';

class HomePageBlock extends StatefulWidget {
  const HomePageBlock({Key? key}) : super(key: key);

  @override
  State<HomePageBlock> createState() => _HomePageBlockState();
}

class _HomePageBlockState extends State<HomePageBlock> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.fetchAndSetTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Загальний баланс: ',  style: TextStyle(fontSize: 16)),
                Consumer<AppProvider>(
                  builder: (ctx, data, _) {
                    return Text('~ ${data.total} EUR', style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.indigo.shade400
                    ));
                  },
                )
              ],
            ) ,
          ),
        ),
        // const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(onPressed: () {}, child: Row(
              children: const [
                Icon(Icons.bar_chart),
                SizedBox(width: 5),
                Text('Статистика'),
              ],
            ),),
            OutlinedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const WalletsPage()));
            }, child: Row(
              children: const [
                Icon(Icons.wallet),
                SizedBox(width: 5),
                Text('Гаманці'),
              ],
            ),),
            OutlinedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const CategoriesListPage()));
            }, child: Row(
              children: const [
                Icon(Icons.category),
                SizedBox(width: 5),
                Text('Категорії'),
              ],
            ),),
          ],
        ),
      ],
    );
  }
}
