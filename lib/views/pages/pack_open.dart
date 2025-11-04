import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/viewmodels/open_pack_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_button.dart';
import 'package:provider/provider.dart';

import '../../common/constants/colors.dart';
import '../components/pokemub_loading.dart';
import '../components/pokemub_text.dart';

class PackOpen extends StatefulWidget {
  const PackOpen({super.key, required this.packId});

  final int packId;

  @override
  State<PackOpen> createState() => _PackOpenState();
}

class _PackOpenState extends State<PackOpen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OpenPackVm>().fetchRolledCards(widget.packId);
    });
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
            
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: openPackVm.rolledCards.length,
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (openPackVm.isLoading) {
                              return const Center(child: PokemubLoading());
                            }
                                        
                            if (openPackVm.errorMessage != null) {
                              return Center(child: ParkinsansText(text: openPackVm.errorMessage!, color: pokemubPrimaryColor));
                            }
                                        
                            final card = openPackVm.rolledCards[index];
                            return Image.network(card.cardImage, height: 100,);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                PokemubButton(label: 'Next', onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}