import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_button.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_textfield.dart';

import '../components/pokemub_text.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder:(context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24,),
                            Image.asset('assets/images/poke_ball.png', height: 128,),
                            const SizedBox(height: 24,),
                            const ParkinsansText(text: 'LOGIN TO THE VAULT', fontSize: 24, fontWeight: FontWeight.bold),
                            const SizedBox(height: 16,),
                            PokemubTextfield(width: MediaQuery.of(context).size.width, label: 'Username', hintText: 'Enter your username',),
                            const SizedBox(height: 16,),
                            PokemubTextfield(width: MediaQuery.of(context).size.width, label: 'Password', hintText: 'Enter your password', hasActionButton: true, actionButtonIcon: TablerIcons.eye_closed, isPassword: true,),
                            const SizedBox(height: 48,),
                            PokemubButton(label: 'Log in', onTap: () {}, width: MediaQuery.of(context).size.width),
                            const SizedBox(height: 16,),
                            PokemubButton(label: 'Become a Pack Opener', onTap: () {}, width: MediaQuery.of(context).size.width, fillColor: pokemubBackgroundColor, labelColor: pokemubTextColor, hasBorder: true,),
                            const SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}