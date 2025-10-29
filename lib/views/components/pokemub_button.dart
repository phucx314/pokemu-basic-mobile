import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';

import 'pokemub_text.dart';
import '../../common/utils/extension.dart';

class PokemubButton extends StatelessWidget {
  const PokemubButton({
    super.key, 
    this.fillColor = pokemubPrimaryColor, 
    required this.label, 
    required this.onTap, 
    this.labelColor = pokemubBackgroundColor,
    this.width = 120,
    this.height = 60,
    this.hasBorder = false,
    this.borderColor = pokemubTextColor,
    this.borderWidth = 2,
    this.hasIcon = false,
    this.icon = Icons.zoom_in,
  });

  final Color? fillColor;
  final String label;
  final Color labelColor;
  final Function onTap;
  final double width;
  final double height;
  final bool hasBorder;
  final Color borderColor;
  final double borderWidth;
  final bool hasIcon;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: fillColor,
        border: hasBorder 
          ? Border.all(
            color: borderColor,
            width: borderWidth,
          ) 
          : Border.all(
            color: Colors.black.withOpacity(0),
            width: 0,
          ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hasIcon ? Icon(icon) : const SizedBox(),
            ParkinsansText(
              text: label, color: labelColor, fontSize: 16, fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }
}