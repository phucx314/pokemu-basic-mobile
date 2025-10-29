import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';
import 'package:pokemu_basic_mobile/viewmodels/main_layout_vm.dart';
import 'package:pokemu_basic_mobile/views/pages/create_account.dart';
import 'package:pokemu_basic_mobile/views/pages/main_layout.dart';
import 'package:pokemu_basic_mobile/views/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainLayoutVm()),
      ],
      child:  MaterialApp(
        title: 'PokEmu Basic',
        theme: ThemeData(
          fontFamily: 'Parkinsans',
          colorScheme: ColorScheme.fromSeed(seedColor: pokemubPrimaryColor),
        ),
        debugShowCheckedModeBanner: false,
        // home: const LoginPage(),
        // home: const CreateAccount(),
        home: const MainLayout(),
      ),
    );
  }
}
