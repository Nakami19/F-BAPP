import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/screens/home_screen.dart';
import 'package:f_bapp/presentation/screens/profile/profile_screen.dart';
import 'package:f_bapp/presentation/widgets/shared/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customnavbar extends StatefulWidget {
  const Customnavbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex; // Recibe el índice desde el provider
  final ValueChanged<int> onDestinationSelected;

  @override
  State<Customnavbar> createState() => _CustomnavbarState();
}

class _CustomnavbarState extends State<Customnavbar> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(133, 157, 157, 157),
                spreadRadius: 0,
                blurRadius: 10),
          ],
        ),

        margin: const EdgeInsets.only(bottom: 15, right: 25, left: 25),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 1.0), // Para ajustar la altura
            child: NavigationBar(
              indicatorColor: primaryColor,
              indicatorShape: CircleBorder(eccentricity: 0.2),
              selectedIndex: widget.selectedIndex,

              onDestinationSelected: (index) {
                if (index == 2) {

                  _navigateToPage(index, context);

                } else {

                  widget.onDestinationSelected(index); //actualizar el provider

                  _navigateToPage(index, context);
                }
              },

              backgroundColor: Colors.white,

              destinations: const [
                //Opciones del nav bar
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(
                    Icons.home_outlined,
                    color: Color.fromRGBO(234, 234, 234, 1),
                  ),
                  label: 'Home',
                ),

                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_outline,
                      color: Color.fromRGBO(234, 234, 234, 1)),
                  label: 'Perfil',
                ),

                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(
                    Icons.dashboard,
                    color: Color.fromRGBO(234, 234, 234, 1),
                  ),
                  label: 'Módulos',
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPage(int index, BuildContext context) {
    final userProvider = context.read<UserProvider>();
    //se navega dependiendo del indice seleccionado en el navbar
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          homeScreen,
        );
        break;
      case 1:
    
        Navigator.pushReplacementNamed(
          context,
          profileScreen,
        );
        break;
      case 2:
        if (!userProvider.isLoading) {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomSheetModules();
            },
          );
        }

        break;
    }
  }
}
