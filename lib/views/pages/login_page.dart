import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';
import 'package:pokemu_basic_mobile/models/auth.dart';
import 'package:pokemu_basic_mobile/routes/named_routes.dart';
import 'package:pokemu_basic_mobile/viewmodels/login_page_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_button.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_textfield.dart';
import 'package:provider/provider.dart';

import '../components/pokemub_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.username});

  final String? username;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
    if (widget.username != null) {
      _usernameController.text = widget.username!;
    }
  }

  void _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    LoginRequest loginRequest = LoginRequest(username: username, password: password);

    final loginPageVm = context.read<LoginPageVm>();

    bool success = await loginPageVm.login(loginRequest);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: ParkinsansText(text: loginPageVm.errorMessage ?? 'Something went wrong', color: pokemubBackgroundColor, maxLines: 5, textOverflow: TextOverflow.ellipsis,), backgroundColor: pokemubPrimaryColor,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginPageVm = context.watch<LoginPageVm>();

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
                            PokemubTextfield(width: MediaQuery.of(context).size.width, label: 'Username', hintText: 'Enter your username', controller: _usernameController,),
                            const SizedBox(height: 16,),
                            PokemubTextfield(
                              width: MediaQuery.of(context).size.width, 
                              label: 'Password', 
                              hintText: 'Enter your password', 
                              hasActionButton: true, 
                              actionButtonIcon: loginPageVm.isPassword ? TablerIcons.eye_closed : TablerIcons.eye, 
                              actionButtonOnTap: () {
                                loginPageVm.toggleShowHidePassword();
                              }, 
                              isPassword: loginPageVm.isPassword, 
                              controller: _passwordController,
                            ),
                            const SizedBox(height: 48,),
                            PokemubButton(
                              label: 'Log in', 
                              onTap: _handleLogin,
                              width: MediaQuery.of(context).size.width,
                              isLoading: loginPageVm.isLoading,
                            ),
                            const SizedBox(height: 16,),
                            PokemubButton(
                              label: 'Become a Pack Opener', 
                              onTap: () {
                                context.go(NamedRoutes.register);
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