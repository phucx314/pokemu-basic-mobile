import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PokemubLoading extends StatelessWidget {
  const PokemubLoading({super.key, this.size = 50});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/lotties/pokemu_loading.json', width: size, height: size, repeat: true);
  }
}