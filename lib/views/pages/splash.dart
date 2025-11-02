import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/routes/named_routes.dart';
import 'package:pokemu_basic_mobile/services/token_storage_service.dart';
import 'package:pokemu_basic_mobile/viewmodels/auth_vm.dart';
import 'package:pokemu_basic_mobile/views/pages/login_page.dart';
import 'package:pokemu_basic_mobile/views/pages/main_layout.dart';
import 'package:provider/provider.dart';

import '../components/pokemub_loading.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    final authVm = context.read<AuthVm>();

    final result = await Future.wait([
      authVm.tryAutoLogin(), // check login
      Future.delayed(const Duration(seconds: 0)), // load 3s
    ]);

    final bool isLoggedIn = result[0] as bool;

    if (!mounted) return; // IMPORTANT: check 'mounted' before using context

    if (isLoggedIn) {
      context.go(NamedRoutes.mainLayout);
    } else {
      context.go(NamedRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: PokemubLoading(),
      ),
    );
  }
}
