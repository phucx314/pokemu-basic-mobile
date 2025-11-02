import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/models/auth.dart';
import 'package:pokemu_basic_mobile/routes/named_routes.dart';
import 'package:pokemu_basic_mobile/viewmodels/create_account_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_text.dart';
import 'package:provider/provider.dart';

import '../../common/constants/colors.dart';
import '../components/pokemub_button.dart';
import '../components/pokemub_textfield.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() async {
    final registerRequest = RegisterRequest(username: _usernameController.text, fullName: _fullNameController.text, password: _passwordController.text, confirmPassword: _confirmPasswordController.text);

    final createAccountVm = context.read<CreateAccountVm>();

    bool success = await createAccountVm.createAccount(registerRequest);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: ParkinsansText(text: 'Account created', color: pokemubBackgroundColor,), backgroundColor: pokemubPrimaryColor,),
      );
      context.go('/login/${registerRequest.username}'); // pass username to login page
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: ParkinsansText(text: createAccountVm.errorMessage ?? 'Something went wrong', color: pokemubBackgroundColor,), backgroundColor: pokemubPrimaryColor,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final createAccountVm = context.watch<CreateAccountVm>();

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
                            PokemubTextfield(width: MediaQuery.of(context).size.width, label: 'Full name', hintText: 'Enter your full name', controller: _fullNameController,),
                            const SizedBox(height: 16,),
                            PokemubTextfield(width: MediaQuery.of(context).size.width, label: 'Username', hintText: 'Create your username', controller: _usernameController,),
                            const SizedBox(height: 16,),
                            PokemubTextfield(
                              width: MediaQuery.of(context).size.width, 
                              label: 'Password', 
                              hintText: 'Enter your password', 
                              hasActionButton: true, 
                              actionButtonIcon: createAccountVm.isPassword ? TablerIcons.eye_closed : TablerIcons.eye, 
                              actionButtonOnTap: () {
                                createAccountVm.toggleShowHidePassword();
                              }, 
                              isPassword: createAccountVm.isPassword, 
                              controller: _passwordController,
                            ),
                            const SizedBox(height: 16,),
                            PokemubTextfield(
                              width: MediaQuery.of(context).size.width, 
                              label: 'Confirm password', 
                              hintText: 'Re-enter your password', 
                              hasActionButton: true, 
                              actionButtonIcon: createAccountVm.isPassword2 ? TablerIcons.eye_closed : TablerIcons.eye, 
                              actionButtonOnTap: () {
                                createAccountVm.toggleShowHidePassword2();
                              }, 
                              isPassword: createAccountVm.isPassword2, 
                              controller: _confirmPasswordController,
                            ),
                            const SizedBox(height: 48,),
                            PokemubButton(
                              label: 'Create account', 
                              onTap: _handleCreateAccount, 
                              width: MediaQuery.of(context).size.width, 
                              isLoading: createAccountVm.isLoading,
                            ),
                            const SizedBox(height: 16,),
                            PokemubButton(
                              label: 'Already joined? Log in', 
                              onTap: () {
                                context.go(NamedRoutes.login);
                              }, 
                              width: MediaQuery.of(context).size.width, 
                              fillColor: pokemubBackgroundColor, 
                              labelColor: pokemubTextColor, 
                              hasBorder: true,
                            ),
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