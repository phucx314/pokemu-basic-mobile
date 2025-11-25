import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';
import 'package:pokemu_basic_mobile/viewmodels/shop_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_loading.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_text.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_textfield.dart';
import 'package:provider/provider.dart';

import '../../common/utils/percentage_formatter.dart';
import '../../models/pack.dart';
import '../../routes/named_routes.dart';
import '../components/pokemub_button.dart';
import '../components/shop/shop_pack.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    final shopVm = context.watch<ShopVm>();

    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover,),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 24,),
                const MomoSignatureText(text: 'Shop', color: pokemubTextColor, fontSize: 24, fontWeight: FontWeight.bold,),
                const SizedBox(height: 16,),
                PokemubTextfield(
                  label: '', 
                  hintText: 'Search pack name', 
                  width: MediaQuery.of(context).size.width, 
                  hasActionButton: true, 
                  actionButtonIcon: TablerIcons.search,
                  controller: shopVm.searchController,
                ),
                const SizedBox(height: 16,),
                Expanded(
                  child: shopVm.isLoading
                    ? const Center(child: PokemubLoading(),)
                    : shopVm.errorMessage != null 
                      ? Center(child: ParkinsansText(text: shopVm.errorMessage!, color: pokemubPrimaryColor, fontSize: 16, maxLines: 10,),)
                      : shopVm.filteredPacks.isEmpty 
                        ? const Center(child: ParkinsansText(text: 'No packs found'),)
                        : RefreshIndicator(
                            backgroundColor: pokemubBackgroundColor,
                            color: pokemubPrimaryColor,
                            onRefresh: () async {
                              await context.read<ShopVm>().getAllAvailablePacks();
                            },
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 24,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.43,
                              ), 
                              itemCount: shopVm.filteredPacks.length,
                              itemBuilder: (context, index) {
                                final pack = shopVm.filteredPacks[index];
                            
                                return SizedBox(
                                  height: 12, 
                                  width: 12,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await shopVm.getDropRates(pack.id);

                                          if (context.mounted) {
                                            _showPackInfo(context, pack);
                                          }
                                        },
                                        child: ShopPack(
                                          packId: pack.id,
                                          packImageUrl: pack.packImage,
                                          packName: pack.packName,
                                          stock: pack.globalQuantity ?? 99999999999999, 
                                          price: pack.price,
                                        ),
                                      ),
                                      const SizedBox(height: 16,),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          PokemubButton(
                                            label: '', 
                                            onTap: () async {
                                              await shopVm.getDropRates(pack.id);

                                              if (context.mounted) {
                                                _showPackInfo(context, pack);
                                              }
                                            }, 
                                            height: 36, 
                                            width: 36,
                                            isDisabled: pack.globalQuantity == 0,
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
                ),
              ],
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
        final vm = dialogContext.watch<ShopVm>();

        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
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
                        isDisabled: pack.globalQuantity == 0,
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

