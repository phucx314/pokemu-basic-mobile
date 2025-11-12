import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/viewmodels/open_pack_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_button.dart';
import 'package:provider/provider.dart';

import '../../common/constants/colors.dart';
import '../../common/utils/cache_manager_config.dart';
import '../../routes/named_routes.dart';
import '../components/pokemub_loading.dart';
import '../components/pokemub_text.dart';
import '../../models/card.dart' as model;

final Map<dynamic, String> elementTypeMapToPng = {
  null: 'default_avatar.png', // null
  1: 'grass.png',
  2: 'fire.png',
  3: 'water.png',
  4: 'lightning.png',
  5: 'psychic.png',
  6: 'fighting.png',
  7: 'darkness.png',
  8: 'metal.png',
  9: 'dragon.png',
  10: 'colorless.png',
  11: 'fairy.png',
};

final Map<dynamic, String> rarityMapToPng = {
  null: 'default_avatar.png', // null
  1: 'common.png',
  2: 'uncommon.png',
  3: 'rare.png',
  4: 'very_rare.png',
  5: 'ultra_rare.png',
  6: 'legendary.png',
};

final Map<dynamic, String> rarityMapToLottie = {
  null: 'default_avatar.png', // null
  1: 'common.gif',
  2: 'uncommon.gif',
  3: 'rare.gif',
  4: 'very_rare.gif',
  5: 'epic.gif',
  6: 'legendary.gif',
};

final Map<dynamic, String> rarityMapToText = {
  null: '', // null
  1: 'Common',
  2: 'Uncommon',
  3: 'Rare',
  4: 'Very rare',
  5: 'Epic',
  6: 'Legendary',
};

class PackOpen extends StatefulWidget {
  const PackOpen({super.key, required this.packId, required this.packName});

  final int packId;
  final String packName;

  @override
  State<PackOpen> createState() => _PackOpenState();
}

class _PackOpenState extends State<PackOpen> {
  final CardSwiperController _swiperController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<OpenPackVm>().fetchAndPrecacheCards(widget.packId, context);
    });
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final openPackVm = context.watch<OpenPackVm>();

    return Scaffold(
      backgroundColor: pokemubBackgroundColor,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/background.png', fit: BoxFit.cover,),
            
            _buildBody(context, openPackVm),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, OpenPackVm vm) {
    if (vm.isLoading || vm.isCachingImages) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(child: Center(child: PokemubLoading())),
            PokemubButton(label: vm.isOpenedFromBack ? 'Open from front' : 'Open from back', onTap: () {vm.toggleBackCardOpen();}, hasBorder: true, fillColor: pokemubBackgroundColor, labelColor: pokemubTextColor),
          ],
        ),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ParkinsansText(text: vm.errorMessage!, color: pokemubPrimaryColor),
            const SizedBox(height: 16),
            PokemubButton(label: 'Go back', onTap: () {context.go(NamedRoutes.mainLayout);}, height: 36, width: 120, hasBorder: true, fillColor: pokemubBackgroundColor, labelColor: pokemubTextColor, ),
          ],
        ),
      );
    }

    if (vm.rolledCards.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ParkinsansText(text: 'No cards in pack'),
            const SizedBox(height: 16),
            PokemubButton(label: 'Go back', onTap: () {context.go(NamedRoutes.mainLayout);}, height: 36, width: 120, hasBorder: true, fillColor: pokemubBackgroundColor, labelColor: pokemubTextColor,),
          ],
        ),
      );
    }

    final cards = vm.rolledCards;

    final passToNextPageData = {
      'cards': vm.rolledCards,
      'packId': widget.packId,
      'packName': widget.packName,
    };

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 50+16+16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 75,
                    child: vm.currRarityId == null 
                      ? Image.asset('assets/images/default_avatar.png') 
                      : Image.asset('assets/images/${rarityMapToLottie[vm.currRarityId]}'),
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.75 * 1695/1214,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: CardSwiper(
                      padding: EdgeInsets.zero,
                      isLoop: false,
                      controller: _swiperController,
                      cardsCount: cards.length,
                      cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
                        final card = cards[index];
                    
                        return FlipCard(
                          key: ValueKey(card.id),
                          speed: 400,
                          side: CardSide.FRONT,
                          back: vm.isOpenedFromBack ? _buildFrontCard(context, card) : _buildBackCard(), 
                          front: vm.isOpenedFromBack ? _buildBackCard() : _buildFrontCard(context, card),
                        );
                      },
                      onSwipe: (previousIndex, currentIndex, direction) {
                        vm.onCardSwiped(currentIndex);
                  
                        return true;
                      },
                      numberOfCardsDisplayed: 3,
                      backCardOffset: const Offset(0, 30),
                      scale: 0.9,
                      onEnd: () {
                        context.go(NamedRoutes.gachaResult, extra: passToNextPageData);
                      },
                    ),
                  ),
                  const SizedBox(height: 75+16),
                ],
              ),
            ),
          ),
          PokemubButton(label: 'Skip', width: 150, onTap: () {context.go(NamedRoutes.gachaResult, extra: passToNextPageData);}, hasBorder: true, borderColor: pokemubTextColor, fillColor: pokemubBackgroundColor, labelColor: pokemubTextColor,),
          const SizedBox(height: 16,),
        ],
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context, model.Card card) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CachedNetworkImage(
          imageUrl: card.cardImage,
          fit: BoxFit.contain,
          cacheManager: cacheManagerConfig,
          placeholder: (context, url) => const Center(
            child: PokemubLoading(),
          ),
          errorWidget: (context, url, error) => Column(
            children: [
              const Icon(TablerIcons.error_404),
              ParkinsansText(text: card.cardName),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackCard() {
    return Image.asset('assets/images/CardbackPocket.webp');
  }
}