import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/infrastructure/classes/modules/privileges.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
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
      decoration: const BoxDecoration(
          color: primaryScaffoldColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadiusValue),
              topRight: Radius.circular(borderRadiusValue))),

      child: Column(
        children: [
          //header con el icono de flecha
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadiusValue),
                topRight: Radius.circular(borderRadiusValue),
              ),
            ),

            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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

          //Contenido del bottom sheet
          Expanded(
            child: userProvider.isLoading
                ? Container(height:MediaQuery.of(context).size.height * 0.5 , child: Center(child: CircularProgressIndicator()))
                : 
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  //Se mapea cada privilegio
                  children: userProvider.privileges!.map((privilege) {

                    //acciones que deben mostrarse
                    final showactions = privilege.actions.where((action) => action.showInMenu == true).toList();

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

                        // Tarjetas con las acciones del privilegio
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: showactions.length,
                          itemBuilder: (context, index) {
                            final action = showactions[index];
                           
                              return SmallCard(
                              image: '${DataConstant.imagesModules}/${privilege.icon}/chinchin-${action.key}_${privilege.icon}-on.svg',
                              // placeholder:'${DataConstant.images_modules}/${privilege.icon}-on.svg' ,
                              title: action.actionName,
                              imageHeight: 45,
                              textStyle: textStyle.labelSmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                              onTap: () {
                                // Acción al presionar la tarjeta
                                Navigator.pop(context);
                                final privilegeActions = privilege.actions; // Acciones del privilegio
                                context.read<UserProvider>().setActions(privilegeActions);
                                Navigator.pushNamed(context, "/${action.actionName}Screen");
                              },
                            );
                            
                          },
                        ),
                      ],
                    );
                  }).toList()
                       
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
