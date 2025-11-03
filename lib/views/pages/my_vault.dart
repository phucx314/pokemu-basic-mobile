import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_textfield.dart';

import '../../common/constants/colors.dart';
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
                  const ParkinsansText(text: 'VAULT', color: pokemubTextColor, fontSize: 24, fontWeight: FontWeight.bold,),
                  PokemubTextfield(label: '', hintText: 'Search card name', width: MediaQuery.of(context).size.width, hasActionButton: true, actionButtonIcon: TablerIcons.search,),
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
}