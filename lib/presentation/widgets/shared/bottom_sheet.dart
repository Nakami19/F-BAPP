import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/cards/small_card.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
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

     return Container(
      height: MediaQuery.of(context).size.height * 0.5, 
      decoration: BoxDecoration(
        color: primaryScaffoldColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(BorderRadiusValue),
          topRight: Radius.circular(BorderRadiusValue)
        )
      ),
      child: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               const Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Merchant',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(), 
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 10,
                  // childAspectRatio: 1.03,
                ),
                itemCount: 6, // de prueba
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SmallCard(
                    image: '${DataConstant.images_modules}/administration.svg',
                    title: 'Listado de pagos',
                    imageHeight: 45,
                    height: 10,
                    width: 10,
                    textStyle: textStyle.labelMedium,
                    onTap: ()=>{Navigator.pop(context)},// Cierra el BottomSheet
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Onboarding',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(), 
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 10,
                  // childAspectRatio: 1.03,
                ),
                itemCount: 6, // de prueba
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SmallCard(
                    image: '${DataConstant.images_modules}/administration.svg',
                    title: 'Listado de devoluciones',
                    imageHeight: 45,
                    height: 10,
                    width: 10,
                    textStyle: textStyle.labelMedium,
                    onTap: ()=>{Navigator.pop(context)},// Cierra el BottomSheet
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
