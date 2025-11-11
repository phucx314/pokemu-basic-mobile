import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/common/utils/percentage_formatter.dart';
import 'package:pokemu_basic_mobile/routes/named_routes.dart';
import 'package:pokemu_basic_mobile/viewmodels/home_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_loading.dart';
import 'package:provider/provider.dart';

import '../../common/constants/colors.dart';
import '../../common/utils/cache_manager_config.dart';
import '../../common/utils/currency_formatter.dart';
import '../../models/pack.dart';
import '../components/home/floating_pack.dart';
import '../components/pokemub_button.dart';
import '../components/pokemub_text.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVm = context.watch<HomeVm>();

    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover,),
          
          RefreshIndicator(
            backgroundColor: pokemubBackgroundColor,
            color: pokemubPrimaryColor,
            onRefresh: () async {
              await context.read<HomeVm>().getFeaturedPacks();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24,),
                  const MomoSignatureText(text: 'Featured packs', fontSize: 24, color: pokemubTextColor, fontWeight: FontWeight.bold,),
                  const SizedBox(height: 24,),
                  homeVm.isLoading 
                    ? const SizedBox(height: 400, child: Center(child: PokemubLoading(),),)
                    : homeVm.errorMessage != null 
                      ? Center(child: ParkinsansText(text: homeVm.errorMessage!, color: pokemubPrimaryColor, fontSize: 16, maxLines: 10,),)
                      : homeVm.featuredPacks.isEmpty 
                        ? const Center(child: ParkinsansText(text: 'No featured packs to be shown'),)
                        : SizedBox(
                            height: 540,
                              child: PageView.builder(
                                allowImplicitScrolling: true, // pre-load side-by-side pages (item) -> avoid animation inconsistency due to lazy loading
                                controller: PageController(viewportFraction: 0.7, initialPage: 1), // takes 70% width, the 2nd item will be centralized
                                clipBehavior: Clip.none,
                                scrollDirection: Axis.horizontal,
                                itemCount: homeVm.featuredPacks.length,
                                itemBuilder: (context, index) {
                                  final pack = homeVm.featuredPacks[index];
                                  
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await homeVm.getDropRates(pack.id);

                                            if (context.mounted) {
                                              _showPackInfo(context, pack);
                                            }
                                          },
                                          child: FloatingPack(
                                            id: pack.id,
                                            isSoldOut: (pack.globalQuantity.toString() == '0') ? true : false,
                                            child: CachedNetworkImage(
                                              imageUrl: pack.packImage,
                                              height: 400,
                                              fit: BoxFit.fitHeight,
                                              cacheManager: cacheManagerConfig,
                                              placeholder: (context, url) => const Center(child: PokemubLoading()),
                                              errorWidget: (context, url, error) => const Icon(TablerIcons.error_404),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24,),
                                        ParkinsansText(text: pack.packName, fontWeight: FontWeight.bold,),
                                        const SizedBox(height: 16,),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: pokemubTextColor10,
                                              ),
                                              child: Row(
                                                children: [
                                                  ParkinsansText(text: CurrencyFormatter.formatCoin(pack.price), fontSize: 12,),
                                                  const SizedBox(width: 4,),
                                                  Image.asset('assets/images/coin.png', height: 16,),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 4,),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                              decoration: BoxDecoration(                                        
                                                color: pack.globalQuantity.toString() != '0' ? pokemubTextColor10 : pokemubPrimaryColor.withOpacity(0.5),
                                              ),
                                              child: Row(
                                                children: [
                                                  pack.globalQuantity == null 
                                                    ? const ParkinsansText(text: 'Unlimited', fontSize: 12,)
                                                    : pack.globalQuantity == 0 
                                                      ? const ParkinsansText(text: 'Sold out', fontSize: 12, color: pokemubBackgroundColor,)
                                                      : ParkinsansText(text: '${CurrencyFormatter.formatCoin(pack.globalQuantity!)} left', fontSize: 12,),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16,),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            PokemubButton(
                                              label: '', 
                                              onTap: () async {
                                                await homeVm.getDropRates(pack.id);

                                                if (context.mounted) {
                                                  _showPackInfo(context, pack);
                                                }
                                              }, 
                                              height: 36, 
                                              width: 36,
                                              hasIcon: true,
                                              icon: TablerIcons.info_circle,
                                              fillColor: pokemubBackgroundColor,
                                              hasBorder: true,
                                            ),
                                            const SizedBox(width: 10),
                                            PokemubButton(
                                              label: 'Open', 
                                              onTap: () {
                                                context.go(
                                                  '${NamedRoutes.packOpen}/${pack.id}', 
                                                  extra: pack.packName,
                                                );
                                              }, 
                                              height: 36, 
                                              width: 120,
                                              isDisabled: pack.globalQuantity == 0,
                                            ),
                                          ]
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                  const SizedBox(height: 24,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: pokemubTextColor10, thickness: 2,),
                  ),
                  const SizedBox(height: 24,),
                  const MomoSignatureText(text: 'Your featured cards', fontSize: 24, color: pokemubTextColor, fontWeight: FontWeight.bold,),
                  const SizedBox(height: 16,),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      clipBehavior: Clip.none,
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Image.network('https://pub-b4691ef8f7464ccbb84fb1e456fb214a.r2.dev/cards/A4a-105.webp', height: 200, fit: BoxFit.fitHeight,),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24,),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: Divider(color: pokemubTextColor10, thickness: 2,),
                  // ),
                  // const SizedBox(height: 24,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showPackInfo(BuildContext context, Pack pack) {
    showDialog(
      context: context,
      barrierColor: pokemubBackgroundColor.withOpacity(0.9),
      builder: (dialogContext) {
        final vm = dialogContext.watch<HomeVm>();

        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 300,
            width: 0.75 * MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: pokemubBackgroundColor,
              border: Border.all(width: 2, color: pokemubTextColor,),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MomoSignatureText(text: 'Pack rarity rates', fontWeight: FontWeight.bold,),
                const SizedBox(height: 16,),
                Expanded(
                  child: vm.isDropRatesLoading
                    ? const Center(child: PokemubLoading())
                    : vm.drErrorMessage != null
                        ? Center(child: ParkinsansText(text: vm.drErrorMessage!))
                        : ListView.builder(
                            itemCount: vm.dropRates.length,
                            itemBuilder: (context, index) {
                              final dropRate = vm.dropRates[index];

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ParkinsansText(text: dropRate.rarityName),
                                  ParkinsansText(text: PercentageFormatter.formatPercentage(dropRate.dropRate)),
                                ],
                              );
                            },
                          ),
                ),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                      child: PokemubButton(
                        label: 'Back', 
                        labelColor: pokemubTextColor,
                        onTap: () {
                          Navigator.pop(context);
                        }, 
                        height: 36,
                        fillColor: pokemubBackgroundColor,
                        hasBorder: true,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: PokemubButton(
                        label: 'Open', 
                        onTap: () {
                          context.go(
                            '${NamedRoutes.packOpen}/${pack.id}', 
                            extra: pack.packName,
                          );
                        }, 
                        height: 36,
                        isDisabled: pack.globalQuantity == 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}