import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/others/custom_skeleton.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:f_bapp/presentation/providers/auth/login_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/providers/user/user_provider.dart';
import 'package:f_bapp/presentation/widgets/graphics/bar_graphic.dart';
import 'package:f_bapp/presentation/widgets/graphics/pie_graphic.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/dashboardAppbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final keyValueStorageService = SecureStorageService();
  final GlobalKey<ScaffoldState> _homeScaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedCompany;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final utilsProvider = context.read<UtilsProvider>();
      
      context.read<NavigationProvider>().updateIndex(0);


      //se obtiene la informacion del usuario
      if (!utilsProvider.isLoading) {
        await utilsProvider.getUserinfo();
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final userProvider = context.watch<UserProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final loginProvider = context.read<LoginProvider>();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _homeScaffoldKey,
        drawer: DrawerMenu(),
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: DashboardAppbar(
              screenKey: _homeScaffoldKey,
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 110,
              ),
              UserData(),
        
              // esta cargando/no ha cargado
              if (userProvider.isLoading) ...[
                SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                CustomSkeleton(height: 60),
                SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
              ],
        
              //ya cargo
              if (!userProvider.isLoading)
                CustomDropdown(
                    title: 'Seleccione una compañia *',
                    options: userProvider.memberlist!, //se obtiene la lista de miembros
                    selectedValue: navProvider.selectedCompany, //se muestra la compañia seleccionada 
                    autoSelectFirst: true,
                    itemValueMapper: (option) => //se envian el valor que tendra cada opcion
                        option['idParentRelation'].toString(),
                    itemLabelMapper: (option) => option['name'].toString(), //se envia el label de la opcion a mostrarse 
                    onChanged: (value) {
                      setState(() {
                        navProvider.updateCompany(
                            value!); // Actualizar el valor seleccionado.
                      });
                      userProvider.getMemberTypeChangeList( //se actualiza la lista de miembros
                          value!, loginProvider.userLogin!);
                    },
                    showError: true,
                    errorText: 'error'),

              SizedBox(
                height: 10,
              ),

              if (userProvider.isLoading) ...[
                SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                CustomSkeleton(height: 335),
                SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
              ],

              //ya cargo
              if (!userProvider.isLoading)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Graphic(),

                        SizedBox(height: 10,),

                        PieGraphic2(),

                        // SizedBox(height: 20,),

                        Text("Módulos", 
                        style: textStyle.bodyMedium!.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                        SizedBox(height: 10,),


                        GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    padding: EdgeInsets.only(bottom: 10, left: 1, right: 3, top: 5), //el padding hace que no muestren al final de la pantalla
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: userProvider.privileges!.map((privilege) {
                      return SmallCard(
                        image:
                            '${DataConstant.imagesModules}/${privilege.icon}/chinchin-${privilege.icon}-on.svg',
                        placeholder:'${DataConstant.imagesModules}/${privilege.icon}}/chinchin-${privilege.icon}-on.svg' ,
                        title: privilege.moduleName,
                        height: 120,
                        width: 130,
                        imageHeight: 70,
                        textStyle: textStyle.bodyMedium!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                        onTap: () {
                          final privilegeActions = privilege.actions; // Acciones del privilegio
                          context.read<UserProvider>().setActions(privilegeActions);
                          Navigator.pushNamed(
                              context, '/${privilege.moduleName}Screen');
                        },
                      );
                    }).toList(),
                  ),
                      ],
                    )
                    )
                  ),
                                      
          
            ],
          ),
        ),
        bottomNavigationBar: Customnavbar(
          selectedIndex: navProvider.selectedIndex,
          onDestinationSelected: (index) {
            navProvider.updateIndex(index);
          },
        ),
      ),
    );
  }

  
}
