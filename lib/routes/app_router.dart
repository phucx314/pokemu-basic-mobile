import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/routes/named_routes.dart';
import 'package:pokemu_basic_mobile/viewmodels/auth_vm.dart';
import 'package:pokemu_basic_mobile/views/pages/create_account.dart';
import 'package:pokemu_basic_mobile/views/pages/login_page.dart';
import 'package:pokemu_basic_mobile/views/pages/main_layout.dart';
import 'package:pokemu_basic_mobile/views/pages/splash.dart';

class AppRouter {
  final AuthVm authVm;

  AppRouter(this.authVm);

  late final GoRouter router = GoRouter(
    refreshListenable: authVm,
    routes: [
      GoRoute(path: NamedRoutes.splash, builder: (context, state) => const Splash(),),
      GoRoute(path: NamedRoutes.login, builder: (context, state) => const LoginPage(),),
      GoRoute(path: NamedRoutes.register, builder: (context, state) => const CreateAccount(),),
      GoRoute(path: NamedRoutes.home, builder: (context, state) => const MainLayout(),),
    ],
    redirect: (context, state) {
      final isAuthenticated = authVm.isAuthenticated;
      final isAtSplash = state.matchedLocation == NamedRoutes.splash;
      final isAtLogin = state.matchedLocation == NamedRoutes.login;
      final isAtRegister = state.matchedLocation == NamedRoutes.register;

      if (isAtSplash) return null; // if at splash, let it run

      if (!isAuthenticated && !isAtLogin && !isAtRegister) return NamedRoutes.login; // kick to login page

      if (isAuthenticated && (isAtLogin || isAtRegister)) return NamedRoutes.home;

      return null; 
    },
  );
}