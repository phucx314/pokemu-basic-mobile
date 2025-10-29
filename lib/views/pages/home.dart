import 'package:flutter/material.dart';

import '../../common/constants/colors.dart';
import '../../common/utils/interactive_tilt_image_fx.dart';
import '../components/pokemub_button.dart';
import '../components/pokemub_text.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover,),
          
          Column(
            children: [
              const SizedBox(height: 48,),
              // Image.network('https://pub-b4691ef8f7464ccbb84fb1e456fb214a.r2.dev/packs/welcome-pack.webp', height: 400, fit: BoxFit.fitHeight,),
              const SizedBox(
                height: 400, // co chieu cao thi fx moi hoat dong dung dc
                child: InteractiveTiltImage(
                  imageUrl: 'https://pub-b4691ef8f7464ccbb84fb1e456fb214a.r2.dev/packs/welcome-pack.webp', imageHeight: 400, boxFit: BoxFit.fitHeight,
                  maxTiltAngle: 0.75, // Góc nghiêng lớn hơn chút
                  animationDuration: Duration(milliseconds: 300),
                ),
              ),
              const SizedBox(height: 24,),
              const ParkinsansText(text: 'Limited Pack available: Promo-A', fontWeight: FontWeight.bold,),
              const SizedBox(height: 16,),
              Container(
                decoration: BoxDecoration(
                  color: pokemubTextColor10,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ParkinsansText(text: 'Price: 250', fontWeight: FontWeight.bold,),
                      ParkinsansText(text: ' • ', fontWeight: FontWeight.bold,),
                      ParkinsansText(text: 'Stock: 16', fontWeight: FontWeight.bold,),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              PokemubButton(label: 'Open', onTap: () {}, height: 36,)
            ],
          )
        ],
      ),
    );
  }
}