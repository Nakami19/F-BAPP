import 'dart:io';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/others/snackbars.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/screens/tab_screen.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final keyValueStorageService = SecureStorageService();
  final homeKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      // key: homeKey,
      // drawer: DrawerMenu(),
      extendBodyBehindAppBar: true,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(150), 
//     child: AppBar(
//       backgroundColor: Colors.transparent,
//       automaticallyImplyLeading: false,
//       flexibleSpace: Stack(
//         children: [
//           // Imagen de fondo
//           Image.asset(
//             '${DataConstant.images}/background.png',
//             // fit: BoxFit.cover,
//           ),
//           Positioned(
//   left: 0,
//   right: 0,
//   top: 50, 
//   child: Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16), // Separación lateral
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SvgPicture.asset(
//           '${DataConstant.images_chinchin}/chinchin-logo-business-base.svg',
//           height: 40, 
//           fit: BoxFit.contain,
//         ),
//         IconButton(
//           tooltip: 'Menú',
//           icon: Icon(
//             Icons.menu, color: Colors.black,
//             size: 30,
//             ),
//           onPressed: () {
//             homeKey.currentState!.openDrawer();            
//           },
//         ),
//       ],
//     ),
//   ),
// ),
//         ],
//       ),
//     ),
//   ),
      body: 
     Padding(
       padding: const EdgeInsets.all(30),
       child: Column(
        // mainAxisAlignment: MainAxisAlignment.center
          children: [
            SizedBox(height: 110,),
            Padding(
              padding: const EdgeInsets.symmetric( vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_circle,
                    color: primaryColor,
                    size: 40,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Pedro Perez\n@usuario-14',
                    style: textStyle.titleSmall,
                  ),
                ],
              ),
            ),
            CustomDropdown(
              title: 'Seleccione una compañia *',
              options: ["A",'B','C'], 
              onChanged: (value) {
                
              }, 
              showError: true, 
              errorText: 'error'),
            
            SizedBox(height: 20,),
      
        Flexible(
          flex: 2,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            padding: EdgeInsets.all(10), 
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(), 
            children: [
              SmallCard(
                image: '${DataConstant.images_modules}/merchant.svg',
                title: 'Merchant',
                height: 120,
                width: 120,
                imageHeight: 70,
              ),
              SmallCard(
                image: '${DataConstant.images_modules}/operations-on.svg',
                title: 'Merchant',
                height: 120,
                width: 120,
                imageHeight: 70,
              ),
              SmallCard(
                image: '${DataConstant.images_modules}/onboarding-white.svg',
                title: 'Merchant',
                height: 120,
                width: 120,
                imageHeight: 70,
              ),
              SmallCard(
                image: '${DataConstant.images_modules}/merchant.svg',
                title: 'Merchant',
                height: 120,
                width: 120,
                imageHeight: 70,
              ),
            ],
          ),
        ),  
          
          ],
        ),
     ),
    //  bottomNavigationBar: BottomNavBar(),
    );
  }
}