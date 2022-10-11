import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/app_provider.dart';
import 'new_category_form.dart';
import 'new_wallet_page.dart';

class CategoriesListPage extends StatefulWidget {
  static const route = '/categories-list';

  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isInit = true;
      });

      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.fetchAndSetCategories();
    }

    super.didChangeDependencies();
  }

  void _showNewCategoryForm({required BuildContext ctx, Category? category}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NewCategoryForm(category: category)));
  }

  Widget _categoryItem(Category category) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(category.name),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      _showNewCategoryForm(ctx: context, category: category);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.green.shade200,
                    )),
                // IconButton(
                //     onPressed: () {},
                //     icon: Icon(
                //       Icons.delete,
                //       color: Colors.red.shade200,
                //     )),
              ],
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категорії Витрат'),
        actions: [
          IconButton(
            onPressed: () {
              _showNewCategoryForm(ctx: context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<AppProvider>(
          builder: (ctx, data, child) {
            return ListView.builder(
              itemCount: data.categories.length,
              itemBuilder: (BuildContext context, int index) {
                return _categoryItem(data.categories[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
