import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';

class ParkinsansText extends StatelessWidget {
  const ParkinsansText({super.key, required this.text, this.color = pokemubTextColor, this.fontSize = 16, this.fontWeight = FontWeight.normal, this.maxLines = 1, this.textOverflow = TextOverflow.visible});

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final int maxLines;
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    // return Baseline(baseline: fontSize, baselineType: TextBaseline.alphabetic, child: Text(text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight, fontFamily: 'Parkinsans'),));
    return Text(text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight, fontFamily: 'Parkinsans'), maxLines: maxLines, overflow: textOverflow,);
  }
}

class MomoSignatureText extends StatelessWidget {
  const MomoSignatureText({super.key, required this.text, this.color = pokemubTextColor, this.fontSize = 16, this.fontWeight = FontWeight.normal, this.maxLines = 1, this.textOverflow = TextOverflow.visible});

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final int maxLines;
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    // return Baseline(baseline: fontSize, baselineType: TextBaseline.alphabetic, child: Text(text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight, fontFamily: 'Parkinsans'),));
    return Text(text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight, fontFamily: 'MomoSignature'), maxLines: maxLines, overflow: textOverflow,);
  }
}