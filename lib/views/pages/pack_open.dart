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
import '../../routes/named_routes.dart';
import '../components/pokemub_loading.dart';
import '../components/pokemub_text.dart';
import '../../models/card.dart' as model;

class PackOpen extends StatefulWidget {
  const PackOpen({super.key, required this.packId, required this.packName});

  final int packId;
  final String packName;

  @override
  State<PackOpen> createState() => _PackOpenState();
}

class _PackOpenState extends State<PackOpen> {
  final CardSwiperController _swiperController = CardSwiperController();

  bool _isCachingImages = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchAndPrecacheCards();
    });
  }

  Future<void> _fetchAndPrecacheCards() async {
    final vm = context.read<OpenPackVm>();

    bool success = await vm.fetchRolledCards(widget.packId);

    if (success && mounted) {
      setState(() {
        _isCachingImages = true;
      });

      await _preCacheImages(vm.rolledCards);

      if (mounted) {
        setState(() {
          _isCachingImages = false;
        });
      }
    }
  }

  Future<void> _preCacheImages(List<model.Card> cards) async {
    if (!mounted) return; // check an toan

    List<Future> futures = [];

    for (var card in cards) {
      futures.add(precacheImage(CachedNetworkImageProvider(card.cardImage), context));
    }

    await Future.wait(futures); // doi tat ca images tai xong
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
    if (vm.isLoading || _isCachingImages) {
      return const Center(child: PokemubLoading());
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
            PokemubButton(label: 'Go back', onTap: () {context.go(NamedRoutes.mainLayout);}, height: 36, width: 120, hasBorder: true, fillColor: pokemubBackgroundColor, labelColor: pokemubTextColor, ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
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
                      front: Image.asset('assets/images/CardbackPocket.webp'), 
                      back: CachedNetworkImage(
                        imageUrl: card.cardImage,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: PokemubLoading(),
                        ),
                        errorWidget: (context, url, error) => const Icon(TablerIcons.error_404),
                      ),
                    );
                  },
                  numberOfCardsDisplayed: 3,
                  backCardOffset: const Offset(0, 20),
                  scale: 0.9,
                  onEnd: () {
                    context.go(NamedRoutes.gachaResult, extra: passToNextPageData); // tính sau
                  },
                ),
              ),
            ),
          ),
          PokemubButton(label: 'Skip', width: 150, onTap: () {context.go(NamedRoutes.gachaResult, extra: passToNextPageData);}, hasBorder: true, borderColor: pokemubTextColor, fillColor: pokemubBackgroundColor, labelColor: pokemubTextColor,),
          const SizedBox(height: 16,),
        ],
      ),
    );
  }
}