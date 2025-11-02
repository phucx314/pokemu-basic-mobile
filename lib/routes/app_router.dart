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

      final publicRoutes = {
        NamedRoutes.login,
        NamedRoutes.register,
      };

      if (state.matchedLocation == NamedRoutes.splash) return null; // if at splash, let it run

      if (!isAuthenticated) {
        if (publicRoutes.contains(state.matchedLocation)) {
          return null;
        }

        // kick to login page when at private routes and not authenticated
        return NamedRoutes.login;
      } 

      if (isAuthenticated) {
        // kick to home page when at public routes but is authenticated
        if (publicRoutes.contains(state.matchedLocation)) {
          return NamedRoutes.home;
        }

        return null;
      }

      return null; 
    },
  );
}