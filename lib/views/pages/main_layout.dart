import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:pokemu_basic_mobile/viewmodels/main_layout_vm.dart';
import 'package:provider/provider.dart';

import '../../common/constants/colors.dart';
import '../../common/utils/currency_formatter.dart';
import '../../viewmodels/auth_vm.dart';
import '../components/pokemub_text.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final mainLayoutVm = context.watch<MainLayoutVm>();
    final authVm = context.watch<AuthVm>();

    return Scaffold(
      backgroundColor: pokemubBackgroundColor,
      appBar: AppBar(
        backgroundColor: pokemubBackgroundColor,
        leading: IconButton(icon: const Icon(TablerIcons.menu), onPressed: () {  },),
        title: ParkinsansText(text: '@${authVm.currUser?.username ?? 'FAIL_TO_LOAD'}', color: pokemubTextColor, fontSize: 16, fontWeight: FontWeight.bold),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                ParkinsansText(text: CurrencyFormatter.formatCoin(authVm.currUser?.coinBalance ?? 0), color: pokemubTextColor, fontSize: 16, fontWeight: FontWeight.bold),
                const SizedBox(width: 8,),
                Image.asset('assets/images/coin.png', fit: BoxFit.cover, height: 24,),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: pokemubTextColor,
            height: 2.0,
          ),
        ),
        bottomOpacity: 0.4,
      ),
      body: IndexedStack(
        index: mainLayoutVm.currIndex,
        children: mainLayoutVm.pages, // danh sach page (lay tu vm)
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          currentIndex: mainLayoutVm.currIndex,
          onTap: (index) {
            context.read<MainLayoutVm>().changeTab(index);
            //// same as
            // final vm2 = context.read<MainLayoutVm>();
            // vm2.changeTab(index);
          },
          backgroundColor: pokemubBackgroundColor,
          selectedItemColor: pokemubPrimaryColor,
          unselectedItemColor: pokemubTextColor,
          type: BottomNavigationBarType.fixed, // kieu animation
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SvgPicture.asset(
                  'assets/icons/card_pack.svg',
                  colorFilter: ColorFilter.mode(
                    mainLayoutVm.currIndex == 0 ? pokemubPrimaryColor : pokemubTextColor,
                    BlendMode.srcIn
                  ),
                  width: 20, // Set kích thước icon
                  height: 20,
                ),
              ),
              label: 'My Vault'
            ),
            const BottomNavigationBarItem(
              icon: Icon(TablerIcons.smart_home),
              label: 'Home'
            ),
            const BottomNavigationBarItem(
              icon: Icon(TablerIcons.building_store),
              label: 'Shop'
            ),
          ],
        ),
      ),
    );
  }
}