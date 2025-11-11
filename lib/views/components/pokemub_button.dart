import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';

import 'pokemub_loading.dart';
import 'pokemub_text.dart';

class PokemubButton extends StatefulWidget {
  const PokemubButton({
    super.key, 
    this.fillColor = pokemubPrimaryColor, 
    required this.label, 
    required this.onTap, 
    this.labelColor = pokemubBackgroundColor,
    this.width,
    this.height = 60,
    this.hasBorder = false,
    this.borderColor = pokemubTextColor,
    this.borderWidth = 2,
    this.hasIcon = false,
    this.icon = Icons.zoom_in,
    this.iconSize = 24,
    this.labelSize = 16,
    this.isLoading = false,
    this.isDisabled = false,
  });

  final Color fillColor;
  final String label;
  final Color labelColor;
  final Function onTap;
  final double? width;
  final double height;
  final bool hasBorder;
  final Color borderColor;
  final double borderWidth;
  final bool hasIcon;
  final IconData icon;
  final bool isLoading;
  final double iconSize;
  final double labelSize;
  final bool isDisabled;

  @override
  State<PokemubButton> createState() => _PokemubButtonState();
}

class _PokemubButtonState extends State<PokemubButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDisabled ? null : () => widget.onTap(),
      child: Container(
        height: widget.height,
        width: widget.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: widget.isDisabled ? widget.fillColor.withOpacity(0.5) : widget.fillColor,
          border: widget.hasBorder 
            ? Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ) 
            : Border.all(
              color: Colors.black.withOpacity(0),
              width: 0,
            ),
        ),
        child: Center(
          child: widget.isLoading ? const Center(child: PokemubLoading(size: 25,),) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.hasIcon ? Icon(widget.icon, size: widget.iconSize,) : const SizedBox(),
              ParkinsansText(
                text: widget.label, color: widget.labelColor, fontSize: widget.labelSize, fontWeight: FontWeight.bold),
            ],
          ),
        ),
      ),
    );
  }
}