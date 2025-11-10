import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constants/colors.dart';
import '../../../common/utils/cache_manager_config.dart';
import '../../../common/utils/currency_formatter.dart';
import '../../../routes/named_routes.dart';
import '../pokemub_button.dart';
import '../pokemub_loading.dart';
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
    final cache = cacheManagerConfig; // singleton instance

    Future<void> debugCache(String url) async {
      final fileInfo = await cache.getFileFromCache(url);
      if (fileInfo != null) {
        debugPrint('✅ Disk cache exists for: $url -> ${fileInfo.file.path}');
      } else {
        debugPrint('❌ No disk cache for: $url');
      }
    }

    return Column(
      children: [
        isLoading == true
          ? Image.asset('assets/images/loading_pack.png', fit: BoxFit.fitWidth,)
          : CachedNetworkImage(
            imageUrl: packImageUrl, 
            fit: BoxFit.fitWidth, 
            cacheManager: cacheManagerConfig,
            placeholder: (context, url) => const Center(
              child: PokemubLoading(),
            ),
            errorWidget: (context, url, error) => const Icon(TablerIcons.error_404),
          ),
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
        PokemubButton(label: 'Open', onTap: () {context.go('${NamedRoutes.packOpen}/$packId', extra: packName);}, height: 36,),
        // const Divider(),
      ],
    );
  }
}