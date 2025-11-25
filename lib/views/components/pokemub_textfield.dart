import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_button.dart';

import 'pokemub_text.dart';

class PokemubTextfield extends StatefulWidget {
  const PokemubTextfield({
    super.key, 
    required this.label, 
    required this.hintText, 
    this.hasActionButton = false, 
    this.isPassword = false,
    required this.width,
    this.actionButtonIcon = Icons.abc,
    this.controller,
    this.actionButtonOnTap,
    this.error,
  });

  final String label;
  final String hintText;
  final bool hasActionButton;
  final bool isPassword;
  final double width;
  final IconData actionButtonIcon;
  final TextEditingController? controller;
  final Function? actionButtonOnTap;
  final String? error;

  @override
  State<PokemubTextfield> createState() => _PokemubTextfieldState();
}

class _PokemubTextfieldState extends State<PokemubTextfield> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label == '' ? const SizedBox() : ParkinsansText(text: widget.label, color: pokemubTextColor, fontWeight: FontWeight.bold, fontSize: 14),
        widget.label == '' ? const SizedBox() : const SizedBox(height: 4,),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: pokemubBackgroundColor,
            border: Border.all(color: (widget.error != null) ? pokemubPrimaryColor : pokemubTextColor30, width: 2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: widget.hasActionButton ? const EdgeInsets.only(left: 16, right: 10) : const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      // key: key,
                      controller: widget.controller,
                      cursorColor: pokemubPrimaryColor,
                      style: const TextStyle(color: pokemubTextColor, fontSize: 16, fontWeight: FontWeight.normal, height: 1),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(color: pokemubTextColor30, fontSize: 16, fontWeight: FontWeight.normal,  height: 1),
                        border: InputBorder.none,
                      ),
                      obscureText: widget.isPassword,
                    ),
                  ),
                  widget.controller != null 
                    ? widget.controller!.text.isEmpty 
                      ? const SizedBox() 
                      : PokemubButton(
                        label: '', 
                        width: 40, 
                        height: 40, 
                        hasIcon: true,
                        icon: TablerIcons.x,
                        labelColor: pokemubTextColor,
                        fillColor: pokemubBackgroundColor,
                        onTap: () {
                          setState(() {
                            widget.controller!.clear();
                          });
                        }
                      )
                    : const SizedBox(),
                  widget.hasActionButton 
                    ? PokemubButton(
                      label: '', 
                      onTap: widget.actionButtonOnTap ?? () {}, 
                      width: 40, 
                      height: 40, 
                      hasIcon: true, 
                      icon: widget.actionButtonIcon, 
                      fillColor: pokemubTextColor10,) 
                    : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
        (widget.error != null) ? Column(
          children: [
            const SizedBox(height: 4,),
            ParkinsansText(text: widget.error ?? 'Error', color: pokemubPrimaryColor, fontSize: 12, maxLines: 2, textOverflow: TextOverflow.ellipsis,),
          ],
        ) : const SizedBox(),
      ],
    );
  }
}