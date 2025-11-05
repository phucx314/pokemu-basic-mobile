import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pokemu_basic_mobile/common/constants/colors.dart';
import 'package:pokemu_basic_mobile/routes/app_router.dart';
import 'package:pokemu_basic_mobile/viewmodels/auth_vm.dart';
import 'package:pokemu_basic_mobile/viewmodels/create_account_vm.dart';
import 'package:pokemu_basic_mobile/viewmodels/login_page_vm.dart';
import 'package:pokemu_basic_mobile/viewmodels/main_layout_vm.dart';
import 'package:pokemu_basic_mobile/viewmodels/open_pack_vm.dart';
import 'package:pokemu_basic_mobile/viewmodels/shop_vm.dart';
import 'package:pokemu_basic_mobile/views/pages/pack_open.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'viewmodels/home_vm.dart';

List<SingleChildWidget> buildProviders() => [
  // independent VMs
  ChangeNotifierProvider(create: (context) => MainLayoutVm()),
  ChangeNotifierProvider(create: (context) => AuthVm()),
  ChangeNotifierProvider(create: (context) => CreateAccountVm()),
  ChangeNotifierProvider(create: (context) => ShopVm()),
  ChangeNotifierProvider(create: (context) => HomeVm()),
  ChangeNotifierProvider(create: (context) => OpenPackVm()),

  // VMs that depends on another VM
  ChangeNotifierProxyProvider<AuthVm, LoginPageVm>(
    create: (context) => LoginPageVm(
      authVm: context.read<AuthVm>(),
    ),
    update: (context, authVm, previousLoginPageVm) => LoginPageVm(
      authVm: authVm,
    ),
  ),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(providers: buildProviders(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.read<AuthVm>();
    final appRouter = AppRouter(authVm);

    return MaterialApp.router(
      title: 'PokEmu Basic',
      theme: ThemeData(
        fontFamily: 'Parkinsans',
        colorScheme: ColorScheme.fromSeed(seedColor: pokemubPrimaryColor),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.router,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'PokEmu Basic',
  //     theme: ThemeData(
  //       fontFamily: 'Parkinsans',
  //       colorScheme: ColorScheme.fromSeed(seedColor: pokemubPrimaryColor),
  //     ),
  //     debugShowCheckedModeBanner: false,
  //     home: const PackOpen(packId: 2,),
  //   );
  // }
}