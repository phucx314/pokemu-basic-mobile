import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/viewmodels/home_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_loading.dart';
import 'package:provider/provider.dart';

import '../../common/animations/floating_fx.dart';
import '../../common/constants/colors.dart';
import '../../common/animations/interactive_tilt_image_fx.dart';
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
              const SizedBox(height: 48,),
              homeVm.isLoading 
                ? const SizedBox(height: 400, child: Center(child: PokemubLoading(),),)
                : Expanded(
                    child: ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: homeVm.featuredPacks.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              FloatingPack(
                                id: homeVm.featuredPacks[index].id, 
                                packName: homeVm.featuredPacks[index].packName, 
                                packImage: homeVm.featuredPacks[index].packImage,
                                cardQuantity: homeVm.featuredPacks[index].cardQuantity,
                                globalQuantity: homeVm.featuredPacks[index].globalQuantity ?? 99999999999,
                                price: homeVm.featuredPacks[index].price,
                              ),
                              const SizedBox(height: 24,),
                              ParkinsansText(text: homeVm.featuredPacks[index].packName, fontWeight: FontWeight.bold,),
                              const SizedBox(height: 16,),
                              Container(
                                decoration: BoxDecoration(
                                  color: pokemubTextColor10,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ParkinsansText(text: 'Price: ${homeVm.featuredPacks[index].price}', fontWeight: FontWeight.bold,),
                                      const ParkinsansText(text: ' • ', fontWeight: FontWeight.bold,),
                                      ParkinsansText(text: 'Stock: ${homeVm.featuredPacks[index].globalQuantity}', fontWeight: FontWeight.bold,),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16,),
                              PokemubButton(label: 'Open', onTap: () {}, height: 36,)
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

class FloatingPack extends StatelessWidget {
  const FloatingPack({super.key, required this.id, required this.packName, required this.packImage, required this.price, required this.globalQuantity, required this.cardQuantity});

  final int id;
  final String packName;
  final String packImage;
  final int price;
  final int globalQuantity;
  final int cardQuantity;

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      verticalOffset: 32, // floating 32px
      duration: const Duration(milliseconds: 1500), // chu ky 1.5s
      child: SizedBox(
        height: 400, // co chieu cao thi fx moi hoat dong dung dc
        child: InteractiveTiltImage(
          imageUrl: packImage, imageHeight: 400, boxFit: BoxFit.fitHeight,
          maxTiltAngle: 0.0, // angle
          animationDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}