import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_button.dart';

import 'pokemub_text.dart';

class PokemubTextfield extends StatelessWidget {
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
  });

  final String label;
  final String hintText;
  final bool hasActionButton;
  final bool isPassword;
  final double width;
  final IconData actionButtonIcon;
  final TextEditingController? controller;
  final Function? actionButtonOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ParkinsansText(text: label, color: pokemubTextColor, fontWeight: FontWeight.bold, fontSize: 14),
        const SizedBox(height: 4,),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: pokemubBackgroundColor,
            border: Border.all(color: pokemubTextColor30, width: 2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: hasActionButton ? const EdgeInsets.only(left: 16, right: 10) : const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      // key: key,
                      controller: controller,
                      cursorColor: pokemubPrimaryColor,
                      style: const TextStyle(color: pokemubTextColor, fontSize: 16, fontWeight: FontWeight.normal, height: 1),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(color: pokemubTextColor30, fontSize: 16, fontWeight: FontWeight.normal,  height: 1),
                        border: InputBorder.none,
                      ),
                      obscureText: isPassword,
                    ),
                  ),
                  hasActionButton ? PokemubButton(label: '', onTap: actionButtonOnTap ?? () {}, width: 40, height: 40, hasIcon: true, icon: actionButtonIcon, fillColor: pokemubTextColor10,) : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}