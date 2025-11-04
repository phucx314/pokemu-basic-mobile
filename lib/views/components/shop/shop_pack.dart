import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constants/colors.dart';
import '../../../common/utils/currency_formatter.dart';
import '../../../routes/named_routes.dart';
import '../pokemub_button.dart';
import '../pokemub_text.dart';

class ShopPack extends StatelessWidget {
  const ShopPack({super.key, required this.packImageUrl, required this.packName, required this.stock, required this.price, this.onTap, required this.packId, this.isLoading});

  final int packId;
  final String packImageUrl;
  final String packName;
  final int price;
  final int stock;
  final Function? onTap;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading == true
          ? Image.asset('assets/images/loading_pack.png', fit: BoxFit.fitWidth,)
          : Image.network(packImageUrl, fit: BoxFit.fitWidth,),
        const SizedBox(height: 8,),
        ParkinsansText(text: packName, color: pokemubTextColor, fontWeight: FontWeight.bold, fontSize: 16, textOverflow: TextOverflow.ellipsis, maxLines: 1,),
        const SizedBox(height: 4,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: pokemubTextColor10,
              ),
              child: Row(
                children: [
                  ParkinsansText(text: CurrencyFormatter.formatCoin(price), fontSize: 12,),
                  const SizedBox(width: 4,),
                  Image.asset('assets/images/coin.png', height: 16,),
                ],
              ),
            ),
            const SizedBox(width: 4,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: pokemubTextColor10,
              ),
              child: Row(
                children: [
                  ParkinsansText(text: '${CurrencyFormatter.formatCoin(stock)} left', fontSize: 12,),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16,),
        PokemubButton(label: 'Open', onTap: () {context.go('${NamedRoutes.packOpen}/$packId');}, height: 36,),
      ],
    );
  }
}