import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/viewmodels/open_pack_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_button.dart';
import 'package:provider/provider.dart';

import '../../common/constants/colors.dart';
import '../../routes/named_routes.dart';
import '../components/pokemub_loading.dart';
import '../components/pokemub_text.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OpenPackVm>().fetchRolledCards(widget.packId);
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
    if (vm.isLoading) {
      return const Center(child: PokemubLoading());
    }

    if (vm.errorMessage != null) {
      return Center(child: ParkinsansText(text: vm.errorMessage!, color: pokemubPrimaryColor));
    }

    if (vm.rolledCards.isEmpty) {
      return const Center(child: ParkinsansText(text: 'No cards in pack'));
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
                height: 500,
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
                      back: Image.network(card.cardImage),
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
          PokemubButton(label: 'Skip', onTap: () {context.go(NamedRoutes.gachaResult, extra: passToNextPageData);}, hasBorder: true, borderColor: pokemubTextColor, fillColor: pokemubBackgroundColor, labelColor: pokemubTextColor,),
          const SizedBox(height: 16,),
        ],
      ),
    );
  }
}