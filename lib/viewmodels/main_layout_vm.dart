import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/services/auth_service.dart';
import 'package:pokemu_basic_mobile/views/pages/shop.dart';

import '../views/pages/home.dart';
import '../views/pages/my_vault.dart';

class MainLayoutVm extends ChangeNotifier {
  final AuthService _authService = AuthService();

  int _currIndex = 1; // vi home o giua 
  int get currIndex => _currIndex;

  final List<Widget> pages = [
    const MyVault(),
    const Home(),
    const Shop(),
  ];

  // ham update index va thong bao cho UI
  void changeTab(int index) {
    if (_currIndex == index) return; // ko lam j ca khi bam vao tab hien tai
    _currIndex = index;
    notifyListeners();
  }

  // go to vault de trang gacha result nav toi
  void goToVault() {
    changeTab(0);
  }
}