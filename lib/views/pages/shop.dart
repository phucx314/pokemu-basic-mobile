import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_text.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_textfield.dart';

import '../components/shop/shop_pack.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
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
                const ParkinsansText(text: 'SHOP', color: pokemubTextColor, fontSize: 24, fontWeight: FontWeight.bold,),
                PokemubTextfield(label: '', hintText: 'Search pack name', width: MediaQuery.of(context).size.width, hasActionButton: true, actionButtonIcon: TablerIcons.search,),
                const SizedBox(height: 16,),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.489,
                    ), 
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 12, 
                        width: 12,
                        child: const ShopPack(
                          packImageUrl: 'https://pub-b4691ef8f7464ccbb84fb1e456fb214a.r2.dev/packs/welcome-pack.webp',
                          packName: 'Welcome Pack',
                          stock: 33948,
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

