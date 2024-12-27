import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/presentation/providers/auth/login_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/dashboard_appbar.dart';
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
  final GlobalKey<ScaffoldState> _profileScaffoldKey =
      GlobalKey<ScaffoldState>();
  String? selectedCompany;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final loginProvider = context.read<LoginProvider>();
    final textStyle = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _profileScaffoldKey,
        drawer: DrawerMenu(),
        onDrawerChanged: (isOpened) {
          if (!isOpened) {
            Future.delayed( Duration(milliseconds: navProvider.showNavBarDelay), () {
              navProvider.updateShowNavBar(true);
            });
          } else {
            navProvider.updateShowNavBar(false);
          }
        },
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: DashboardAppbar(
              screenKey: _profileScaffoldKey,
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
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  padding: EdgeInsets.only(bottom: 10, left: 8, right: 8),
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  children: [
                    SmallCard(
                      image:
                          '${DataConstant.imagesProfile}/chinchin-change_password-on.svg',
                      title: 'Cambiar clave',
                      width: 120,
                      imageHeight: 70,
                      textStyle: textStyle.bodyMedium!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SmallCard(
                      image:
                          '${DataConstant.imagesProfile}/chinchin-security_questions-on.svg',
                      title: 'Preguntas de seguridad',
                      width: 120,
                      imageHeight: 70,
                      textStyle: textStyle.bodyMedium!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
        ),
        // bottomNavigationBar: Customnavbar(
        //   selectedIndex: navProvider
        //       .selectedIndex, // Índice actual del NavigationProvider.
        //   onDestinationSelected: (index) {
        //     navProvider
        //         .updateIndex(index); // Actualiza el índice en el provider.
        //   },
        // ),
      ),
    );
  }
}
