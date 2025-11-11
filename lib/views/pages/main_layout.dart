import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemu_basic_mobile/routes/named_routes.dart';
import 'package:pokemu_basic_mobile/viewmodels/main_layout_vm.dart';
import 'package:pokemu_basic_mobile/views/components/pokemub_button.dart';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _onAvatarTapMenu(context);
                  },
                  child: Image.network(
                    authVm.currUser?.avatar ?? '', 
                    fit: BoxFit.cover, 
                    height: 24,
                  ),
                ),
                const SizedBox(width: 8,),
                ParkinsansText(text: '@${authVm.currUser?.username ?? 'FAIL_TO_LOAD'}', color: pokemubTextColor, fontSize: 16, fontWeight: FontWeight.bold),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/coin.png', fit: BoxFit.cover, height: 24,),
                  const SizedBox(width: 8,),
                  ParkinsansText(text: CurrencyFormatter.formatCoin(authVm.currUser?.coinBalance ?? 0), color: pokemubTextColor, fontSize: 16, fontWeight: FontWeight.bold, textOverflow: TextOverflow.ellipsis,),
                  const SizedBox(width: 8,),
                  PokemubButton(
                    height: 20,
                    width: 20,
                    label: '', 
                    onTap: () {}, 
                    hasBorder: true, 
                    hasIcon: true, 
                    borderColor: pokemubTextColor, 
                    borderWidth: 1, 
                    fillColor: pokemubBackgroundColor, 
                    icon: TablerIcons.plus,
                    iconSize: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
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

  void _onAvatarTapMenu(BuildContext avatarContext) {
    showModalBottomSheet(
      context: avatarContext, 
      builder: (context) {
        return Container(
          color: pokemubBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: MomoSignatureText(text: 'Menu', color: pokemubTextColor, fontWeight: FontWeight.bold, fontSize: 24,),
              ),
              const SizedBox(height: 16,),
              PokemubMenuItem(icon: TablerIcons.user_hexagon, label: 'My profile', onTap: () {},),
              PokemubMenuItem(icon: TablerIcons.logout_2, label: 'Log out', onTap: () => _logout(context), labelAndIconColor: pokemubPrimaryColor,),
              const SizedBox(height: 16,),
            ],
          ),
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    final vm = context.read<AuthVm>();

    await vm.logout();

    if (context.mounted) {
      if (Navigator.of(context).canPop()) {
        Navigator.pop(context);
      }
      
      context.go(NamedRoutes.login);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const ParkinsansText(text: 'Logged out'), backgroundColor: pokemubTextColor10,));
    }
  }
}

class PokemubMenuItem extends StatelessWidget {
  const PokemubMenuItem({super.key, this.icon = TablerIcons.a_b, this.label = 'Menu item', required this.onTap, this.isDisabled = false, this.labelAndIconColor = pokemubTextColor});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDisabled;
  final Color labelAndIconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        color: pokemubBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: labelAndIconColor,),
              const SizedBox(width: 16,),
              ParkinsansText(text: label, color: labelAndIconColor,),
            ],
          ),
        ),
      ),
    );
  }
}