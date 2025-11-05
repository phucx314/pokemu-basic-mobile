import 'package:flutter/material.dart';

import '../../../common/animations/floating_fx.dart';
import '../../../common/animations/interactive_tilt_image_fx.dart';

class FloatingPack extends StatelessWidget {
  const FloatingPack({super.key, required this.id, required this.packImage, required this.isSoldOut});

  final int id;
  final String packImage;
  final bool isSoldOut;

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      verticalOffset: 32, // floating 32px
      duration: const Duration(milliseconds: 1500), // chu ky 1.5s
      child: SizedBox(
        height: 400, // co chieu cao thi fx moi hoat dong dung dc
        width: 250,
        child: InteractiveTiltImage(
          maxTiltAngle: 0.25, // angle
          animationDuration: const Duration(milliseconds: 300),
          child: Image.network(packImage, height: 400, fit: BoxFit.fitHeight, opacity: AlwaysStoppedAnimation(isSoldOut ? 0.3 : 1),),
        ),
      ),
    );
  }
}