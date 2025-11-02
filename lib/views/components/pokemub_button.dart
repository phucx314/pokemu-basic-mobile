import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';

import 'pokemub_text.dart';

class PokemubButton extends StatefulWidget {
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
    this.isLoading = false,
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
  final bool isLoading;

  @override
  State<PokemubButton> createState() => _PokemubButtonState();
}

class _PokemubButtonState extends State<PokemubButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.fillColor,
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
          child: widget.isLoading ? Center(child: CircularProgressIndicator(color: widget.labelColor),) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.hasIcon ? Icon(widget.icon) : const SizedBox(),
              ParkinsansText(
                text: widget.label, color: widget.labelColor, fontSize: 16, fontWeight: FontWeight.bold),
            ],
          ),
        ),
      ),
    );
  }
}