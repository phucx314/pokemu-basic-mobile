import 'package:flutter/material.dart';

import '../../../common/animations/floating_fx.dart';
import '../../../common/animations/interactive_tilt_image_fx.dart';

class FloatingPack extends StatelessWidget {
  const FloatingPack({super.key, required this.id, required this.isSoldOut, required this.child});

  final int id;
  final bool isSoldOut;
  final Widget child;

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
          child: child
        ),
      ),
    );
  }
}