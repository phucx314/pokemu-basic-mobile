import 'package:flutter/material.dart';

import '../../common/constants/colors.dart';

class PackOpen extends StatelessWidget {
  const PackOpen({super.key});

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
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}