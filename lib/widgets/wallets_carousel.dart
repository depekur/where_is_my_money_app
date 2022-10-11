import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:where_is_my_money_app/widgets/wallet_item.dart';

import '../helpers/styles_consts.dart';
import '../providers/app_provider.dart';

class WalletsCarousel extends StatelessWidget {
  String headerText = '';
  final Function onSelect;
  final CarouselController _carouselController = CarouselController();

  WalletsCarousel({
    Key? key,
    this.headerText = '',
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (headerText.isNotEmpty) Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(headerText),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.grey.shade300),
          child: Consumer<AppProvider>(builder: (ctx, data, child) {
            return CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                onPageChanged: (index, _) {
                  onSelect(data.wallets[index]);
                },
                height: 105.0,
                viewportFraction: 0.85,
              ),
              items: data.wallets.map((wallet) {
                return Builder(
                  builder: (BuildContext context) {
                    return WalletItem(
                      wallet: wallet,
                      small: true,
                    );
                  },
                );
              }).toList(),
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
