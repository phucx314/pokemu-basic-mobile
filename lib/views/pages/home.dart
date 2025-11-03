import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/viewmodels/home_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_loading.dart';
import 'package:provider/provider.dart';

import '../../common/constants/colors.dart';
import '../../common/utils/currency_formatter.dart';
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
          
          Column(
            children: [
              const SizedBox(height: 24,),
              const MomoSignatureText(text: 'Featured packs', fontSize: 24, color: pokemubTextColor, fontWeight: FontWeight.bold,),
              const SizedBox(height: 24,),
              homeVm.isLoading 
                ? const SizedBox(height: 400, child: Center(child: PokemubLoading(),),)
                : Expanded(
                    child: PageView.builder(
                      allowImplicitScrolling: true, // pre-load side-by-side pages (item) -> avoid animation inconsistency due to lazy loading
                      controller: PageController(viewportFraction: 0.7), // takes 70% width
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: homeVm.featuredPacks.length,
                      itemBuilder: (context, index) {
                        final pack = homeVm.featuredPacks[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              FloatingPack(
                                id: pack.id,
                                packImage: pack.packImage,
                                isSoldOut: (pack.globalQuantity.toString() == '0') ? true : false,
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
                                          ? const ParkinsansText(text: 'unlimited', fontSize: 12,)
                                          : ParkinsansText(text: '${CurrencyFormatter.formatCoin(pack.globalQuantity!)} left', fontSize: 12,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16,),
                              PokemubButton(label: 'Open', onTap: () {}, height: 36,),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  //
                  //
            ],
          )
        ],
      ),
    );
  }
}