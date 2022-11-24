import 'package:flutter/material.dart';

class ExpenseCategoryCard extends StatelessWidget {
  const ExpenseCategoryCard({Key? key, this.data}) : super(key: key);

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 60,
                  decoration: BoxDecoration(
                      color: data['categoryColor'] != null
                          ? Color(data['categoryColor'])
                          : Colors.lightGreen),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Text('${data['categoryName']}'),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 5),
                Text('${data['totalEuro']} EUR'),
                const Divider(height: 10),
                Text('${data['totalPercent']} %'),
                const SizedBox(height: 5),
              ],
            )
          ],
        ),
      ),
    );
  }
}
