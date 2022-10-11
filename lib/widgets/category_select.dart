import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/styles_consts.dart';
import '../models/category.dart';
import '../providers/app_provider.dart';

class CategorySelect extends StatefulWidget {
  const CategorySelect({
    Key? key,
    required this.onSelect,
    required this.disabled,
  }) : super(key: key);

  final Function onSelect;
  final bool disabled;

  @override
  State<CategorySelect> createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelect> {
  Category? _selected = null;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Категорія витрати:'),
            const SizedBox(
              height: 10,
            ),
            Consumer<AppProvider>(builder: (ctx, data, child) {
              return Wrap(
                spacing: 10,
                runSpacing: 1,
                children: data.categories.map((c) {
                  return ChoiceChip(
                    label: Text(c.name),
                    selected: _selected != null ? _selected!.id == c.id : false,
                    onSelected: (bool selected) {
                      if (widget.disabled) {
                        return;
                      }
                      widget.onSelect(c);

                      setState(() {
                        _selected = c;
                      });
                    },
                  );
                }).toList(),
              );
            }),
            const Divider(),
          ],
        ));
  }
}
