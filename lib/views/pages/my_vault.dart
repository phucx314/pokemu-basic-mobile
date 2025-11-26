import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pokemu_basic_mobile/common/utils/cache_manager_config.dart';
import 'package:pokemu_basic_mobile/models/card.dart' as model;
import 'package:pokemu_basic_mobile/viewmodels/my_vault_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_textfield.dart';
import 'package:provider/provider.dart';

import '../../common/animations/interactive_tilt_image_fx.dart';
import '../../common/constants/colors.dart';
import '../components/pokemub_button.dart';
import '../components/pokemub_loading.dart';
import '../components/pokemub_text.dart';

class MyVault extends StatefulWidget {
  const MyVault({super.key});

  @override
  State<MyVault> createState() => _MyVaultState();
}

class _MyVaultState extends State<MyVault> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 2. Lắng nghe sự kiện cuộn
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // 3. Nhớ dispose để tránh leak memory
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Nếu cuộn đến gần cuối (còn cách đáy 200px)
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final vm = context.read<MyVaultVm>();
      // Gọi hàm load more (nhớ check null selectedExpansion)
      if (vm.selectedExpansion != null) {
        print('🚀 Trigger Load More! Page: ${vm.currentPage} / ${vm.totalPages}');
        vm.getOwnedCards(vm.selectedExpansion!.id, isLoadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myVaultVm = context.watch<MyVaultVm>();

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
                const MomoSignatureText(text: 'My vault', color: pokemubTextColor, fontSize: 24, fontWeight: FontWeight.bold,),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _openExpansionList(context);
                        await myVaultVm.getExpansionList();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        width: 90,
                        height: 60,
                        decoration: BoxDecoration(
                          color: pokemubBackgroundColor,
                          border: Border.all(color: pokemubTextColor, width: 2),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: myVaultVm.selectedExpansion?.expansionImage 
                            ?? 'https://pub-b4691ef8f7464ccbb84fb1e456fb214a.r2.dev/expansions/NOT%20SELECTED.png'
                        ),
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: PokemubTextfield(
                        label: '', 
                        hintText: 'Search card name', 
                        width: MediaQuery.of(context).size.width, 
                        hasActionButton: true, 
                        actionButtonIcon: TablerIcons.search,
                        controller: myVaultVm.cardSearchController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1214/1695,
                    ), 
                    itemCount: myVaultVm.currentLastOwnedCard,
                    itemBuilder: (context, index) {
                      int currExpansionIndex = index + 1;

                      String formattedIndex = (index + 1).toString().padLeft(3, '0');

                      final ownedCard = myVaultVm.cardList
                        .cast<model.CardInList?>()
                        .firstWhere(
                          (card) => card?.expansionIndex == currExpansionIndex,
                          orElse: () => null,
                        );

                      return (ownedCard != null) 
                        ? GestureDetector(
                          onTap: () {
                            _zoomCard(context, ownedCard);
                          },
                          child: CachedNetworkImage(
                            imageUrl: ownedCard.cardImage,
                            cacheManager: cacheManagerConfig,
                            placeholder: (context, url) => const Center(child: PokemubLoading()),
                            errorWidget: (context, url, error) => const Icon(TablerIcons.error_404),
                          ),
                        )
                        : Container(
                        height: 12, 
                        width: 12, 
                        decoration: BoxDecoration(
                          color: pokemubTextColor10,
                          borderRadius: BorderRadius.circular(4)
                        ), 
                        child: Center(
                          child: ParkinsansText(text: formattedIndex, fontSize: 14, fontWeight: FontWeight.bold, color: pokemubTextColor30,),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16,),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _openExpansionList(BuildContext context) {
    showDialog(
      context: context, 
      builder: (dialogContext) {
        final vm = dialogContext.watch<MyVaultVm>();

        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 0.75 * MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: pokemubBackgroundColor,
              border: Border.all(width: 2, color: pokemubTextColor,),
            ),
            child: Column(
              children: [
                PokemubTextfield(
                  controller: vm.expansionSearchController, 
                  label: '', 
                  hintText: 'Search expansions', 
                  width: MediaQuery.of(context).size.width, 
                  hasActionButton: true, 
                  actionButtonIcon: TablerIcons.search,
                ),
                const SizedBox(height: 16,),
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.expansionList.length,
                    itemBuilder: (context, index) {
                      final expansion = vm.expansionList[index];
                      bool isChosen = (vm.selectedExpansion?.id == expansion.id);

                      return GestureDetector(
                        onTap: () {
                          vm.selectExpansion(expansion);
                        },
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(dialogContext).size.width,
                          color: isChosen 
                            ? pokemubPrimaryColor 
                            : pokemubBackgroundColor,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 75,
                                    height: 58,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: CachedNetworkImage(imageUrl: expansion.expansionImage, fit: BoxFit.fitWidth),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ParkinsansText(
                                          text: '[${expansion.expansionCode}]',
                                          fontSize: 12,
                                          textOverflow: TextOverflow.ellipsis,
                                          color: isChosen 
                                            ? pokemubBackgroundColor 
                                            : pokemubTextColor,
                                        ),
                                        ParkinsansText(
                                          text: expansion.expansionName, 
                                          fontWeight: FontWeight.bold,
                                          textOverflow: TextOverflow.ellipsis,
                                          color: isChosen 
                                            ? pokemubBackgroundColor 
                                            : pokemubTextColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  isChosen 
                                    ? const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Icon(TablerIcons.check, color: pokemubBackgroundColor,),
                                    ) 
                                    : const SizedBox(),
                                ],
                              ),
                              Container(height: 2, color: pokemubTextColor10,),
                            ],
                          ),
                        ),
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
                        label: 'Confirm', 
                        onTap: () {
                          vm.resetSearchTextfields();

                          if (vm.selectedExpansion != null) {
                            vm.getOwnedCards(vm.selectedExpansion!.id);
                          }

                          Navigator.pop(dialogContext);
                        }, 
                        height: 36,
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

  void _zoomCard(BuildContext context, model.CardInList card) {
    showDialog(
      context: context,
      barrierColor: pokemubBackgroundColor.withOpacity(0.9),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AspectRatio(
                    aspectRatio: 1214/1695,
                    child: InteractiveTiltImage(
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
              ),
              const SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PokemubButton(
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
              ),
              const SizedBox(height: 16,),
            ],
          ),
        );
      },
    );
  }
}