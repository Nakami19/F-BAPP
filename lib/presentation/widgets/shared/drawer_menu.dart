import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/others/dialogs.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/presentation/providers/shared/home_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/providers/user/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/app_dialogs.dart';
import 'package:f_bapp/presentation/widgets/shared/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<HomeProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final userProvider = context.watch<UserProvider>();

    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Drawer(
        width: double.infinity,
        clipBehavior: Clip.none,
        // shape: ,
        child: Container(
            decoration: BoxDecoration(
              color: themeProvider.isDarkModeEnabled
                  ? darkColor
                  : primaryScaffoldColor,
              // border: null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  SvgPicture.asset(
                    '${DataConstant.images_chinchin}/chinchin-logo-business-base.svg',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  UserData(),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                        children: userProvider.privileges!.map((privilege) {
                      return GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(
                                context); // Cerrar el Drawer si está abierto
                          }
                          final privilegeActions = privilege.actions; // Acciones del privilegio
                          context.read<UserProvider>().setActions(privilegeActions);
                          Navigator.pushNamed(
                              context, '/${privilege.moduleName}Screen');
                        },
                        child: SizedBox(
                          height: 65,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                '${DataConstant.images_modules}/${privilege.icon}-on.svg',
                                height: 42,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(privilege.moduleName)
                            ],
                          ),
                        ),
                      );
                    }).toList()),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AppDialogs.logoutDialog(context));
                    },
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.logout,
                          size: 29,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Cerrar Sesión")
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
