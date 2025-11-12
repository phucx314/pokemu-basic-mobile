import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/common/animations/rare_glow_border_fx.dart';
import 'package:pokemu_basic_mobile/routes/named_routes.dart';
import 'package:pokemu_basic_mobile/viewmodels/auth_vm.dart';
import 'package:pokemu_basic_mobile/viewmodels/home_vm.dart';
import 'package:pokemu_basic_mobile/viewmodels/shop_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_text.dart';
import 'package:provider/provider.dart';

import '../../common/animations/interactive_tilt_image_fx.dart';
import '../../common/animations/parallax_holo_fx.dart';
import '../../common/constants/colors.dart';
import '../../common/utils/cache_manager_config.dart';
import '../../models/card.dart' as model;
import '../../viewmodels/main_layout_vm.dart';
import '../components/pokemub_button.dart';
import '../components/pokemub_loading.dart';

class GachaResult extends StatelessWidget {
  const GachaResult({super.key, required this.rolledCards, required this.packId, required this.packName});

  final List<model.Card> rolledCards;
  final int packId;
  final String packName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pokemubBackgroundColor,
      body: SafeArea(
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
                  // ignore: prefer_const_constructors
                  MomoSignatureText(text: packName, fontSize: 24, fontWeight: FontWeight.bold, textOverflow: TextOverflow.ellipsis,),
                  const SizedBox(height: 24,),
                  Expanded(
                    child: GridView.builder(
                      itemCount: rolledCards.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1214/1695,
                      ),
                      itemBuilder: (context, index) {
                        final card = rolledCards[index];
                    
                        return GestureDetector(
                          child: RarityGlowBorder(
                            rarityId: card.rarityId,
                            cardHeight: (MediaQuery.of(context).size.width - 16*2 - 8*2)/3 * 1695/1214,
                            cardWidth: (MediaQuery.of(context).size.width - 16*2 - 8*2)/3, // width card = width màn - 2 cái padding 16 - 2 cái spacing 8 / 3 cards 1 hàng
                            borderRadius: 5,
                            child: CachedNetworkImage(
                              imageUrl: card.cardImage,
                              placeholder: (context, url) => const Center(child: PokemubLoading()),
                              cacheManager: cacheManagerConfig,
                              errorWidget: (context, url, error) => Column(
                                children: [
                                  const Icon(TablerIcons.error_404),
                                  ParkinsansText(text: card.cardName),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            _zoomCard(context, card);
                          },
                        );
                      },
                    ),
                  ),
                  Container(height: 16,),
                  PokemubButton(
                    label: 'Open this pack again', 
                    onTap: () {
                      context.go('${NamedRoutes.packOpen}/$packId', extra: packName);
                    }, 
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 16,),
                  PokemubButton(
                    label: 'Go to Vault', 
                    onTap: () async {
                      final mainLayoutVm = context.read<MainLayoutVm>();
                      final authVm = context.read<AuthVm>();
                      final shopVm = context.read<ShopVm>();
                      final homeVm = context.read<HomeVm>();

                      context.go(NamedRoutes.mainLayout);

                      await Future.wait([
                        homeVm.getFeaturedPacks(),
                        shopVm.getAllAvailablePacks(),
                      ]);

                      mainLayoutVm.goToVault();

                      authVm.getMe();
                      
                      if (!context.mounted) return;
                    }, 
                    hasBorder: true, 
                    borderColor: pokemubTextColor, 
                    fillColor: pokemubBackgroundColor, 
                    labelColor: pokemubTextColor, 
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 16,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _zoomCard(BuildContext context, model.Card card) {
    showDialog(
      context: context,
      barrierColor: pokemubBackgroundColor.withOpacity(0.9),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1214/1695,
                  child: InteractiveTiltImage(
                    raraityId: card.rarityId,
                    maxTiltAngle: 0.3,
                    animationDuration: const Duration(milliseconds: 300),
                    child: CachedNetworkImage(
                      imageUrl: card.cardImage,
                      fit: BoxFit.contain,
                      cacheManager: cacheManagerConfig,
                      placeholder: (context, url) => const Center(child: PokemubLoading()),
                      errorWidget: (context, url, error) => Column(
                        children: [
                          const Icon(TablerIcons.error_404),
                          ParkinsansText(text: card.cardName),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              PokemubButton(
                width: 60,
                label: '', 
                onTap: () {
                  Navigator.pop(dialogContext);
                }, 
                hasIcon: true, 
                icon: TablerIcons.x, 
                hasBorder: true,
                fillColor: pokemubBackgroundColor,
              ),
              const SizedBox(height: 16,),
            ],
          ),
        );
      },
    );
  }
}