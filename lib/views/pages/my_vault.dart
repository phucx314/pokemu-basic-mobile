import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_textfield.dart';

import '../../common/constants/colors.dart';
import '../components/pokemub_button.dart';
import '../components/pokemub_text.dart';

class MyVault extends StatelessWidget {
  const MyVault({super.key});

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
                const MomoSignatureText(text: 'My vault', color: pokemubTextColor, fontSize: 24, fontWeight: FontWeight.bold,),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _openExpansionList(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        width: 90,
                        height: 60,
                        decoration: BoxDecoration(
                          color: pokemubBackgroundColor,
                          border: Border.all(color: pokemubTextColor, width: 2),
                        ),
                        child: Image.network('https://pub-b4691ef8f7464ccbb84fb1e456fb214a.r2.dev/expansions/b1-megarising.webp', fit: BoxFit.fitWidth,),
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Expanded(child: PokemubTextfield(label: '', hintText: 'Search card name', width: MediaQuery.of(context).size.width, hasActionButton: true, actionButtonIcon: TablerIcons.search,)),
                  ],
                ),
                const SizedBox(height: 16,),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1214/1695,
                    ), 
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      String formattedIndex = (index + 1).toString().padLeft(5, '0');
                      return Container(
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
                PokemubTextfield(label: '', hintText: 'Search expansions', width: MediaQuery.of(context).size.width, hasActionButton: true, actionButtonIcon: TablerIcons.search,),
                const SizedBox(height: 16,),
                Expanded(
                  child: ListView.builder(
                    itemCount: 25,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 60,
                        width: MediaQuery.of(dialogContext).size.width,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 75,
                                  height: 58,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Image.network('https://pub-b4691ef8f7464ccbb84fb1e456fb214a.r2.dev/expansions/b1-megarising.webp', fit: BoxFit.fitWidth),
                                ),
                                const ParkinsansText(text: 'Expansion Name', fontWeight: FontWeight.bold,),
                              ],
                            ),
                            Container(height: 2, color: pokemubTextColor10,),
                          ],
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
}