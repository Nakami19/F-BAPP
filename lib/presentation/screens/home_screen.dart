import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/infrastructure/shared/secure_storage_service.dart';
import 'package:f_bapp/presentation/providers/auth/login_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/widgets/graphics/bar_graphic.dart';
import 'package:f_bapp/presentation/widgets/graphics/pie_graphic.dart';
import 'package:f_bapp/presentation/widgets/shared/dashboard_appbar.dart';
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
        onDrawerChanged: (isOpened) {
          if (!isOpened) {
            // final navProvider = context.read<NavigationProvider>();
            Future.delayed(Duration(milliseconds: navProvider.showNavBarDelay), () {
              navProvider.updateShowNavBar(true);
            });
          } else {
            navProvider.updateShowNavBar(false);
          }
        },
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize:  Size.fromHeight(150 + MediaQuery.of(context).padding.top),
            child: DashboardAppbar(
              screenKey: _homeScaffoldKey,
            )),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 110,
              ),

              UserData(),

              // esta cargando/no ha cargado
              if (userProvider.isLoading) ...[
                //skeleton del dropdown
                const SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                const CustomSkeleton(height: 60),
                const SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
              ],

              //ya cargo
              if (!userProvider.isLoading)
                CustomDropdown(
                    title: 'Seleccione una compañia *',
                    options: userProvider
                        .memberlist!, //se obtiene la lista de miembros
                    selectedValue: navProvider
                        .selectedCompany, //se muestra la compañia seleccionada
                    autoSelectFirst: true,
                    //se recibe el objeto que contiene los key idParentRelation y name, y sus valores
                    itemValueMapper: (option) => option['idParentRelation']
                        .toString(), //retorna el valor
                    itemLabelMapper: (option) =>
                        option['name'].toString(), //retorna el label
                    onChanged: (value) {
                      setState(() {
                        navProvider.updateCompany(
                            value!); // Actualizar el valor seleccionado.
                      });
                      userProvider.getMemberTypeChangeList(
                          //se actualiza la lista de miembros
                          value!,
                          loginProvider.userLogin!);
                    },
                    showError: true,
                    errorText: 'error'),

              const SizedBox(
                height: 10,
              ),

              // esta cargando/no ha cargado
              if (userProvider.isLoading) ...[
                //skeleton de las graficas
                const SizedBox(
                  height: 10,
                  width: double.infinity,
                ),

                const CustomSkeleton(height: 335),

                const SizedBox(
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
                    //Graficos
                    const Graphic(),

                    const SizedBox(
                      height: 10,
                    ),

                    const PieGraphic2(),

                    //Tarjetas de modulos
                    Text(
                      "Módulos",
                      style: textStyle.bodyMedium!
                          .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //Se generan las tarjetas
                    GridView.count(
                      crossAxisCount: 2, //2 tarjetas por fila
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      padding: EdgeInsets.only(
                          bottom: 10,
                          left: 1,
                          right: 3,
                          top:
                              5), //el padding bottom hace que no muestren al final de la pantalla
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: userProvider.privileges!.map((privilege) {
                        return SmallCard(
                          image:
                              '${DataConstant.imagesModules}/${privilege.icon}/chinchin-${privilege.icon}-on.svg',
                          placeholder:
                              '${DataConstant.imagesModules}/${privilege.icon}/chinchin-${privilege.icon}-on.svg',
                          title: privilege.moduleName,
                          height: 120,
                          width: 130,
                          imageHeight: 70,
                          textStyle: textStyle.bodyMedium!.copyWith(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          onTap: () {
                            final privilegeActions = privilege
                                .actions; // Se establecen las acciones del privilegio
                            context
                                .read<UserProvider>()
                                .setActions(privilegeActions);
                            Navigator.pushNamed(
                                context, '/${privilege.moduleName}Screen');
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ))),
            ],
          ),
        ),
        // bottomNavigationBar: Customnavbar(
        //   selectedIndex: navProvider.selectedIndex,
        //   onDestinationSelected: (index) {
        //     navProvider.updateIndex(index);
        //   },
        // ),
      ),
    );
  }
}
