import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/routes/named_routes.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_text.dart';
import 'package:provider/provider.dart';

import '../../common/constants/colors.dart';
import '../../models/card.dart' as model;
import '../../viewmodels/main_layout_vm.dart';
import '../components/pokemub_button.dart';

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
                    
                        return Image.network(card.cardImage); // TODO: lấy ảnh từ cache thay vì cứ call network
                      },
                    ),
                  ),
                  PokemubButton(label: 'Open this pack again', onTap: () {context.go('${NamedRoutes.packOpen}/$packId', extra: packName);}, width: MediaQuery.of(context).size.width,),
                  const SizedBox(height: 16,),
                  PokemubButton(
                    label: 'Go to Vault', 
                    onTap: () {
                      final mainLayoutVm = context.read<MainLayoutVm>();

                      mainLayoutVm.goToVault();

                      context.go(NamedRoutes.mainLayout);
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
}