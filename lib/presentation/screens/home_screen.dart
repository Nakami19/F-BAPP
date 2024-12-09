import 'dart:io';
import 'package:f_bapp/app.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/others/custom_skeleton.dart';
import 'package:f_bapp/common/widgets/others/snackbars.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:f_bapp/presentation/providers/auth/login_provider.dart';
import 'package:f_bapp/presentation/providers/shared/home_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/providers/user/user_provider.dart';
import 'package:f_bapp/presentation/screens/tab_screen.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/dashboardAppbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/user_data.dart';
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
  final GlobalKey<ScaffoldState> _homeScaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedCompany;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final utilsProvider = context.read<UtilsProvider>();
      final userProvider = context.read<UserProvider>();
      context.read<NavigationProvider>().updateIndex(0);

      // selectedCompany = userProvider.memberlist![0]['idParentRelation'].toString();

      //se obtiene la informacion del usuario
      if (!utilsProvider.isLoading) {
        final res = await utilsProvider.getUserinfo();
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

    if (userProvider.shouldShowError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Snackbars.customSnackbar(
          navigatorKey.currentContext!,
          title: userProvider.errorMessage ?? "Error",
          message: userProvider.trackingCode ?? "",
        );
      });
    }

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
          padding: const EdgeInsets.all(30),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center
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
                    options: userProvider.memberlist!,
                    selectedValue: navProvider.selectedCompany,
                    itemValueMapper: (option) =>
                        option['idParentRelation'].toString(),
                    itemLabelMapper: (option) => option['name'].toString(),
                    onChanged: (value) {
                      setState(() {
                        navProvider.updateCompany(
                            value!); // Actualizar el valor seleccionado.
                      });
                      userProvider.getMemberTypeChangeList(
                          value!, loginProvider.userLogin!);
                    },
                    showError: true,
                    errorText: 'error'),
              SizedBox(
                height: 20,
              ),
              // userProvider.isLoading
              //   ? Container( height: MediaQuery.of(context).size.height/2.5,  child: Center(child: CircularProgressIndicator()))
              //   :

              if (userProvider.isLoading) ...[
                const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomSkeleton(
                          height: 150,
                          width: 140,
                        ),
                        SizedBox(
                          width: 20,
                          height: 20,
                        ),
                        CustomSkeleton(
                          height: 150,
                          width: 140,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomSkeleton(
                          height: 150,
                          width: 140,
                        ),
                        SizedBox(
                          width: 20,
                          height: 20,
                        ),
                        CustomSkeleton(
                          height: 150,
                          width: 140,
                        ),
                      ],
                    ),
                  ],
                ),
              ],

              if (!userProvider.isLoading)
                Flexible(
                  flex: 2,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    padding: EdgeInsets.only(bottom: 10, left: 8, right: 8), //el padding hace que no muestren al final de la pantalla
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    children: userProvider.privileges!.map((privilege) {
                      return SmallCard(
                        image:
                            '${DataConstant.images_modules}/${privilege.icon}-on.svg',
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
