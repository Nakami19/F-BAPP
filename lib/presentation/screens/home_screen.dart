import 'dart:io';
import 'package:f_bapp/app.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/others/snackbars.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/providers/user/user_provider.dart';
import 'package:f_bapp/presentation/screens/tab_screen.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/customappbar.dart';
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
  final homeKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final utilsProvider = context.read<UtilsProvider>();
      final userProvider = context.read<UserProvider>();

    print(userProvider.privileges);

      print(utilsProvider.haveErrors);
      print("IIIIIIIIIIIIIIIIIIIIIIIIIIIIII");

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
    final utilsProvider = context.read<UtilsProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final userProvider = context.watch<UserProvider>();
    final navProvider = context.watch<NavigationProvider>();


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
        key: homeKey,
        drawer: DrawerMenu(),
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Customappbar(screenkey: homeKey)),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center
            children: [
              SizedBox(
                height: 110,
              ),
              UserData(),
              CustomDropdown(
                  title: 'Seleccione una compañia *',
                  options: userProvider.memberlist!,
                  selectedValue:
                      userProvider.memberlist![0]['idParentRelation'].toString(),
                  itemValueMapper: (option) =>
                      option['idParentRelation'].toString(),
                  itemLabelMapper: (option) => option['name'].toString(),
                  onChanged: (value) {
                    print(value);
                  },
                  showError: true,
                  errorText: 'error'),
              SizedBox(
                height: 20,
              ),
              Flexible(
                flex: 2,
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  children: userProvider.privileges!.map((privilege) {
                    return SmallCard(
                      image: '${DataConstant.images_modules}/${privilege.icon}.svg',
                      title: privilege.moduleName,
                      height: 120,
                      width: 130,
                      imageHeight: 70,
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
