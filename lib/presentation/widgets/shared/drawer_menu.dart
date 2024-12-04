import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/others/dialogs.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/presentation/providers/shared/home_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<HomeProvider>();
    final themeProvider = context.watch<ThemeProvider>();

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
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              '${DataConstant.images_modules}/onboarding.svg',
                              height: 40,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Onboarding")
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              '${DataConstant.images_modules}/administration.svg',
                              height: 40,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Administracion")
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () => {},
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                '${DataConstant.images_modules}/operations-on.svg',
                                height: 40,
                                // color: primaryColor,
                                colorFilter: null,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Operaciones")
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialogs.logoutDialog(context));
                    },
                    child: const Row(
                      children: [
                        SizedBox(width: 5,),
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
