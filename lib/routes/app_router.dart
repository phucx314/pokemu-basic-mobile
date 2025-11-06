import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/routes/named_routes.dart';
import 'package:pokemu_basic_mobile/viewmodels/auth_vm.dart';
import 'package:pokemu_basic_mobile/views/pages/create_account.dart';
import 'package:pokemu_basic_mobile/views/pages/gacha_result.dart';
import 'package:pokemu_basic_mobile/views/pages/login_page.dart';
import 'package:pokemu_basic_mobile/views/pages/main_layout.dart';
import 'package:pokemu_basic_mobile/views/pages/splash.dart';

import '../models/card.dart' as model;
import '../views/pages/pack_open.dart';

class AppRouter {
  final AuthVm authVm;

  AppRouter(this.authVm);

  late final GoRouter router = GoRouter(
    refreshListenable: authVm, // lý do chỉ có authVm.getMe() làm trang đó bị rebuilt (còn các method thuộc các vm khác thì ko) -> gây extra bị null -> lỗi
    routes: [
      GoRoute(path: NamedRoutes.splash, builder: (context, state) => const Splash(),),
      GoRoute(path: NamedRoutes.login, builder: (context, state) { 
        debugPrint('🪲 [Route ${state.matchedLocation}] extra=${state.extra} type=${state.extra?.runtimeType}');

          final username = state.uri.queryParameters['username'];
          return LoginPage(username: username);
        },
      ),
      GoRoute(path: NamedRoutes.register, builder: (context, state) => const CreateAccount(),),
      GoRoute(path: NamedRoutes.mainLayout, builder: (context, state) => const MainLayout(),),
      GoRoute(path: '${NamedRoutes.packOpen}/:packId', builder: (context, state) {
        debugPrint('🪲 [Route ${state.matchedLocation}] extra=${state.extra} type=${state.extra?.runtimeType}');

        final packId = int.parse(state.pathParameters['packId']!);
        final packName = state.extra as String;
        return PackOpen(packId: packId, packName: packName,);
      }),
      GoRoute(path: NamedRoutes.gachaResult, builder: (context, state) {
        debugPrint('🪲 [Route ${state.matchedLocation}] extra=${state.extra} type=${state.extra?.runtimeType}');

        final data = state.extra as Map<String, dynamic>;
        final cards = data['cards'] as List<model.Card>;
        final packId = data['packId'] as int;
        final packName = data['packName'] as String;
        return GachaResult(packId: packId, rolledCards: cards, packName: packName,);
      }),
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
          return NamedRoutes.mainLayout;
        }

        return null;
      }

      return null; 
    },
  );
}