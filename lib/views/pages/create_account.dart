import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_text.dart';

import '../../common/constants/colors.dart';
import '../components/pokemub_button.dart';
import '../components/pokemub_textfield.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

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
                builder: (context, constraints) {
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
                            const ParkinsansText(text: 'BECOME A PACK OPENER', fontSize: 24, fontWeight: FontWeight.bold,),
                            const SizedBox(height: 16,),
                            PokemubTextfield(width: MediaQuery.of(context).size.width, label: 'Full name', hintText: 'Enter your full name',),
                            const SizedBox(height: 16,),
                            PokemubTextfield(width: MediaQuery.of(context).size.width, label: 'Username', hintText: 'Create your username',),
                            const SizedBox(height: 16,),
                            PokemubTextfield(width: MediaQuery.of(context).size.width, label: 'Password', hintText: 'Enter your password', hasActionButton: true, actionButtonIcon: TablerIcons.eye_closed, isPassword: true,),
                            const SizedBox(height: 16,),
                            PokemubTextfield(width: MediaQuery.of(context).size.width, label: 'Confirm password', hintText: 'Re-enter your password', hasActionButton: true, actionButtonIcon: TablerIcons.eye_closed, isPassword: true,),
                            const SizedBox(height: 48,),
                            PokemubButton(label: 'Create account', onTap: () {}, width: MediaQuery.of(context).size.width),
                            const SizedBox(height: 16,),
                            PokemubButton(label: 'Already joined? Log in', onTap: () {}, width: MediaQuery.of(context).size.width, fillColor: pokemubBackgroundColor, labelColor: pokemubTextColor, hasBorder: true,),
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