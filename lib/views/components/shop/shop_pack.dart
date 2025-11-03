import 'package:flutter/material.dart';

import '../../../common/constants/colors.dart';
import '../../../common/utils/currency_formatter.dart';
import '../pokemub_text.dart';

class ShopPack extends StatelessWidget {
  const ShopPack({super.key, required this.packImageUrl, required this.packName, required this.stock});

  final String packImageUrl;
  final String packName;
  final int stock;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(packImageUrl, fit: BoxFit.fitWidth,),
        const SizedBox(height: 8,),
        ParkinsansText(text: packName, color: pokemubTextColor, fontWeight: FontWeight.bold, fontSize: 16, textOverflow: TextOverflow.ellipsis, maxLines: 1,),
        const SizedBox(height: 4,),
        Container(
          decoration: BoxDecoration(
            color: pokemubTextColor10,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ParkinsansText(text: 'Stock: ${CurrencyFormatter.formatCoin(stock)}', fontWeight: FontWeight.bold, fontSize: 12,),
          ),
        ),
      ],
    );
  }
}