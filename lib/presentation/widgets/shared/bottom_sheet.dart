import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/infrastructure/auth/privileges.dart';
import 'package:f_bapp/presentation/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetModules extends StatefulWidget {
  const BottomSheetModules({super.key});

  @override
  State<BottomSheetModules> createState() => _BottomSheetModulesState();
}

class _BottomSheetModulesState extends State<BottomSheetModules> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final userProvider = context.watch<UserProvider>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
          color: primaryScaffoldColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(BorderRadiusValue),
              topRight: Radius.circular(BorderRadiusValue))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //header con el icono de flecha
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(BorderRadiusValue),
                  topRight: Radius.circular(BorderRadiusValue),
                ),
              ),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max, //min
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const SizedBox(height: 10),
                      //* icono
                      GestureDetector(
                        child: const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )),
            ),
            userProvider.isLoading
                ? Container(height:MediaQuery.of(context).size.height * 0.5 , child: Center(child: CircularProgressIndicator()))
                : 
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: userProvider.privileges!.map((privilege) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título del privilegio
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          privilege.moduleName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Grid con las acciones del privilegio
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: privilege.actions.length,
                        itemBuilder: (context, index) {
                          final action = privilege.actions[index];
                          return SmallCard(
                            image: '${DataConstant.images_modules}/${action.key}_operations.svg',
                            title: action.actionName,
                            imageHeight: 40,
                            // height: 200,
                            // width: 100,
                            textStyle: textStyle.labelSmall,
                            onTap: () {
                              // Acción al presionar la tarjeta
                              Navigator.pop(context);
                              print('Navegar a ${action.page}');
                              Navigator.pushNamed(context, action.page);
                            },
                          );
                        },
                      ),
                    ],
                  );
                }).toList()
   
              ),
            ),
          ],
        ),
      ),
    );
  }
}
