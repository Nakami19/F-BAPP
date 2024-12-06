import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/presentation/providers/shared/home_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/providers/user/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/customappbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // final homeKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _profileScaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final utilsProvider = context.read<UtilsProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final userProvider = context.read<UserProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final homeKey = context.read<HomeProvider>();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _profileScaffoldKey,
        drawer: DrawerMenu(),
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Customappbar(screenKey: _profileScaffoldKey,)),
        body:  Padding(
         padding: const EdgeInsets.all(30),
         child: Column(
          // mainAxisAlignment: MainAxisAlignment.center
            children: [
              SizedBox(height: 110,),
              UserData(),
              CustomDropdown(
                title: 'Seleccione una compañia *',
                options: userProvider.memberlist!, 
                selectedValue:userProvider.memberlist![0]['idParentRelation'].toString()  ,
                itemValueMapper: (option) => option['idParentRelation'].toString(),
                 itemLabelMapper: (option) => option['name'].toString(),
                onChanged: (value) {
                  print(value);
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
                  image: '${DataConstant.images_profile}/change_password.svg',
                  title: 'Cambiar clave',
                  height: 120,
                  width: 120,
                  imageHeight: 70,
                ),
                SmallCard(
                  image: '${DataConstant.images_profile}/security_questions-on.svg',
                  title: 'Preguntas de seguridad',
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
        bottomNavigationBar: Customnavbar(
          selectedIndex: navProvider.selectedIndex, // Índice actual del NavigationProvider.
          onDestinationSelected: (index) {
            navProvider.updateIndex(index); // Actualiza el índice en el provider.
            // _navigateToPage(index, context); // Navega a la página correspondiente.
          },
        ), 
      ),
    );
  }
}