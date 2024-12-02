import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final utilsProvider = context.read<UtilsProvider>();
    final themeProvider = context.watch<ThemeProvider>();


    String userNameCapitalize =
        '${utilsProvider.personName} ${utilsProvider.personLastName}';
    return Scaffold(
      extendBodyBehindAppBar: true,
      body:  Padding(
       padding: const EdgeInsets.all(30),
       child: Column(
        // mainAxisAlignment: MainAxisAlignment.center
          children: [
            SizedBox(height: 110,),
            Padding(
              padding: const EdgeInsets.symmetric( vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_circle,
                    color: primaryColor,
                    size: 40,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    '${userNameCapitalize}\n${utilsProvider.userName}',
                    style: textStyle.titleSmall,
                  ),
                ],
              ),
            ),
            CustomDropdown(
              title: 'Seleccione una compañia *',
              options: ["A",'B','C'], 
              onChanged: (value) {
                
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
                image: '${DataConstant.images_profile}/change_password-on.svg',
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
    );
  }
}