import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';
import 'package:pokemu_basic_mobile/viewmodels/shop_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_loading.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_text.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_textfield.dart';
import 'package:provider/provider.dart';

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
                PokemubTextfield(
                  label: '', 
                  hintText: 'Search pack name', 
                  width: MediaQuery.of(context).size.width, 
                  hasActionButton: true, 
                  actionButtonIcon: 
                  TablerIcons.search,
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
                        : GridView.builder(
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
                              child: ShopPack(
                                packImageUrl: pack.packImage,
                                packName: pack.packName,
                                stock: pack.globalQuantity ?? 99999999999999, 
                                price: pack.price,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

