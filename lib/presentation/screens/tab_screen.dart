import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/presentation/providers/shared/home_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
    });
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  final homeKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final utilsProvider = context.read<UtilsProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    return  WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: homeKey,
        drawer: DrawerMenu(),
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(150), 
    child: AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          // Imagen de fondo
          Image.asset(
            '${DataConstant.images}/background.png',
            // fit: BoxFit.cover,
          ),
          Positioned(
  left: 0,
  right: 0,
  top: 50, 
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16), // Separación lateral
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          '${DataConstant.images_chinchin}/chinchin-logo-business-base.svg',
          height: 40, 
          fit: BoxFit.contain,
        ),
        IconButton(
          tooltip: 'Menú',
          icon: Icon(
            Icons.menu, color: Colors.black,
            size: 30,
            ),
          onPressed: () {
            homeKey.currentState!.openDrawer();            
          },
        ),
      ],
    ),
  ),
),
        ],
      ),
    ),
  ),
        body: homeProvider.getView(homeProvider.selectedScreen),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 70,
            decoration:const  BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(BorderRadiusValue)),
              boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(133, 157, 157, 157),
                            spreadRadius: 0,
                            blurRadius: 10),
                      ],
            ),
            margin: const EdgeInsets.only(bottom: 15, right: 25, left: 25),
            child: ClipRRect(
               borderRadius: BorderRadius.all(Radius.circular(BorderRadiusValue)),
              child: Padding(
            padding: const EdgeInsets.only(bottom: 1.0), // Para ajustar la altura
            child: NavigationBar(
              
              selectedIndex: homeProvider.selectedScreen.index,
              onDestinationSelected: (int index) => {
                if (index ==2) {
            
                } else {
                  homeProvider.changeScreen(Views.values[index])
                }        
              },
              indicatorColor: primaryColor, // Color del indicador
              backgroundColor: Colors.white, // Color del fondo
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_outlined,),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
                      NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Modules',
                ),
              ],
            ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}