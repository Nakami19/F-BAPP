import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/cards/information_card.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final String orderId;
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final GlobalKey<ScaffoldState> _orderScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      drawer: DrawerMenu(),
      key: _orderScaffoldKey,
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          Future.delayed(Duration(milliseconds: navProvider.showNavBarDelay),
              () {
            navProvider.updateShowNavBar(true);
          });
        } else {
          navProvider.updateShowNavBar(false);
        }
      },
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Screensappbar(
            title: 'Detalle de orden',
            screenKey: _orderScaffoldKey,
            poproute: listmerchantordersScreen,
          )),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Row(
                children: [

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: CustomButton(
                        title: 'Reversar Orden', 
                        isPrimaryColor: false,
                        colorFilledButton: errorColor, 
                        icon: Icons.refresh_rounded,
                        isOutline: false, 
                        onTap: (){}, 
                        provider: GeneralProvider()
                        ),
                      ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: CustomButton(
                        title: 'Compartir', 
                        isPrimaryColor: true,
                        icon: Icons.share,
                        iconColor: primaryColor,
                        isOutline: true, 
                        onTap: (){}, 
                        provider: GeneralProvider()
                        ),
                      ),
                  ),

                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: InformationCard(title: "Detalle de orden ${widget.orderId}", texts: [
                  {'label': 'Monto: ', 'value': '100'},
                  {'label': 'Balance: ', 'value': '0'},
                  {'label': 'Comision delegada: ', 'value': 'No'},
                  {'label': 'Fecha de creacion: ', 'value': '19/12/2024 5:46 PM'},
                  {'label': 'Fecha de expiracion: ', 'value': '15/09/33713 7:33 PM'},
                  {'label': 'Estado: ', 'value': 'Activo'},
                  {'label': 'Sucursal: ', 'value': 'Mcdonalds'},
                  {'label': 'Esatdo de reverso: ', 'value': 'N/A'},
                  {'label': 'Tipo de pago: ', 'value': 'pasarela'},
                ]),
              ),
        
              SizedBox(height: 20,),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: InformationCard(title: 'Datos del usuario', texts: [
                  {'label': 'Monto: ', 'value': '100'},
                  {'label': 'Balance: ', 'value': '0'},
                  {'label': 'Comision delegada: ', 'value': 'No'},
                  {'label': 'Fecha de creacion: ', 'value': '19/12/2024 5:46 PM'},
                  {'label': 'Fecha de expiracion: ', 'value': '15/09/33713 7:33 PM'},
                  {'label': 'Estado: ', 'value': 'Activo'},
                  {'label': 'Sucursal: ', 'value': 'Mcdonalds'},
                  {'label': 'Esatdo de reverso: ', 'value': 'N/A'},
                  {'label': 'Tipo de pago: ', 'value': 'pasarela'},
                ]),
              ),
        
              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(
                                context,
                                '/Historial de pagos',
                              );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Historial de pagos",
                      style: textStyle.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600
                      ),
                      ),
                  
                      SizedBox(width: 10,),
                  
                      Icon(
                        Icons.arrow_forward
                      )
                    ],
                  ),
                ),
              )
            ]
          ),
        ),
      )
    );
  }
}
